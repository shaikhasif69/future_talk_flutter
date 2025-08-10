import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_conversation.dart';
import '../services/websocket_service.dart';
import '../services/chat_repository.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../auth/services/auth_service.dart';

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
    
    // Get current user ID from secure storage immediately with retry
    try {
      _currentUserId = await _chatRepository.getCurrentUserId();
      debugPrint('🔑 [RealtimeChatProvider] Current user ID from repository: $_currentUserId');
      
      // If still null or empty, try alternative method
      if (_currentUserId == null || _currentUserId!.isEmpty || _currentUserId == 'unknown-user') {
        debugPrint('⚠️ [RealtimeChatProvider] User ID is null/empty, trying SecureStorageService directly...');
        _currentUserId = await SecureStorageService.getUserId();
        debugPrint('🔑 [RealtimeChatProvider] Direct storage user ID: $_currentUserId');
        
        // If still null or empty, check for any stored data
        if (_currentUserId == null || _currentUserId!.isEmpty) {
          debugPrint('❌ [RealtimeChatProvider] CRITICAL: Cannot get user ID from storage');
          
          // Try to get user ID from API as last resort
          try {
            final accessToken = await SecureStorageService.getAccessToken();
            debugPrint('🔑 [RealtimeChatProvider] Access token exists: ${accessToken != null}');
            
            if (accessToken != null) {
              debugPrint('🔄 [RealtimeChatProvider] Token exists but no user ID - fetching from API...');
              
              // Import auth service if not already imported
              try {
                // Call the API to get current user
                final authService = AuthService();
                final userResult = await authService.getCurrentUser();
                
                userResult.when(
                  success: (user) async {
                    _currentUserId = user.id;
                    await SecureStorageService.saveUserId(user.id);
                    debugPrint('✅ [RealtimeChatProvider] Retrieved user ID from API: $_currentUserId');
                  },
                  failure: (error) {
                    debugPrint('❌ [RealtimeChatProvider] Failed to get user from API: ${error.message}');
                    _currentUserId = null;
                  },
                );
              } catch (apiError) {
                debugPrint('❌ [RealtimeChatProvider] API call error: $apiError');
                _currentUserId = null;
              }
            } else {
              debugPrint('❌ [RealtimeChatProvider] No access token available');
              _currentUserId = null;
            }
          } catch (e) {
            debugPrint('❌ [RealtimeChatProvider] Error in user ID recovery: $e');
            _currentUserId = null;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [RealtimeChatProvider] Error getting user ID: $e');
      _currentUserId = null;
    }
    
    debugPrint('✅ [RealtimeChatProvider] Final user ID: $_currentUserId');
    
    // Set up WebSocket listeners
    _setupWebSocketListeners();
    
    // Connect WebSocket
    await _webSocketService.connect();
    
    // Load initial conversations
    await loadConversations();
    
    _isInitialized = true;
    notifyListeners();
    
    debugPrint('✅ [RealtimeChatProvider] Initialized successfully with user ID: $_currentUserId');
  }

  /// Load conversations from API
  Future<void> loadConversations() async {
    debugPrint('📥 [RealtimeChatProvider] Loading conversations...');
    debugPrint('📥 [RealtimeChatProvider] Current user ID: $_currentUserId');
    
    final result = await _chatRepository.getConversations(limit: 50);
    
    result.when(
      success: (conversations) {
        debugPrint('📥 [RealtimeChatProvider] API returned ${conversations.length} conversations');
        
        _conversations = conversations;
        // Sort by last_message_at DESC (most recent first) - exactly like HTML reference
        _conversations.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
        
        debugPrint('✅ [RealtimeChatProvider] Conversations loaded and sorted:');
        for (int i = 0; i < _conversations.length; i++) {
          final conv = _conversations[i];
          final lastMsg = conv.lastMessage?.content ?? 'No message';
          debugPrint('✅ [RealtimeChatProvider] [$i] ${conv.displayName}: ${lastMsg.substring(0, lastMsg.length > 30 ? 30 : lastMsg.length)}...');
          debugPrint('✅ [RealtimeChatProvider]     - Participants: ${conv.participants.map((p) => p.username).join(', ')}');
          debugPrint('✅ [RealtimeChatProvider]     - Last message time: ${conv.lastMessage?.createdAt}');
        }
        
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
          
          // Debug: Show alignment for loaded messages
          for (int i = 0; i < newMessages.length; i++) {
            final msg = newMessages[i];
            debugPrint('📥 [RealtimeChatProvider] Loaded message $i: "${msg.content.substring(0, msg.content.length > 20 ? 20 : msg.content.length)}..." - isFromMe: ${msg.isFromMe} - senderId: ${msg.senderId} - currentUserId: $_currentUserId');
          }
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
    
    print('📤 SENDING: "$content" to conversation $conversationId');
    
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
        
        print('✅ SENT: "${message.content}" (ID: ${message.id})');
        notifyListeners();
      },
      failure: (error) {
        print('❌ SEND FAILED: ${error.message}');
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
      // WebSocket message received
      
      // Extract message_data first 
      final messageData = data['message_data'] as Map<String, dynamic>?;
      
      // Extract conversation ID from multiple possible locations
      String? conversationId = data['conversation_id'] as String?;
      
      // If not found at top level, check in message_data
      if (conversationId == null && messageData != null) {
        conversationId = messageData['conversation_id'] as String?;
        
        // If not in message_data root, check in message object
        if (conversationId == null && messageData.containsKey('message')) {
          final messageObj = messageData['message'] as Map<String, dynamic>?;
          if (messageObj != null) {
            conversationId = messageObj['conversation_id'] as String?;
          }
        }
      }
      
      if (conversationId == null) {
        print('❌ ERROR: No conversation_id in WebSocket message');
        return;
      }
      
      if (messageData == null) {
        return;
      }
      
      final eventType = messageData['type'] as String?;
      
      if (eventType == 'new_message') {
        // Extract message according to documentation structure
        final messageJson = messageData['message'] as Map<String, dynamic>?;
        final senderInfo = messageData['sender_info'] as Map<String, dynamic>?;
        
        if (messageJson == null) {
          return;
        }
        
        // Ensure conversation_id is set in message
        messageJson['conversation_id'] = conversationId;
        
        // Add sender info if available
        if (senderInfo != null) {
          messageJson['sender_username'] = senderInfo['username'] ?? messageJson['sender_username'];
          messageJson['sender_display_name'] = senderInfo['display_name'];
        }
        
        final message = ChatMessage.fromWebSocketMessage(data, _currentUserId ?? '');
        
        // Add message to cache for ANY conversation (active or not)
        if (_messageCache.containsKey(conversationId)) {
          final messages = _messageCache[conversationId] ?? [];
          _messageCache[conversationId] = [...messages, message];
          print('🔄 Added message to EXISTING cache. Total messages: ${_messageCache[conversationId]!.length}');
        } else {
          // Initialize the conversation cache with this message
          _messageCache[conversationId] = [message];
          print('🆕 Created NEW cache with 1 message');
        }
        
        // ALWAYS reorder conversations - this is key for real-time updates for ALL participants
        _moveConversationToTop(conversationId, message);
        
        notifyListeners();
        
        print('📥 RECEIVED: "${message.content}" from ${message.senderUsername} (ID: ${message.id})');
        
      } else if (eventType == 'typing_indicator') {
        debugPrint('⌨️ [RealtimeChatProvider] Processing TYPING_INDICATOR event');
        
        final userId = messageData['user_id'] as String?;
        final username = messageData['username'] as String?;
        final isTyping = messageData['is_typing'] as bool? ?? false;
        
        debugPrint('⌨️ [RealtimeChatProvider] Typing indicator details:');
        debugPrint('⌨️ [RealtimeChatProvider] - Conversation ID: $conversationId');
        debugPrint('⌨️ [RealtimeChatProvider] - User ID: $userId');
        debugPrint('⌨️ [RealtimeChatProvider] - Username: $username');
        debugPrint('⌨️ [RealtimeChatProvider] - Is typing: $isTyping');
        debugPrint('⌨️ [RealtimeChatProvider] - Current user ID: $_currentUserId');
        
        if (userId != null && userId != _currentUserId) {
          final typingUsers = _typingUsers[conversationId] ?? <String>{};
          
          if (isTyping) {
            typingUsers.add(userId);
            debugPrint('⌨️ [RealtimeChatProvider] Added $userId to typing users for $conversationId');
          } else {
            typingUsers.remove(userId);
            debugPrint('⌨️ [RealtimeChatProvider] Removed $userId from typing users for $conversationId');
          }
          
          _typingUsers[conversationId] = typingUsers;
          debugPrint('⌨️ [RealtimeChatProvider] Current typing users for $conversationId: ${typingUsers.toList()}');
          
          debugPrint('🔔 [RealtimeChatProvider] Notifying listeners for typing indicator change');
          notifyListeners();
        } else {
          debugPrint('⚠️ [RealtimeChatProvider] Ignoring typing indicator - missing data or from current user');
        }
      } else {
        debugPrint('⚠️ [RealtimeChatProvider] Unknown message_data type: $eventType');
      }
      
      debugPrint('💬 [RealtimeChatProvider] ==== CHAT MESSAGE EVENT END ====');
    } catch (e, stackTrace) {
      debugPrint('💥 [RealtimeChatProvider] FATAL ERROR processing chat message: $e');
      debugPrint('💥 [RealtimeChatProvider] Stack trace: $stackTrace');
      debugPrint('💥 [RealtimeChatProvider] Original data: ${jsonEncode(data)}');
    }
  }

  /// Handle typing indicator from WebSocket
  void _handleTypingIndicator(Map<String, dynamic> data) {
    try {
      debugPrint('⌨️ [RealtimeChatProvider] ==== TYPING INDICATOR EVENT START ====');
      debugPrint('⌨️ [RealtimeChatProvider] Full event data: ${jsonEncode(data)}');
      
      final conversationId = data['conversation_id'] as String?;
      final userId = data['user_id'] as String?;
      final username = data['username'] as String?;
      final isTyping = data['is_typing'] as bool? ?? false;
      
      debugPrint('⌨️ [RealtimeChatProvider] Direct typing indicator details:');
      debugPrint('⌨️ [RealtimeChatProvider] - Conversation ID: $conversationId');
      debugPrint('⌨️ [RealtimeChatProvider] - User ID: $userId');
      debugPrint('⌨️ [RealtimeChatProvider] - Username: $username');
      debugPrint('⌨️ [RealtimeChatProvider] - Is typing: $isTyping');
      debugPrint('⌨️ [RealtimeChatProvider] - Current user ID: $_currentUserId');
      
      if (conversationId != null && userId != null && userId != _currentUserId) {
        final typingUsers = _typingUsers[conversationId] ?? <String>{};
        
        if (isTyping) {
          typingUsers.add(userId);
          debugPrint('⌨️ [RealtimeChatProvider] Added $userId to typing users for $conversationId');
        } else {
          typingUsers.remove(userId);
          debugPrint('⌨️ [RealtimeChatProvider] Removed $userId from typing users for $conversationId');
        }
        
        _typingUsers[conversationId] = typingUsers;
        debugPrint('⌨️ [RealtimeChatProvider] Current typing users for $conversationId: ${typingUsers.toList()}');
        
        debugPrint('🔔 [RealtimeChatProvider] Notifying listeners for direct typing indicator');
        notifyListeners();
      } else {
        debugPrint('⚠️ [RealtimeChatProvider] Ignoring direct typing indicator - missing data or from current user');
      }
      
      debugPrint('⌨️ [RealtimeChatProvider] ==== TYPING INDICATOR EVENT END ====');
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
    debugPrint('📊 [RealtimeChatProvider] ==== MOVE CONVERSATION TO TOP START ====');
    debugPrint('📊 [RealtimeChatProvider] Target conversation ID: $conversationId');
    debugPrint('📊 [RealtimeChatProvider] New last message: ${lastMessage.content}');
    debugPrint('📊 [RealtimeChatProvider] Current conversations count: ${_conversations.length}');
    
    for (int i = 0; i < _conversations.length; i++) {
      debugPrint('📊 [RealtimeChatProvider] [$i] ${_conversations[i].id} - ${_conversations[i].displayName}');
    }
    
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    debugPrint('📊 [RealtimeChatProvider] Found conversation at index: $index');
    
    if (index > 0) {
      debugPrint('📊 [RealtimeChatProvider] Moving conversation from position $index to top');
      // Move conversation to top
      final conversation = _conversations.removeAt(index);
      final updatedConversation = conversation.copyWith(
        lastMessage: lastMessage,
        lastMessageAt: lastMessage.createdAt,
      );
      _conversations.insert(0, updatedConversation);
      
      debugPrint('✅ [RealtimeChatProvider] Successfully moved conversation $conversationId to top');
    } else if (index == 0) {
      debugPrint('📊 [RealtimeChatProvider] Conversation already at top, updating last message');
      // Already at top, just update last message
      final conversation = _conversations[0];
      _conversations[0] = conversation.copyWith(
        lastMessage: lastMessage,
        lastMessageAt: lastMessage.createdAt,
      );
      
      debugPrint('✅ [RealtimeChatProvider] Updated conversation $conversationId at top');
    } else {
      debugPrint('⚠️ [RealtimeChatProvider] Conversation $conversationId NOT FOUND in list!');
      debugPrint('⚠️ [RealtimeChatProvider] Available conversation IDs:');
      for (final conv in _conversations) {
        debugPrint('   - ${conv.id} (${conv.displayName})');
      }
      debugPrint('📊 [RealtimeChatProvider] Reloading conversations to fix missing conversation...');
      loadConversations();
      return;
    }
    
    debugPrint('📊 [RealtimeChatProvider] Final conversation order:');
    for (int i = 0; i < _conversations.length; i++) {
      final conv = _conversations[i];
      final lastMsg = conv.lastMessage?.content ?? 'No message';
      debugPrint('📊 [RealtimeChatProvider] [$i] ${conv.displayName}: ${lastMsg.substring(0, lastMsg.length > 30 ? 30 : lastMsg.length)}...');
    }
    
    debugPrint('📊 [RealtimeChatProvider] ==== MOVE CONVERSATION TO TOP END ====');
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