import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../../../core/storage/secure_storage_service.dart';

/// WebSocket connection states
enum WebSocketState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// WebSocket message types from the API documentation
enum WebSocketMessageType {
  // Connection
  connectionEstablished,
  heartbeat,
  heartbeatAck,
  
  // Conversation management
  joinConversation,
  leaveConversation,
  conversationJoined,
  
  // Messaging
  newMessage,
  messageRead,
  messageReadReceipt,
  
  // Real-time features
  typingStart,
  typingStop,
  userTyping,
  onlineStatus,
  getOnlineStatus,
  
  // Error handling
  error,
}

/// WebSocket message wrapper
class WebSocketMessage {
  final WebSocketMessageType type;
  final Map<String, dynamic> data;
  final String? conversationId;
  final String? userId;
  final String? messageId;
  final DateTime timestamp;

  WebSocketMessage({
    required this.type,
    required this.data,
    this.conversationId,
    this.userId,
    this.messageId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = _parseMessageType(typeString);
    
    return WebSocketMessage(
      type: type,
      data: json['data'] ?? json,
      conversationId: json['conversation_id'] as String?,
      userId: json['user_id'] as String?,
      messageId: json['message_id'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': _messageTypeToString(type),
      'data': data,
      if (conversationId != null) 'conversation_id': conversationId,
      if (userId != null) 'user_id': userId,
      if (messageId != null) 'message_id': messageId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static WebSocketMessageType _parseMessageType(String typeString) {
    switch (typeString) {
      case 'connection_established':
        return WebSocketMessageType.connectionEstablished;
      case 'heartbeat':
        return WebSocketMessageType.heartbeat;
      case 'heartbeat_ack':
        return WebSocketMessageType.heartbeatAck;
      case 'join_conversation':
        return WebSocketMessageType.joinConversation;
      case 'leave_conversation':
        return WebSocketMessageType.leaveConversation;
      case 'conversation_joined':
        return WebSocketMessageType.conversationJoined;
      case 'new_message':
        return WebSocketMessageType.newMessage;
      case 'message_read':
        return WebSocketMessageType.messageRead;
      case 'message_read_receipt':
        return WebSocketMessageType.messageReadReceipt;
      case 'typing_start':
        return WebSocketMessageType.typingStart;
      case 'typing_stop':
        return WebSocketMessageType.typingStop;
      case 'user_typing':
        return WebSocketMessageType.userTyping;
      case 'online_status':
        return WebSocketMessageType.onlineStatus;
      case 'get_online_status':
        return WebSocketMessageType.getOnlineStatus;
      case 'error':
        return WebSocketMessageType.error;
      default:
        debugPrint('⚠️ [WebSocket] Unknown message type: $typeString');
        return WebSocketMessageType.error;
    }
  }

  static String _messageTypeToString(WebSocketMessageType type) {
    switch (type) {
      case WebSocketMessageType.connectionEstablished:
        return 'connection_established';
      case WebSocketMessageType.heartbeat:
        return 'heartbeat';
      case WebSocketMessageType.heartbeatAck:
        return 'heartbeat_ack';
      case WebSocketMessageType.joinConversation:
        return 'join_conversation';
      case WebSocketMessageType.leaveConversation:
        return 'leave_conversation';
      case WebSocketMessageType.conversationJoined:
        return 'conversation_joined';
      case WebSocketMessageType.newMessage:
        return 'new_message';
      case WebSocketMessageType.messageRead:
        return 'message_read';
      case WebSocketMessageType.messageReadReceipt:
        return 'message_read_receipt';
      case WebSocketMessageType.typingStart:
        return 'typing_start';
      case WebSocketMessageType.typingStop:
        return 'typing_stop';
      case WebSocketMessageType.userTyping:
        return 'user_typing';
      case WebSocketMessageType.onlineStatus:
        return 'online_status';
      case WebSocketMessageType.getOnlineStatus:
        return 'get_online_status';
      case WebSocketMessageType.error:
        return 'error';
    }
  }
}

/// Production-grade WebSocket service with robust connection management
class WebSocketService extends ChangeNotifier {
  // Dynamic WebSocket base URL that matches the ApiClient configuration
  static String get _baseUrl {
    if (kIsWeb) {
      // Web - use localhost with WebSocket protocol
      return 'ws://127.0.0.1:8000/api/v1/chat/ws';
    } else if (Platform.isAndroid) {
      // Android emulator - use 10.0.2.2 with WebSocket protocol
      return 'ws://10.0.2.2:8000/api/v1/chat/ws';
    } else if (Platform.isIOS) {
      // iOS simulator - use localhost with WebSocket protocol
      return 'ws://127.0.0.1:8000/api/v1/chat/ws';
    } else {
      // Default fallback
      return 'ws://127.0.0.1:8000/api/v1/chat/ws';
    }
  }
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const Duration _reconnectBaseDelay = Duration(seconds: 1);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);
  static const int _maxReconnectAttempts = 10;

  WebSocketChannel? _channel;
  StreamSubscription? _messageSubscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  
  WebSocketState _state = WebSocketState.disconnected;
  int _reconnectAttempts = 0;
  String? _lastError;
  String? _userId;
  
  // Message queue for offline messages
  final List<WebSocketMessage> _messageQueue = [];
  
  // Event streams for different message types
  final StreamController<WebSocketMessage> _messageController = 
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<WebSocketMessage> _typingController = 
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<WebSocketMessage> _onlineStatusController = 
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<Map<String, dynamic>> _newMessageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _readReceiptController = 
      StreamController<Map<String, dynamic>>.broadcast();

  // Getters
  WebSocketState get state => _state;
  bool get isConnected => _state == WebSocketState.connected;
  bool get isConnecting => _state == WebSocketState.connecting || _state == WebSocketState.reconnecting;
  String? get lastError => _lastError;
  String? get userId => _userId;

  // Event streams
  Stream<WebSocketMessage> get onMessage => _messageController.stream;
  Stream<WebSocketMessage> get onTyping => _typingController.stream;
  Stream<WebSocketMessage> get onOnlineStatus => _onlineStatusController.stream;
  Stream<Map<String, dynamic>> get onNewMessage => _newMessageController.stream;
  Stream<Map<String, dynamic>> get onReadReceipt => _readReceiptController.stream;

  /// Connect to WebSocket with JWT authentication
  Future<bool> connect() async {
    if (isConnected || isConnecting) {
      debugPrint('🔌 [WebSocket] Already connected or connecting');
      return isConnected;
    }

    try {
      _setState(WebSocketState.connecting);
      _lastError = null;

      // Get auth token
      final accessToken = await SecureStorageService.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('No access token available');
      }

      final wsUrl = '$_baseUrl?token=$accessToken';
      debugPrint('🔌 [WebSocket] Connecting to: ${wsUrl.replaceAll(RegExp(r'token=[^&]+'), 'token=***')}');

      // Create WebSocket connection
      _channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['chat-protocol'],
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Listen to messages
      _messageSubscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnection,
        cancelOnError: false,
      );

      // Wait for connection establishment (with timeout)
      final connectionEstablished = await _waitForConnectionEstablished();
      
      if (connectionEstablished) {
        _setState(WebSocketState.connected);
        _reconnectAttempts = 0;
        _startHeartbeat();
        _flushMessageQueue();
        debugPrint('✅ [WebSocket] Connected successfully');
        return true;
      } else {
        throw Exception('Connection establishment timeout');
      }

    } catch (e) {
      debugPrint('❌ [WebSocket] Connection failed: $e');
      _lastError = e.toString();
      _setState(WebSocketState.error);
      _scheduleReconnect();
      return false;
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    debugPrint('🔌 [WebSocket] Disconnecting...');
    
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    
    try {
      await _channel?.sink.close(WebSocketStatus.goingAway);
    } catch (e) {
      debugPrint('⚠️ [WebSocket] Error during disconnect: $e');
    }
    
    await _messageSubscription?.cancel();
    _channel = null;
    _messageSubscription = null;
    
    _setState(WebSocketState.disconnected);
    debugPrint('✅ [WebSocket] Disconnected');
  }

  /// Send message through WebSocket
  Future<bool> sendMessage(WebSocketMessage message) async {
    if (!isConnected) {
      debugPrint('⚠️ [WebSocket] Not connected, queueing message: ${message.type}');
      _queueMessage(message);
      return false;
    }

    try {
      final jsonString = jsonEncode(message.toJson());
      _channel!.sink.add(jsonString);
      debugPrint('📤 [WebSocket] Sent: ${message.type}');
      return true;
    } catch (e) {
      debugPrint('❌ [WebSocket] Failed to send message: $e');
      _queueMessage(message);
      return false;
    }
  }

  /// Join a conversation for real-time updates
  Future<bool> joinConversation(String conversationId) async {
    final message = WebSocketMessage(
      type: WebSocketMessageType.joinConversation,
      data: {'conversation_id': conversationId},
      conversationId: conversationId,
    );
    return await sendMessage(message);
  }

  /// Leave a conversation
  Future<bool> leaveConversation(String conversationId) async {
    final message = WebSocketMessage(
      type: WebSocketMessageType.leaveConversation,
      data: {'conversation_id': conversationId},
      conversationId: conversationId,
    );
    return await sendMessage(message);
  }

  /// Send typing start indicator
  Future<bool> startTyping(String conversationId) async {
    final message = WebSocketMessage(
      type: WebSocketMessageType.typingStart,
      data: {'conversation_id': conversationId},
      conversationId: conversationId,
    );
    return await sendMessage(message);
  }

  /// Send typing stop indicator
  Future<bool> stopTyping(String conversationId) async {
    final message = WebSocketMessage(
      type: WebSocketMessageType.typingStop,
      data: {'conversation_id': conversationId},
      conversationId: conversationId,
    );
    return await sendMessage(message);
  }

  /// Mark message as read
  Future<bool> markMessageAsRead(String messageId) async {
    final message = WebSocketMessage(
      type: WebSocketMessageType.messageRead,
      data: {'message_id': messageId},
      messageId: messageId,
    );
    return await sendMessage(message);
  }

  /// Get online status for users
  Future<bool> getOnlineStatus(List<String> userIds) async {
    final message = WebSocketMessage(
      type: WebSocketMessageType.getOnlineStatus,
      data: {'user_ids': userIds},
    );
    return await sendMessage(message);
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic rawMessage) {
    try {
      final messageData = jsonDecode(rawMessage as String) as Map<String, dynamic>;
      final message = WebSocketMessage.fromJson(messageData);
      
      debugPrint('📥 [WebSocket] Received: ${message.type}');
      
      // Route message to appropriate stream
      switch (message.type) {
        case WebSocketMessageType.connectionEstablished:
          _userId = messageData['user_id'] as String?;
          debugPrint('🔌 [WebSocket] Connection established for user: $_userId');
          break;
          
        case WebSocketMessageType.heartbeatAck:
          // Heartbeat acknowledged - connection is healthy
          break;
          
        case WebSocketMessageType.newMessage:
          _newMessageController.add(messageData);
          break;
          
        case WebSocketMessageType.userTyping:
          _typingController.add(message);
          break;
          
        case WebSocketMessageType.messageReadReceipt:
          _readReceiptController.add(messageData);
          break;
          
        case WebSocketMessageType.onlineStatus:
          _onlineStatusController.add(message);
          break;
          
        case WebSocketMessageType.error:
          debugPrint('❌ [WebSocket] Server error: ${messageData['message']}');
          _lastError = messageData['message'] as String?;
          break;
          
        default:
          debugPrint('📨 [WebSocket] Unhandled message type: ${message.type}');
      }
      
      // Emit to general message stream
      _messageController.add(message);
      
    } catch (e) {
      debugPrint('❌ [WebSocket] Failed to handle message: $e');
      debugPrint('Raw message: $rawMessage');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    debugPrint('❌ [WebSocket] Connection error: $error');
    _lastError = error.toString();
    _setState(WebSocketState.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _handleDisconnection() {
    debugPrint('🔌 [WebSocket] Connection closed');
    _setState(WebSocketState.disconnected);
    _stopHeartbeat();
    _scheduleReconnect();
  }

  /// Wait for connection establishment message
  Future<bool> _waitForConnectionEstablished() async {
    final completer = Completer<bool>();
    late StreamSubscription subscription;
    
    // Timeout after 10 seconds
    final timeout = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });
    
    subscription = _messageController.stream.listen((message) {
      if (message.type == WebSocketMessageType.connectionEstablished) {
        timeout.cancel();
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }
    });
    
    return await completer.future;
  }

  /// Start heartbeat to keep connection alive
  void _startHeartbeat() {
    _stopHeartbeat();
    
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (isConnected) {
        final heartbeatMessage = WebSocketMessage(
          type: WebSocketMessageType.heartbeat,
          data: {},
        );
        sendMessage(heartbeatMessage);
      }
    });
  }

  /// Stop heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Schedule reconnection with exponential backoff
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('❌ [WebSocket] Max reconnection attempts reached');
      _setState(WebSocketState.error);
      return;
    }

