import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_conversation.dart';
import '../services/websocket_service.dart';
import '../services/chat_repository.dart';

/// Comprehensive real-time chat provider integrating WebSocket service
/// Handles all real-time chat functionality exactly as specified in the HTML reference
class RealtimeChatProvider extends ChangeNotifier {
  // Dependencies
  final ChatWebSocketService _webSocketService = chatWebSocketService;
  final ChatRepository _chatRepository = chatRepository;

  // State management
  List<Conversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messageCache = {};
  final Map<String, String> _oldestMessageIds = {};
  final Map<String, bool> _hasMoreMessages = {};
  final Map<String, bool> _isLoadingMessages = {};
  final Map<String, Set<String>> _typingUsers = {};
  String? _currentConversationId;
  String? _currentUserId;
  bool _isInitialized = false;
  
  // Stream subscriptions
  StreamSubscription? _chatMessageSubscription;
  StreamSubscription? _typingIndicatorSubscription;
  StreamSubscription? _readReceiptSubscription;
  StreamSubscription? _connectionSubscription;

  // Getters
  List<Conversation> get conversations => List.unmodifiable(_conversations);
  bool get isConnected => _webSocketService.isConnected;
  bool get isConnecting => _webSocketService.isConnecting;
  WebSocketConnectionState get connectionState => _webSocketService.connectionState;
  String? get lastError => _webSocketService.lastError;
  String? get currentUserId => _currentUserId;
  String? get currentConversationId => _currentConversationId;
  bool get isInitialized => _isInitialized;

  /// Get messages for a specific conversation
  List<ChatMessage> getMessages(String conversationId) {
    return _messageCache[conversationId] ?? [];
  }

  /// Check if conversation has more messages to load
  bool hasMoreMessages(String conversationId) {
    return _hasMoreMessages[conversationId] ?? true;
  }

  /// Check if conversation is currently loading messages
  bool isLoadingMessages(String conversationId) {
    return _isLoadingMessages[conversationId] ?? false;
  }

  /// Get typing users for a conversation
  Set<String> getTypingUsers(String conversationId) {
    return _typingUsers[conversationId] ?? {};
  }

  /// Initialize the provider
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    debugPrint('🚀 [RealtimeChatProvider] Initializing...');
    
    // Set up WebSocket listeners
    _setupWebSocketListeners();
    
    // Connect WebSocket
    await _webSocketService.connect();
    
    // Load initial conversations
    await loadConversations();
    
    _isInitialized = true;
    notifyListeners();
    
