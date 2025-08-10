import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_colors.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
// import '../models/group_chat.dart'; // TODO: Use when implementing group chat features
import '../models/social_battery_status.dart';
// TODO: Import WebSocket service when implemented
// import '../services/websocket_service.dart';
// import '../services/chat_repository.dart';
// import '../../../core/storage/secure_storage_service.dart';

/// Filter options for chat list
enum ChatFilter {
  all,
  friends,
  groups,
  unread,
}

/// Real-time chat list provider with WebSocket integration (mock implementation)
class RealtimeChatListProvider extends ChangeNotifier {
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
  String? _currentUserId; // TODO: Use for message filtering and API calls

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
    // TODO: Get current user ID from secure storage
    _currentUserId = 'mock_user_id';
    
    _setupQuietHoursDetection();
    await _loadConversations();
  }

  /// Load conversations (using mock data for now)
  Future<void> _loadConversations() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load mock conversations
      _conversations = _generateMockConversations();
      
      _isLoading = false;
      notifyListeners();
      
      debugPrint('✅ [RealtimeChatList] Loaded ${_conversations.length} mock conversations for user: $_currentUserId');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      debugPrint('❌ [RealtimeChatList] Unexpected error loading conversations: $e');
    }
  }

  /// Generate mock conversations for development
  List<ChatConversation> _generateMockConversations() {
    return [
      // Individual chat
      ChatConversation(
        id: '1',
        name: 'Sarah Chen',
        type: ConversationType.direct,
        participants: [
          ChatParticipant(
            id: 'sarah_001',
            name: 'Sarah Chen',
            avatarColor: AppColors.sageGreen,
            socialBattery: SocialBatteryPresets.selective(),
            isOnline: true,
          ),
        ],
        lastMessage: ChatMessage(
          id: 'msg_1',
          conversationId: '1',
          senderId: 'sarah_001',
          senderUsername: 'Sarah Chen',
          content: 'Hey! How are you feeling today?',
          messageType: MessageType.text,
          createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
          status: MessageStatus.read,
          isFromMe: false,
        ),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 32)),
        unreadCount: 2,
        isPinned: true,
      ),
      // Add more mock conversations as needed
    ];
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
      
      // TODO: Update on server when chatRepository is implemented
      debugPrint('✅ [RealtimeChatList] Marked conversation as read (local only): $conversationId');
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
      
      // TODO: Update on server when chatRepository is implemented
      debugPrint('✅ [RealtimeChatList] Updated pin status (local only): $conversationId');
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
      
      // TODO: Update on server when chatRepository is implemented
      debugPrint('✅ [RealtimeChatList] Updated mute status (local only): $conversationId');
    } catch (e) {
      debugPrint('❌ [RealtimeChatList] Error toggling mute: $e');
    }
  }

  /// Create new direct conversation (mock implementation)
  Future<ChatConversation?> createDirectConversation(String otherUserId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Create mock conversation
      final newConversation = ChatConversation(
        id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
        name: 'New User',
        type: ConversationType.direct,
        participants: [
          ChatParticipant(
            id: otherUserId,
            name: 'New User',
            avatarColor: AppColors.sageGreen,
            socialBattery: SocialBatteryPresets.energized(),
            isOnline: true,
          ),
        ],
        lastMessage: null,
        updatedAt: DateTime.now(),
        unreadCount: 0,
      );
      
      // Add to state
      _conversations.insert(0, newConversation);
      notifyListeners();
      
      debugPrint('✅ [RealtimeChatList] Created mock conversation: ${newConversation.id}');
      return newConversation;
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
        conversations = conversations.where((c) => c.isDirect).toList();
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
               (c.lastMessage?.content.toLowerCase().contains(_searchQuery) ?? false);
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
      ChatFilter.friends: _conversations.where((c) => c.isDirect).length,
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
    // TODO: Cancel subscriptions when WebSocket service is implemented
    _quietHoursTimer?.cancel();
    super.dispose();
  }
}