    _reconnectAttempts++;
    
    // Calculate delay with exponential backoff
    final delayMs = (_reconnectBaseDelay.inMilliseconds * 
        (1 << (_reconnectAttempts - 1))).clamp(
        _reconnectBaseDelay.inMilliseconds, 
        _maxReconnectDelay.inMilliseconds
    );
    
    final delay = Duration(milliseconds: delayMs);
    
    debugPrint('🔄 [WebSocket] Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');
    
    _reconnectTimer = Timer(delay, () {
      if (_state != WebSocketState.connected) {
        _setState(WebSocketState.reconnecting);
        connect();
      }
    });
  }

  /// Queue message for later sending
  void _queueMessage(WebSocketMessage message) {
    // Only queue certain types of messages
    if (message.type == WebSocketMessageType.messageRead ||
        message.type == WebSocketMessageType.typingStart ||
        message.type == WebSocketMessageType.typingStop) {
      _messageQueue.add(message);
      
      // Limit queue size
      if (_messageQueue.length > 100) {
        _messageQueue.removeRange(0, _messageQueue.length - 100);
      }
    }
  }

  /// Flush queued messages when connection is restored
  void _flushMessageQueue() {
    if (_messageQueue.isEmpty) return;
    
    debugPrint('📤 [WebSocket] Flushing ${_messageQueue.length} queued messages');
    
    final messages = List<WebSocketMessage>.from(_messageQueue);
    _messageQueue.clear();
    
    for (final message in messages) {
      sendMessage(message);
    }
  }

  /// Update connection state and notify listeners
  void _setState(WebSocketState newState) {
    if (_state != newState) {
      _state = newState;
      debugPrint('🔄 [WebSocket] State changed to: $newState');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('🔌 [WebSocket] Disposing service');
    
    _reconnectTimer?.cancel();
    _stopHeartbeat();
    
    disconnect();
    
    _messageController.close();
    _typingController.close();
    _onlineStatusController.close();
    _newMessageController.close();
    _readReceiptController.close();
    
    super.dispose();
  }
}