    debugPrint('✅ [RealtimeChatProvider] Initialized successfully');
  }

  /// Load conversations from API
  Future<void> loadConversations() async {
    debugPrint('📥 [RealtimeChatProvider] Loading conversations...');
    
    final result = await _chatRepository.getConversations(limit: 50);
    
    result.when(
      success: (conversations) {
        _conversations = conversations;
        // Sort by last_message_at DESC (most recent first) - exactly like HTML reference
        _conversations.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
        
        debugPrint('✅ [RealtimeChatProvider] Loaded ${_conversations.length} conversations');
        notifyListeners();
      },
      failure: (error) {
        debugPrint('❌ [RealtimeChatProvider] Failed to load conversations: ${error.message}');
      },
    );
  }

  /// Select and join a conversation
  Future<void> selectConversation(String conversationId) async {
    if (_currentConversationId == conversationId) return;
    
    debugPrint('🚪 [RealtimeChatProvider] Selecting conversation: $conversationId');
    
    _currentConversationId = conversationId;
    notifyListeners();
    
    // Join conversation via WebSocket for real-time updates
    await _webSocketService.joinConversation(conversationId);
    
    // Load messages for this conversation
    await loadMessages(conversationId, isInitialLoad: true);
  }

  /// Load messages for a conversation with proper pagination
  Future<void> loadMessages(String conversationId, {bool isInitialLoad = false, bool loadMore = false}) async {
    if (_isLoadingMessages[conversationId] == true) return;
    
    _isLoadingMessages[conversationId] = true;
    notifyListeners();
    
    if (isInitialLoad) {
      _messageCache[conversationId] = [];
      _oldestMessageIds[conversationId] = '';
      _hasMoreMessages[conversationId] = true;
    }
    
    final String? beforeMessageId = loadMore ? _oldestMessageIds[conversationId] : null;
    
    debugPrint('📥 [RealtimeChatProvider] Loading messages for $conversationId, loadMore: $loadMore, beforeMessageId: $beforeMessageId');
    
    final result = await _chatRepository.getMessages(
      conversationId: conversationId,
      limit: 100, // Match HTML reference
      beforeMessageId: beforeMessageId,
    );
    
    result.when(
      success: (newMessages) {
        _hasMoreMessages[conversationId] = newMessages.length == 100;
        
        if (newMessages.isNotEmpty) {
          // Update oldest message ID for pagination
          _oldestMessageIds[conversationId] = newMessages.first.id; // First because they're already reversed
          
          final existingMessages = _messageCache[conversationId] ?? [];
          
          if (loadMore) {
            // Prepend older messages to the beginning (for load more)
            _messageCache[conversationId] = [...newMessages, ...existingMessages];
          } else {
            // Replace messages for initial load
            _messageCache[conversationId] = newMessages;
          }
          
          debugPrint('✅ [RealtimeChatProvider] Loaded ${newMessages.length} messages for $conversationId (total: ${_messageCache[conversationId]!.length})');
        }
        
        _isLoadingMessages[conversationId] = false;
        notifyListeners();
      },
      failure: (error) {
        debugPrint('❌ [RealtimeChatProvider] Failed to load messages: ${error.message}');
        _isLoadingMessages[conversationId] = false;
        notifyListeners();
      },
    );
  }

  /// Send a message
  Future<void> sendMessage(String conversationId, String content) async {
    if (content.trim().isEmpty) return;
    
    debugPrint('📤 [RealtimeChatProvider] Sending message to $conversationId: ${content.substring(0, 30)}...');
    
    final result = await _chatRepository.sendMessage(
      conversationId: conversationId,
      content: content.trim(),
      messageType: 'text',
    );
    
    result.when(
      success: (message) {
        // Add message to cache immediately (optimistic update)
        final messages = _messageCache[conversationId] ?? [];
        _messageCache[conversationId] = [...messages, message];
        
        // Update conversation order (move to top)
        _moveConversationToTop(conversationId, message);
        
        debugPrint('✅ [RealtimeChatProvider] Message sent successfully');
        notifyListeners();
      },
      failure: (error) {
        debugPrint('❌ [RealtimeChatProvider] Failed to send message: ${error.message}');
      },
    );
  }

  /// Start typing indicator
  Future<void> startTyping(String conversationId) async {
    await _webSocketService.startTyping(conversationId);
  }

  /// Stop typing indicator
  Future<void> stopTyping(String conversationId) async {
    await _webSocketService.stopTyping(conversationId);
  }

  /// Setup WebSocket listeners for real-time updates
  void _setupWebSocketListeners() {
    debugPrint('🎧 [RealtimeChatProvider] Setting up WebSocket listeners...');
    
    // Listen for new chat messages
    _chatMessageSubscription = _webSocketService.onChatMessage.listen(_handleChatMessage);
    
    // Listen for typing indicators
    _typingIndicatorSubscription = _webSocketService.onTypingIndicator.listen(_handleTypingIndicator);
    
    // Listen for read receipts
    _readReceiptSubscription = _webSocketService.onReadReceipt.listen(_handleReadReceipt);
    
    // Listen for connection changes
    _connectionSubscription = _webSocketService.onConnection.listen(_handleConnectionChange);
  }

  /// Handle incoming chat message from WebSocket
  void _handleChatMessage(Map<String, dynamic> data) {
    try {
      debugPrint('💬 [RealtimeChatProvider] Processing chat_message event');
      
      final messageData = data['message_data'] as Map<String, dynamic>?;
      if (messageData == null) {
        debugPrint('⚠️ [RealtimeChatProvider] No message_data in chat_message event');
        return;
      }
      
      if (messageData['type'] == 'new_message') {
        final messageJson = messageData['message'] as Map<String, dynamic>?;
        final conversationId = data['conversation_id'] as String?;
        
        if (messageJson != null && conversationId != null) {
          // Ensure conversation_id is set in message
          messageJson['conversation_id'] = conversationId;
          
          final message = ChatMessage.fromApiMessage(messageJson, _currentUserId ?? '');
          
          // Add message to cache if it's for an active conversation
          if (_messageCache.containsKey(conversationId)) {
            final messages = _messageCache[conversationId] ?? [];
            _messageCache[conversationId] = [...messages, message];
          }
          
          // ALWAYS reorder conversations - this is key for real-time updates for ALL participants
          _moveConversationToTop(conversationId, message);
          
          debugPrint('✅ [RealtimeChatProvider] New message processed: ${message.content.substring(0, 30)}...');
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('❌ [RealtimeChatProvider] Error processing chat message: $e');
    }
  }

  /// Handle typing indicator from WebSocket
  void _handleTypingIndicator(Map<String, dynamic> data) {
    try {
      final conversationId = data['conversation_id'] as String?;
      final userId = data['user_id'] as String?;
      final isTyping = data['is_typing'] as bool? ?? false;
      
      if (conversationId != null && userId != null && userId != _currentUserId) {
        final typingUsers = _typingUsers[conversationId] ?? <String>{};
        
        if (isTyping) {
          typingUsers.add(userId);
        } else {
          typingUsers.remove(userId);
        }
        
        _typingUsers[conversationId] = typingUsers;
        
        debugPrint('⌨️ [RealtimeChatProvider] Typing indicator: $userId ${isTyping ? 'started' : 'stopped'} typing in $conversationId');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ [RealtimeChatProvider] Error processing typing indicator: $e');
    }
  }

  /// Handle read receipt from WebSocket
  void _handleReadReceipt(Map<String, dynamic> data) {
    try {
      final messageId = data['message_id'] as String?;
      final readerUserId = data['reader_user_id'] as String?;
      
      if (messageId != null && readerUserId != null) {
        // Update message read status in cache
        for (final messages in _messageCache.values) {
          final messageIndex = messages.indexWhere((m) => m.id == messageId);
          if (messageIndex != -1) {
            final message = messages[messageIndex];
            if (!message.readBy.contains(readerUserId)) {
              final updatedReadBy = [...message.readBy, readerUserId];
              messages[messageIndex] = message.copyWith(readBy: updatedReadBy);
              
              debugPrint('✓ [RealtimeChatProvider] Message $messageId marked as read by $readerUserId');
              notifyListeners();
              break;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [RealtimeChatProvider] Error processing read receipt: $e');
    }
  }

  /// Handle connection status changes
  void _handleConnectionChange(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    if (type == 'connection_established') {
      _currentUserId = data['user_id'] as String?;
      debugPrint('🔌 [RealtimeChatProvider] Connection established for user: $_currentUserId');
      notifyListeners();
    }
  }

  /// Move conversation to top of list (for real-time reordering)
  void _moveConversationToTop(String conversationId, ChatMessage lastMessage) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    
    if (index > 0) {
      // Move conversation to top
      final conversation = _conversations.removeAt(index);
      final updatedConversation = conversation.copyWith(
        lastMessage: lastMessage,
        lastMessageAt: lastMessage.createdAt,
      );
      _conversations.insert(0, updatedConversation);
      
      debugPrint('📊 [RealtimeChatProvider] Moved conversation $conversationId to top');
    } else if (index == 0) {
      // Already at top, just update last message
      final conversation = _conversations[0];
      _conversations[0] = conversation.copyWith(
        lastMessage: lastMessage,
        lastMessageAt: lastMessage.createdAt,
      );
      
      debugPrint('📊 [RealtimeChatProvider] Updated conversation $conversationId at top');
    } else {
      // Conversation not in list, reload conversations
      debugPrint('📊 [RealtimeChatProvider] Conversation $conversationId not found, reloading...');
      loadConversations();
      return;
    }
  }

  /// Disconnect and cleanup
  Future<void> disconnect() async {
    debugPrint('🔌 [RealtimeChatProvider] Disconnecting...');
    
    await _webSocketService.disconnect();
    _cleanup();
    
    debugPrint('✅ [RealtimeChatProvider] Disconnected');
  }

  /// Cleanup resources
  void _cleanup() {
    _chatMessageSubscription?.cancel();
    _typingIndicatorSubscription?.cancel();
    _readReceiptSubscription?.cancel();
    _connectionSubscription?.cancel();
    
    _conversations.clear();
    _messageCache.clear();
    _oldestMessageIds.clear();
    _hasMoreMessages.clear();
    _isLoadingMessages.clear();
    _typingUsers.clear();
    
    _currentConversationId = null;
    _currentUserId = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    debugPrint('🔌 [RealtimeChatProvider] Disposing...');
    _cleanup();
    super.dispose();
  }
}

/// Singleton instance
final realtimeChatProvider = RealtimeChatProvider();