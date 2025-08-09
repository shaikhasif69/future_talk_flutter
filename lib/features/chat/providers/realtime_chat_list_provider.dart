import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_colors.dart';
import '../models/chat_conversation.dart';
import '../models/group_chat.dart';
import '../models/social_battery_status.dart';
import '../services/websocket_service.dart';
import '../services/chat_repository.dart';
import '../../../core/storage/secure_storage_service.dart';

// Global WebSocket service instance
WebSocketService? _globalChatListWebSocketService;

WebSocketService _getChatListWebSocketService() {
  _globalChatListWebSocketService ??= WebSocketService();
  return _globalChatListWebSocketService!;
}

/// Filter options for chat list
enum ChatFilter {
  all,
  friends,
  groups,
  unread,
}

/// Real-time chat list provider with WebSocket integration
class RealtimeChatListProvider extends ChangeNotifier {
  WebSocketService? _webSocketService;
  late StreamSubscription _newMessageSubscription;
  late StreamSubscription _onlineStatusSubscription;
  late StreamSubscription _typingSubscription;
  Timer? _quietHoursTimer;

  // State
  List<ChatConversation> _conversations = [];
  ChatFilter _activeFilter = ChatFilter.all;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isQuietHours = false;
  final Map<String, bool> _onlineStatus = {};
  final Map<String, String> _typingStatus = {}; // conversationId -> username
  String? _errorMessage;
  String? _currentUserId;

  // Getters
  List<ChatConversation> get conversations => filteredConversations;
  ChatFilter get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isQuietHours => _isQuietHours;
  Map<String, bool> get onlineStatus => _onlineStatus;
  Map<String, String> get typingStatus => _typingStatus;
  String? get errorMessage => _errorMessage;
  bool get hasConversations => filteredConversations.isNotEmpty;

  RealtimeChatListProvider() {
    _initialize();
  }

  /// Initialize provider
  Future<void> _initialize() async {
    // Get current user ID first
    _currentUserId = await SecureStorageService.getUserId();
    
    await _initializeWebSocket();
    _setupQuietHoursDetection();
    await _loadConversations();
  }

