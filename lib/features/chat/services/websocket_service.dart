import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../../../core/storage/secure_storage_service.dart';

/// WebSocket connection states
enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// WebSocket event types from API documentation
enum WebSocketEventType {
  // Connection events
  connectionEstablished,
  heartbeat,
  heartbeatAck,
  
  // Conversation events
  joinConversation,
  conversationJoined,
  
  // Message events
  chatMessage,
  messageReadReceipt,
  messageDeliveryStatusUpdate,
  messageOverallStatusUpdate,
  userDeliveryConfirmation,
  userStatus,
  
  // Typing events
  typingIndicator,
  typingIndicatorSent, // Added missing event type
  typingStart,
  typingStop,
  
  // Error events
  error,
}

/// WebSocket message wrapper for API communication
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final String? conversationId;
  final String? messageId;
  final String? userId;
  final String? username;
  final DateTime timestamp;

  WebSocketMessage({
    required this.type,
    required this.data,
    this.conversationId,
    this.messageId,
    this.userId,
    this.username,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create message for outgoing events
  factory WebSocketMessage.outgoing(
    WebSocketEventType eventType,
    Map<String, dynamic> data,
  ) {
    return WebSocketMessage(
      type: _eventTypeToString(eventType),
      data: data,
    );
  }

  /// Create from incoming JSON
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    debugPrint('🔍 [WebSocketMessage] Parsing message with keys: ${json.keys.toList()}');
    
    // Extract conversation_id from multiple possible locations
    String? conversationId = json['conversation_id'] as String?;
    
    // If not found at top level, check in message_data
    if (conversationId == null && json.containsKey('message_data')) {
      final messageData = json['message_data'] as Map<String, dynamic>?;
      if (messageData != null) {
        conversationId = messageData['conversation_id'] as String?;
        
        // If not in message_data root, check in message object
        if (conversationId == null && messageData.containsKey('message')) {
          final messageObj = messageData['message'] as Map<String, dynamic>?;
          if (messageObj != null) {
            conversationId = messageObj['conversation_id'] as String?;
          }
        }
      }
    }
    
    debugPrint('🔍 [WebSocketMessage] Final extracted conversation_id: $conversationId');
    debugPrint('🔍 [WebSocketMessage] Conversation_id type: ${conversationId.runtimeType}');
    
    return WebSocketMessage(
      type: json['type'] as String,
      data: json.containsKey('data') 
          ? json['data'] as Map<String, dynamic>
          : json,
      conversationId: conversationId,
      messageId: json['message_id'] as String?,
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to JSON for sending
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }

  /// Get event type enum from string
  WebSocketEventType get eventType => _stringToEventType(type);

  static String _eventTypeToString(WebSocketEventType type) {
    switch (type) {
      case WebSocketEventType.connectionEstablished:
        return 'connection_established';
      case WebSocketEventType.heartbeat:
        return 'heartbeat';
      case WebSocketEventType.heartbeatAck:
        return 'heartbeat_ack';
      case WebSocketEventType.joinConversation:
        return 'join_conversation';
      case WebSocketEventType.conversationJoined:
        return 'conversation_joined';
      case WebSocketEventType.chatMessage:
        return 'chat_message';
      case WebSocketEventType.messageReadReceipt:
        return 'message_read_receipt';
      case WebSocketEventType.messageDeliveryStatusUpdate:
        return 'message_delivery_status_update';
      case WebSocketEventType.messageOverallStatusUpdate:
        return 'message_overall_status_update';
      case WebSocketEventType.userDeliveryConfirmation:
        return 'user_delivery_confirmation';
      case WebSocketEventType.userStatus:
        return 'user_status';
      case WebSocketEventType.typingIndicator:
        return 'typing_indicator';
      case WebSocketEventType.typingIndicatorSent:
        return 'typing_indicator_sent';
      case WebSocketEventType.typingStart:
        return 'typing_start';
      case WebSocketEventType.typingStop:
        return 'typing_stop';
      case WebSocketEventType.error:
        return 'error';
    }
  }

  static WebSocketEventType _stringToEventType(String type) {
    switch (type) {
      case 'connection_established':
        return WebSocketEventType.connectionEstablished;
      case 'heartbeat':
        return WebSocketEventType.heartbeat;
      case 'heartbeat_ack':
        return WebSocketEventType.heartbeatAck;
      case 'join_conversation':
        return WebSocketEventType.joinConversation;
      case 'conversation_joined':
        return WebSocketEventType.conversationJoined;
      case 'chat_message':
        return WebSocketEventType.chatMessage;
      case 'message_read_receipt':
        return WebSocketEventType.messageReadReceipt;
      case 'message_delivery_status_update':
        return WebSocketEventType.messageDeliveryStatusUpdate;
      case 'message_overall_status_update':
        return WebSocketEventType.messageOverallStatusUpdate;
      case 'user_delivery_confirmation':
        return WebSocketEventType.userDeliveryConfirmation;
      case 'user_status':
        return WebSocketEventType.userStatus;
      case 'typing_indicator':
        return WebSocketEventType.typingIndicator;
      case 'typing_indicator_sent':
        return WebSocketEventType.typingIndicatorSent;
      case 'typing_start':
        return WebSocketEventType.typingStart;
      case 'typing_stop':
        return WebSocketEventType.typingStop;
      case 'error':
        return WebSocketEventType.error;
      default:
        debugPrint('⚠️ [WebSocket] =============== UNKNOWN MESSAGE TYPE ===============');
        debugPrint('⚠️ [WebSocket] Unknown event type: "$type"');
        debugPrint('⚠️ [WebSocket] Please add support for this message type!');
        debugPrint('⚠️ [WebSocket] =================================================');
        return WebSocketEventType.error;
    }
  }
}

/// Comprehensive WebSocket service matching API documentation
class ChatWebSocketService extends ChangeNotifier {
  // Environment configuration
  static const bool _useProduction = true; // Change to false for development
  
  // Connection configuration
  static String get _baseUrl {
    if (_useProduction) {
      // Production WebSocket URL (use wss for HTTPS)
      return 'wss://future.bytefuse.in/api/v1/chat/ws';
    }
    
    // Development URLs based on platform
    if (kIsWeb) {
      return 'ws://127.0.0.1:8000/api/v1/chat/ws';
    } else if (Platform.isAndroid) {
      return 'ws://10.0.2.2:8000/api/v1/chat/ws';
    } else if (Platform.isIOS) {
      return 'ws://127.0.0.1:8000/api/v1/chat/ws';
    } else {
      return 'ws://127.0.0.1:8000/api/v1/chat/ws';
    }
  }

  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const Duration _connectionTimeout = Duration(seconds: 10);
  static const Duration _reconnectBaseDelay = Duration(seconds: 1);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);
  static const int _maxReconnectAttempts = 10;

  // Connection state
  WebSocketChannel? _channel;
  StreamSubscription? _messageSubscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  Timer? _connectionTimeoutTimer;

  WebSocketConnectionState _state = WebSocketConnectionState.disconnected;
  int _reconnectAttempts = 0;
  String? _lastError;
  String? _userId;
  String? _accessToken;

  // Message queue for offline messages
  final List<WebSocketMessage> _messageQueue = [];

  // Event streams for different message types
  final StreamController<Map<String, dynamic>> _chatMessageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _typingIndicatorController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _readReceiptController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _connectionController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<WebSocketMessage> _messageController = 
      StreamController<WebSocketMessage>.broadcast();

  // Getters
  WebSocketConnectionState get connectionState => _state;
  bool get isConnected => _state == WebSocketConnectionState.connected;
  bool get isConnecting => _state == WebSocketConnectionState.connecting || 
                          _state == WebSocketConnectionState.reconnecting;
  String? get lastError => _lastError;
  String? get userId => _userId;

  // Event streams
  Stream<Map<String, dynamic>> get onChatMessage => _chatMessageController.stream;
  Stream<Map<String, dynamic>> get onTypingIndicator => _typingIndicatorController.stream;
  Stream<Map<String, dynamic>> get onReadReceipt => _readReceiptController.stream;
  Stream<Map<String, dynamic>> get onConnection => _connectionController.stream;
  Stream<WebSocketMessage> get onMessage => _messageController.stream;

  /// Connect to WebSocket with JWT authentication
  Future<bool> connect() async {
    if (isConnected || isConnecting) {
      debugPrint('🔌 [WebSocket] Already connected or connecting');
      return isConnected;
    }

    try {
      _setState(WebSocketConnectionState.connecting);
      _lastError = null;

      // Get auth token
      _accessToken = await SecureStorageService.getAccessToken();
      debugPrint('🔑 [WebSocket] Access token exists: ${_accessToken != null}');
      debugPrint('🔑 [WebSocket] Token length: ${_accessToken?.length ?? 0}');
      
      if (_accessToken == null || _accessToken!.isEmpty) {
        debugPrint('❌ [WebSocket] No access token available');
        throw Exception('No access token available');
      }

      final wsUrl = '$_baseUrl?token=$_accessToken';
      debugPrint('🔌 [WebSocket] =============== CONNECTION ATTEMPT ===============');
      debugPrint('🔌 [WebSocket] Base URL: $_baseUrl');
      debugPrint('🔌 [WebSocket] Token exists: ${_accessToken!.isNotEmpty}');
      debugPrint('🔌 [WebSocket] Token length: ${_accessToken!.length}');
      debugPrint('🔌 [WebSocket] Full URL: ${wsUrl.replaceAll(RegExp(r'token=[^&]+'), 'token=***')}');
      debugPrint('🔌 [WebSocket] Authentication header will be: Bearer ***');
      debugPrint('🔌 [WebSocket] ===============================================');

      // Create WebSocket connection
      try {
        _channel = IOWebSocketChannel.connect(
          Uri.parse(wsUrl),
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        );
        debugPrint('✅ [WebSocket] Channel created successfully');
      } catch (e) {
        debugPrint('❌ [WebSocket] Failed to create WebSocket channel: $e');
        throw Exception('WebSocket channel creation failed: $e');
      }

      // Set connection timeout
      _connectionTimeoutTimer = Timer(_connectionTimeout, () {
        if (_state == WebSocketConnectionState.connecting) {
          debugPrint('❌ [WebSocket] Connection timeout');
          _handleError(Exception('Connection timeout'));
        }
      });

      // Listen to messages
      debugPrint('🔌 [WebSocket] Setting up message listeners...');
      _messageSubscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnection,
        cancelOnError: false,
      );
      debugPrint('✅ [WebSocket] Message listeners configured');

      // Wait for connection establishment
      final connectionEstablished = await _waitForConnectionEstablished();
      
      if (connectionEstablished) {
        _connectionTimeoutTimer?.cancel();
        _setState(WebSocketConnectionState.connected);
        _reconnectAttempts = 0;
        _startHeartbeat();
        _flushMessageQueue();
        debugPrint('✅ [WebSocket] Connected successfully');
        return true;
      } else {
        throw Exception('Connection establishment failed');
      }

    } catch (e) {
      debugPrint('❌ [WebSocket] Connection failed: $e');
      _lastError = e.toString();
      _setState(WebSocketConnectionState.error);
      _scheduleReconnect();
      return false;
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    debugPrint('🔌 [WebSocket] Disconnecting...');
    
    _connectionTimeoutTimer?.cancel();
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
    
    _setState(WebSocketConnectionState.disconnected);
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
    debugPrint('🚪 [WebSocket] Attempting to join conversation: $conversationId');
    debugPrint('🚪 [WebSocket] Connection state: $_state');
    debugPrint('🚪 [WebSocket] Is connected: $isConnected');
    
    if (!isConnected) {
      debugPrint('❌ [WebSocket] Cannot join conversation - not connected');
      return false;
    }
    
    final message = WebSocketMessage.outgoing(
      WebSocketEventType.joinConversation,
      {'conversation_id': conversationId},
    );
    
    debugPrint('🚪 [WebSocket] Sending join conversation message: ${jsonEncode(message.toJson())}');
    final result = await sendMessage(message);
    debugPrint('🚪 [WebSocket] Join conversation result: $result');
    
    return result;
  }

  /// Send typing start indicator
  Future<bool> startTyping(String conversationId) async {
    final message = WebSocketMessage.outgoing(
      WebSocketEventType.typingStart,
      {'conversation_id': conversationId},
    );
    return await sendMessage(message);
  }

  /// Send typing stop indicator
  Future<bool> stopTyping(String conversationId) async {
    final message = WebSocketMessage.outgoing(
      WebSocketEventType.typingStop,
      {'conversation_id': conversationId},
    );
    return await sendMessage(message);
  }

  /// Send heartbeat to keep connection alive
  Future<bool> sendHeartbeat() async {
    final message = WebSocketMessage.outgoing(
      WebSocketEventType.heartbeat,
      {},
    );
    return await sendMessage(message);
  }

  /// Send read receipt for a message
  Future<bool> sendReadReceipt(String messageId, String conversationId) async {
    final message = WebSocketMessage.outgoing(
      WebSocketEventType.messageReadReceipt,
      {
        'message_id': messageId,
        'conversation_id': conversationId,
      },
    );
    return await sendMessage(message);
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic rawMessage) {
    try {
      debugPrint('📥 [WebSocket] =============== MESSAGE RECEIVED ===============');
      debugPrint('📥 [WebSocket] RAW MESSAGE: $rawMessage');
      
      final messageData = jsonDecode(rawMessage as String) as Map<String, dynamic>;
      final message = WebSocketMessage.fromJson(messageData);
      
      debugPrint('📥 [WebSocket] MESSAGE TYPE: ${message.type}');
      debugPrint('📥 [WebSocket] MESSAGE KEYS: ${messageData.keys.toList()}');
      debugPrint('📥 [WebSocket] EVENT TYPE ENUM: ${message.eventType}');
      debugPrint('📥 [WebSocket] FULL MESSAGE DATA: ${jsonEncode(messageData)}');
      debugPrint('📥 [WebSocket] ===============================================');
      
      // Route message to appropriate stream
      switch (message.eventType) {
        case WebSocketEventType.connectionEstablished:
          _userId = messageData['user_id'] as String?;
          debugPrint('🔌 [WebSocket] CONNECTION ESTABLISHED:');
          debugPrint('🔌 [WebSocket] - User ID: $_userId');
          debugPrint('🔌 [WebSocket] - Full data: ${jsonEncode(messageData)}');
          _connectionController.add(messageData);
          debugPrint('🔌 [WebSocket] Connection event added to stream');
          break;
          
        case WebSocketEventType.heartbeatAck:
          debugPrint('💓 [WebSocket] Heartbeat acknowledged - connection healthy');
          break;
          
        case WebSocketEventType.chatMessage:
          debugPrint('🎉 [WebSocket] *** CHAT MESSAGE EVENT RECEIVED ***');
          
          // Use the properly extracted conversation_id from the message object
          final conversationId = message.conversationId;
          debugPrint('💬 [WebSocket] - Conversation ID (from message): $conversationId');
          debugPrint('💬 [WebSocket] - Message data keys: ${messageData.keys.toList()}');
          debugPrint('💬 [WebSocket] - Full message data: ${jsonEncode(messageData)}');
          
          if (conversationId != null) {
            _chatMessageController.add(messageData);
            debugPrint('💬 [WebSocket] Chat message added to stream for conversation: $conversationId');
          } else {
            debugPrint('❌ [WebSocket] Cannot process chat message - conversation_id is null');
            debugPrint('❌ [WebSocket] Raw message structure: ${jsonEncode(messageData)}');
          }
          break;
          
        case WebSocketEventType.typingIndicator:
          _typingIndicatorController.add(messageData);
          debugPrint('⌨️ [WebSocket] Typing indicator: ${message.username} in ${message.conversationId}');
          break;
          
        case WebSocketEventType.typingIndicatorSent:
          debugPrint('✅ [WebSocket] Typing indicator sent successfully');
          // This is just an acknowledgment - no UI update needed
          break;
          
        case WebSocketEventType.messageReadReceipt:
          _readReceiptController.add(messageData);
          debugPrint('✓ [WebSocket] Read receipt for message: ${message.messageId}');
          break;
          
        case WebSocketEventType.messageDeliveryStatusUpdate:
          _chatMessageController.add(messageData);
          debugPrint('📬 [WebSocket] Delivery status update for message: ${message.messageId}');
          break;
          
        case WebSocketEventType.messageOverallStatusUpdate:
          _chatMessageController.add(messageData);
          debugPrint('🎯 [WebSocket] Overall status update for message: ${message.messageId}');
          break;
          
        case WebSocketEventType.userDeliveryConfirmation:
          _chatMessageController.add(messageData);
          debugPrint('✅ [WebSocket] User delivery confirmation from: ${message.userId}');
          break;
          
        case WebSocketEventType.userStatus:
          debugPrint('👤 [WebSocket] User status update: ${message.userId} is ${messageData['status']}');
          // Could be used for online/offline status in the UI
          break;
          
        case WebSocketEventType.conversationJoined:
          debugPrint('🎉 [WebSocket] *** CONVERSATION JOINED SUCCESSFULLY ***');
          debugPrint('🚪 [WebSocket] - Conversation ID: ${message.conversationId}');
          debugPrint('🚪 [WebSocket] - Full data: ${jsonEncode(messageData)}');
          debugPrint('🚪 [WebSocket] - Now listening for messages in this conversation');
          break;
          
        case WebSocketEventType.error:
          debugPrint('❌ [WebSocket] Server error: ${messageData['message']}');
          _lastError = messageData['message'] as String?;
          break;
          
        default:
          debugPrint('📨 [WebSocket] =============== UNHANDLED MESSAGE ===============');
          debugPrint('📨 [WebSocket] Unhandled message type: ${message.type}');
          debugPrint('📨 [WebSocket] Event type enum: ${message.eventType}');
          debugPrint('📨 [WebSocket] Message data: ${jsonEncode(messageData)}');
          debugPrint('📨 [WebSocket] This message will be ignored!');
          debugPrint('📨 [WebSocket] =============================================');
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
    _setState(WebSocketConnectionState.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _handleDisconnection() {
    debugPrint('🔌 [WebSocket] Connection closed');
    _setState(WebSocketConnectionState.disconnected);
    _stopHeartbeat();
    _scheduleReconnect();
  }

  /// Wait for connection establishment message
  Future<bool> _waitForConnectionEstablished() async {
    final completer = Completer<bool>();
    late StreamSubscription subscription;
    
    // Timeout after connection timeout duration
    final timeout = Timer(_connectionTimeout, () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });
    
    subscription = _connectionController.stream.listen((data) {
      if (data['type'] == 'connection_established') {
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
        sendHeartbeat();
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
      _setState(WebSocketConnectionState.error);
      return;
    }

    _reconnectAttempts++;
    
    // Calculate delay with exponential backoff
    final delayMs = (_reconnectBaseDelay.inMilliseconds * 
        pow(2, _reconnectAttempts - 1)).clamp(
        _reconnectBaseDelay.inMilliseconds, 
        _maxReconnectDelay.inMilliseconds
    );
    
    final delay = Duration(milliseconds: delayMs.toInt());
    
    debugPrint('🔄 [WebSocket] Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');
    
    _reconnectTimer = Timer(delay, () {
      if (_state != WebSocketConnectionState.connected) {
        _setState(WebSocketConnectionState.reconnecting);
        connect();
      }
    });
  }

  /// Queue message for later sending
  void _queueMessage(WebSocketMessage message) {
    // Only queue certain types of messages
    if (message.eventType == WebSocketEventType.typingStart ||
        message.eventType == WebSocketEventType.typingStop ||
        message.eventType == WebSocketEventType.joinConversation) {
      _messageQueue.add(message);
      
      // Limit queue size
      if (_messageQueue.length > 50) {
        _messageQueue.removeRange(0, _messageQueue.length - 50);
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
  void _setState(WebSocketConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      debugPrint('🔄 [WebSocket] State changed to: $newState');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('🔌 [WebSocket] Disposing service');
    
    _connectionTimeoutTimer?.cancel();
    _reconnectTimer?.cancel();
    _stopHeartbeat();
    
    disconnect();
    
    _chatMessageController.close();
    _typingIndicatorController.close();
    _readReceiptController.close();
    _connectionController.close();
    _messageController.close();
    
    super.dispose();
  }
}

/// Singleton instance
final chatWebSocketService = ChatWebSocketService();