  /// Initialize WebSocket connection and event listeners
  Future<void> _initializeWebSocket() async {
    try {
      _webSocketService = _getChatListWebSocketService();
      if (!_webSocketService!.isConnected) {
        await _webSocketService!.connect();
      }

      // Listen to new messages
      _newMessageSubscription = _webSocketService!.onNewMessage.listen(
        _handleNewMessage,
        onError: (error) {
          debugPrint('❌ [RealtimeChatList] New message stream error: $error');
        },
      );

      // Listen to online status updates
      _onlineStatusSubscription = _webSocketService!.onOnlineStatus.listen(
        _handleOnlineStatusUpdate,
        onError: (error) {
          debugPrint('❌ [RealtimeChatList] Online status stream error: $error');
        },
      );

      // Listen to typing indicators
      _typingSubscription = _webSocketService!.onTyping.listen(
        _handleTypingIndicator,
        onError: (error) {
          debugPrint('❌ [RealtimeChatList] Typing stream error: $error');
        },
      );

      debugPrint('✅ [RealtimeChatList] WebSocket initialized');
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] WebSocket initialization failed: $e');
      _errorMessage = 'Failed to initialize real-time features: $e';
      notifyListeners();
    }
  }

  /// Load conversations from API
  Future<void> _loadConversations() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await chatRepository.getConversations();
      
      result.when(
        success: (apiConversations) async {
          // Convert API conversations to app models with deduplication
          final newConversations = await _convertApiConversations(apiConversations);
          
          // Merge with existing conversations and deduplicate
          _conversations = _deduplicateConversations([..._conversations, ...newConversations]);
          
          _isLoading = false;
          notifyListeners();
          
          // Get online status for all participants
          await _updateOnlineStatus();
          
          debugPrint('✅ [RealtimeChatList] Loaded ${_conversations.length} conversations (after deduplication)');
        },
        failure: (error) {
          _isLoading = false;
          _errorMessage = error.message;
          notifyListeners();
          debugPrint('❌ [RealtimeChatList] Failed to load conversations: ${error.message}');
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      debugPrint('❌ [RealtimeChatList] Unexpected error loading conversations: $e');
    }
  }

  /// Convert API conversations to app conversation models
  Future<List<ChatConversation>> _convertApiConversations(List<ApiConversation> apiConversations) async {
    final conversations = <ChatConversation>[];
    final seenIds = <String>{};
    
    for (final apiConv in apiConversations) {
      // Skip if we've already processed this conversation
      if (seenIds.contains(apiConv.id)) {
        debugPrint('⚠️ [RealtimeChatList] Skipping duplicate conversation: ${apiConv.id}');
        continue;
      }
      seenIds.add(apiConv.id);
      if (apiConv.conversationType == 'direct') {
        // Convert to individual chat
        final otherParticipant = apiConv.participants.firstWhere(
          (p) => p.userId != _currentUserId,
          orElse: () => apiConv.participants.first,
        );
        
        final conversation = ChatConversation(
          id: apiConv.id,
          name: otherParticipant.username,
          type: ChatType.individual,
          participants: [
            ChatParticipant(
              id: otherParticipant.userId,
              name: otherParticipant.username,
              avatarColor: AppColors.sageGreen, // Default color
              socialBattery: SocialBatteryPresets.energized(), // Default status
              isOnline: _onlineStatus[otherParticipant.userId] ?? false,
            ),
          ],
          lastMessage: apiConv.lastMessage != null
              ? LastMessage(
                  content: apiConv.lastMessage!.content,
                  timestamp: apiConv.lastMessage!.createdAt,
                  senderId: apiConv.lastMessage!.senderId,
                  senderName: 'User', // We might need to get this separately
                  status: MessageStatus.delivered, // Default status
                )
              : LastMessage(
                  content: '',
                  timestamp: apiConv.createdAt,
                  senderId: '',
                  senderName: '',
                  status: MessageStatus.sent,
                ),
          updatedAt: apiConv.lastMessageAt,
          unreadCount: apiConv.unreadCount,
        );
        
        conversations.add(conversation);
      } else {
        // Convert to group chat
        final members = apiConv.participants.map((p) => GroupMember(
          id: p.userId,
          name: p.username,
          avatarColor: AppColors.cloudBlue, // Default color
          role: p.role == 'admin' ? GroupRole.admin : GroupRole.member,
          joinedAt: p.joinedAt,
          socialBattery: SocialBatteryPresets.energized(), // Default status
        )).toList();
        
        final groupChat = GroupChat(
          id: apiConv.id,
          name: 'Group Chat', // We might need to get the actual name
          avatarEmoji: '👥', // Default emoji
          avatarColor: AppColors.lavenderMist,
          members: members,
          lastMessage: apiConv.lastMessage != null
              ? LastMessage(
                  content: apiConv.lastMessage!.content,
                  timestamp: apiConv.lastMessage!.createdAt,
                  senderId: apiConv.lastMessage!.senderId,
                  senderName: 'Member',
                  status: MessageStatus.delivered,
                )
              : LastMessage(
                  content: '',
                  timestamp: apiConv.createdAt,
                  senderId: '',
                  senderName: '',
                  status: MessageStatus.sent,
                ),
          updatedAt: apiConv.lastMessageAt,
          unreadCount: apiConv.unreadCount,
          createdAt: apiConv.createdAt,
          createdBy: apiConv.participants.first.userId, // Assuming first is creator
        );
        
        conversations.add(groupChat);
      }
    }
    
    return conversations;
  }

  /// Deduplicate conversations by ID, keeping the most recent version
  List<ChatConversation> _deduplicateConversations(List<ChatConversation> conversations) {
    final Map<String, ChatConversation> conversationMap = {};
    
    for (final conversation in conversations) {
      final existing = conversationMap[conversation.id];
      if (existing == null || conversation.updatedAt.isAfter(existing.updatedAt)) {
        conversationMap[conversation.id] = conversation;
      }
    }
    
    final deduplicatedList = conversationMap.values.toList();
    debugPrint('🔄 [RealtimeChatList] Deduplicated ${conversations.length} -> ${deduplicatedList.length} conversations');
    return deduplicatedList;
  }

  /// Handle new message from WebSocket
  void _handleNewMessage(Map<String, dynamic> messageData) {
    try {
      final conversationId = messageData['conversation_id'] as String;
      final message = messageData['message'] as Map<String, dynamic>;
      
      // Update conversation with new message
      for (int i = 0; i < _conversations.length; i++) {
        if (_conversations[i].id == conversationId) {
          final newLastMessage = LastMessage(
            content: message['content'] as String,
            timestamp: DateTime.parse(message['created_at'] as String),
            senderId: message['sender_id'] as String,
            senderName: message['sender_username'] as String? ?? 'User',
            status: MessageStatus.delivered,
          );
          
          _conversations[i] = _conversations[i].copyWith(
            lastMessage: newLastMessage,
            updatedAt: DateTime.now(),
            unreadCount: _conversations[i].unreadCount + 1,
          );
          break;
        }
      }
      
      // Sort by most recent
      _conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      notifyListeners();
      
      debugPrint('📨 [RealtimeChatList] New message in conversation: $conversationId');
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error handling new message: $e');
    }
  }

  /// Handle online status update from WebSocket
  void _handleOnlineStatusUpdate(WebSocketMessage message) {
    try {
      final onlineStatusData = message.data['online_status'] as Map<String, dynamic>?;
      
      if (onlineStatusData != null) {
        for (final entry in onlineStatusData.entries) {
          _onlineStatus[entry.key] = entry.value as bool;
        }
        
        // Update conversations with new online status
        for (int i = 0; i < _conversations.length; i++) {
          final conv = _conversations[i];
          if (conv.isIndividual && conv.otherParticipant != null) {
            final userId = conv.otherParticipant!.id;
            if (_onlineStatus.containsKey(userId)) {
              final updatedParticipant = conv.otherParticipant!.copyWith(
                isOnline: _onlineStatus[userId]!,
              );
              _conversations[i] = conv.copyWith(participants: [updatedParticipant]);
            }
          }
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error handling online status: $e');
    }
  }

  /// Handle typing indicator from WebSocket
  void _handleTypingIndicator(WebSocketMessage message) {
    try {
      final conversationId = message.conversationId;
      final isTyping = message.data['is_typing'] as bool? ?? false;
      final userName = message.data['username'] as String? ?? 'Someone';
      
      if (conversationId != null) {
        if (isTyping) {
          _typingStatus[conversationId] = userName;
        } else {
          _typingStatus.remove(conversationId);
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error handling typing indicator: $e');
    }
  }

  /// Update online status for all participants
  Future<void> _updateOnlineStatus() async {
    if (_webSocketService == null || !_webSocketService!.isConnected) return;
    
    // Get all unique user IDs
    final userIds = <String>{};
    for (final conv in _conversations) {
      for (final participant in conv.participants) {
        userIds.add(participant.id);
      }
    }
    
    if (userIds.isNotEmpty) {
      await _webSocketService!.getOnlineStatus(userIds.toList());
    }
  }

  /// Set up quiet hours detection
  void _setupQuietHoursDetection() {
    final now = DateTime.now();
    _isQuietHours = now.hour < 9 || now.hour > 22;
    
    // Check quiet hours every minute
    _quietHoursTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final shouldBeQuietHours = now.hour < 9 || now.hour > 22;
      
      if (_isQuietHours != shouldBeQuietHours) {
        _isQuietHours = shouldBeQuietHours;
        notifyListeners();
      }
    });
  }

  /// Public methods for UI interaction

  /// Set active filter
  void setFilter(ChatFilter filter) {
    if (_activeFilter != filter) {
      _activeFilter = filter;
      notifyListeners();
    }
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase().trim();
    notifyListeners();
  }

  /// Clear search query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Toggle quiet hours
  void toggleQuietHours() {
    _isQuietHours = !_isQuietHours;
    notifyListeners();
  }

  /// Refresh conversations
  Future<void> refreshConversations() async {
    _isRefreshing = true;
    notifyListeners();
    await _loadConversations();
    _isRefreshing = false;
    notifyListeners();
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    try {
      // Update local state immediately
      for (int i = 0; i < _conversations.length; i++) {
        if (_conversations[i].id == conversationId && _conversations[i].unreadCount > 0) {
          _conversations[i] = _conversations[i].copyWith(unreadCount: 0);
          break;
        }
      }
      notifyListeners();
      
      // Update on server
      final result = await chatRepository.markConversationAsRead(conversationId);
      result.when(
        success: (_) {
          debugPrint('✅ [RealtimeChatList] Marked conversation as read: $conversationId');
        },
        failure: (error) {
          debugPrint('❌ [RealtimeChatList] Failed to mark as read: ${error.message}');
        },
      );
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error marking as read: $e');
    }
  }

  /// Toggle pin status
  Future<void> togglePin(String conversationId) async {
    try {
      final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (conversationIndex == -1) return;
      
      final conversation = _conversations[conversationIndex];
      final newPinStatus = !conversation.isPinned;
      
      // Update local state immediately
      _conversations[conversationIndex] = conversation.copyWith(isPinned: newPinStatus);
      notifyListeners();
      
      // Update on server
      final result = await chatRepository.updateConversationSettings(
        conversationId: conversationId,
        isPinned: newPinStatus,
      );
      
      result.when(
        success: (updatedConv) {
          debugPrint('✅ [RealtimeChatList] Updated pin status: $conversationId');
        },
        failure: (error) {
          // Revert local change
          _conversations[conversationIndex] = conversation.copyWith(isPinned: !newPinStatus);
          notifyListeners();
          debugPrint('❌ [RealtimeChatList] Failed to update pin status: ${error.message}');
        },
      );
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error toggling pin: $e');
    }
  }

  /// Toggle mute status
  Future<void> toggleMute(String conversationId) async {
    try {
      final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (conversationIndex == -1) return;
      
      final conversation = _conversations[conversationIndex];
      final newMuteStatus = !conversation.isMuted;
      
      // Update local state immediately
      _conversations[conversationIndex] = conversation.copyWith(isMuted: newMuteStatus);
      notifyListeners();
      
      // Update on server
      final result = await chatRepository.updateConversationSettings(
        conversationId: conversationId,
        isMuted: newMuteStatus,
      );
      
      result.when(
        success: (updatedConv) {
          debugPrint('✅ [RealtimeChatList] Updated mute status: $conversationId');
        },
        failure: (error) {
          // Revert local change
          _conversations[conversationIndex] = conversation.copyWith(isMuted: !newMuteStatus);
          notifyListeners();
          debugPrint('❌ [RealtimeChatList] Failed to update mute status: ${error.message}');
        },
      );
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error toggling mute: $e');
    }
  }

  /// Create new direct conversation
  Future<ChatConversation?> createDirectConversation(String otherUserId) async {
    try {
      final result = await chatRepository.createConversation(
        participantIds: [otherUserId],
        conversationType: 'direct',
      );
      
      return await result.when(
        success: (apiConv) async {
          final conversations = await _convertApiConversations([apiConv]);
          final newConversation = conversations.first;
          
          // Add to state
          _conversations.insert(0, newConversation);
          notifyListeners();
          
          // Join conversation for real-time updates
          await _webSocketService?.joinConversation(newConversation.id);
          
          debugPrint('✅ [RealtimeChatList] Created conversation: ${newConversation.id}');
          return newConversation;
        },
        failure: (error) {
          debugPrint('❌ [RealtimeChatList] Failed to create conversation: ${error.message}');
          _errorMessage = error.message;
          notifyListeners();
          return null;
        },
      );
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error creating conversation: $e');
      _errorMessage = 'Failed to create conversation: $e';
      notifyListeners();
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Computed properties for UI

  /// Get filtered conversations
  List<ChatConversation> get filteredConversations {
    var conversations = List<ChatConversation>.from(_conversations);
    
    // Apply filter
    switch (_activeFilter) {
      case ChatFilter.all:
        break;
      case ChatFilter.friends:
        conversations = conversations.where((c) => c.isIndividual).toList();
        break;
      case ChatFilter.groups:
        conversations = conversations.where((c) => c.isGroup).toList();
        break;
      case ChatFilter.unread:
        conversations = conversations.where((c) => c.hasUnreadMessages).toList();
        break;
    }
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      conversations = conversations.where((c) {
        return c.displayName.toLowerCase().contains(_searchQuery) ||
               c.lastMessage.content.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    
    // Sort: Pinned first, then by update time
    conversations.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    
    return conversations;
  }

  /// Get conversations grouped by sections
  Map<String, List<ChatConversation>> get groupedConversations {
    final Map<String, List<ChatConversation>> grouped = {};
    
    for (final conversation in filteredConversations) {
      final section = conversation.section;
      grouped.putIfAbsent(section, () => []).add(conversation);
    }
    
    return grouped;
  }

  /// Get filter counts
  Map<ChatFilter, int> get filterCounts {
    return {
      ChatFilter.all: _conversations.length,
      ChatFilter.friends: _conversations.where((c) => c.isIndividual).length,
      ChatFilter.groups: _conversations.where((c) => c.isGroup).length,
      ChatFilter.unread: _conversations.where((c) => c.hasUnreadMessages).length,
    };
  }

  /// Get total unread count
  int get totalUnreadCount {
    return _conversations.fold(0, (sum, chat) => sum + chat.unreadCount);
  }

  /// Get typing status for conversation
  String? getTypingStatus(String conversationId) {
    return _typingStatus[conversationId];
  }

  @override
  void dispose() {
    _newMessageSubscription.cancel();
    _onlineStatusSubscription.cancel();
    _typingSubscription.cancel();
    _quietHoursTimer?.cancel();
    _webSocketService?.dispose();
    super.dispose();
  }
}