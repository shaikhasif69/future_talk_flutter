import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/chat_conversation.dart';
import '../models/group_chat.dart';
import '../models/social_battery_status.dart';

/// Filter options for chat list
enum ChatFilter {
  all,
  friends,
  groups,
  unread,
}

/// Chat list state management with real-time updates and filtering
class ChatListProvider extends ChangeNotifier {
  ChatListProvider() {
    _initializeMockData();
  }

  // Private state
  List<ChatConversation> _allConversations = [];
  List<ChatConversation> _filteredConversations = [];
  ChatFilter _activeFilter = ChatFilter.all;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isQuietHours = false;

  // Getters
  List<ChatConversation> get conversations => _filteredConversations;
  ChatFilter get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isQuietHours => _isQuietHours;
  bool get hasConversations => _filteredConversations.isNotEmpty;
  int get totalUnreadCount => _allConversations.fold(0, (sum, chat) => sum + chat.unreadCount);

  /// Get conversations grouped by sections (Pinned, Recent, Earlier)
  Map<String, List<ChatConversation>> get groupedConversations {
    final Map<String, List<ChatConversation>> grouped = {};
    
    for (final conversation in _filteredConversations) {
      final section = conversation.section;
      grouped.putIfAbsent(section, () => []).add(conversation);
    }
    
    // Sort each section
    grouped.forEach((section, conversations) {
      conversations.sort((a, b) {
        // Pinned conversations sorted by update time
        if (section == 'Pinned') {
          return b.updatedAt.compareTo(a.updatedAt);
        }
        // Others sorted by update time
        return b.updatedAt.compareTo(a.updatedAt);
      });
    });
    
    return grouped;
  }

  /// Get filter counts for tab badges
  Map<ChatFilter, int> get filterCounts {
    return {
      ChatFilter.all: _allConversations.length,
      ChatFilter.friends: _allConversations.where((c) => c.isIndividual).length,
      ChatFilter.groups: _allConversations.where((c) => c.isGroup).length,
      ChatFilter.unread: _allConversations.where((c) => c.hasUnreadMessages).length,
    };
  }

  /// Set active filter and update conversation list
  void setFilter(ChatFilter filter) {
    if (_activeFilter == filter) return;
    
    _activeFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  /// Update search query and filter conversations
  void updateSearchQuery(String query) {
    if (_searchQuery == query) return;
    
    _searchQuery = query.toLowerCase().trim();
    _applyFilters();
    notifyListeners();
  }

  /// Clear search query
  void clearSearch() {
    updateSearchQuery('');
  }

  /// Toggle quiet hours mode
  void toggleQuietHours() {
    _isQuietHours = !_isQuietHours;
    notifyListeners();
  }

  /// Set quiet hours state
  void setQuietHours(bool enabled) {
    if (_isQuietHours == enabled) return;
    _isQuietHours = enabled;
    notifyListeners();
  }

  /// Refresh conversation list
  Future<void> refreshConversations() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Refresh with updated data
    _initializeMockData();
    _applyFilters();
    
    _isLoading = false;
    notifyListeners();
  }

  /// Pin/unpin a conversation
  void togglePin(String conversationId) {
    final index = _allConversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;
    
    final conversation = _allConversations[index];
    _allConversations[index] = conversation.copyWith(isPinned: !conversation.isPinned);
    
    _applyFilters();
    notifyListeners();
  }

  /// Mute/unmute a conversation
  void toggleMute(String conversationId) {
    final index = _allConversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;
    
    final conversation = _allConversations[index];
    _allConversations[index] = conversation.copyWith(isMuted: !conversation.isMuted);
    
    _applyFilters();
    notifyListeners();
  }

  /// Mark conversation as read
  void markAsRead(String conversationId) {
    final index = _allConversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;
    
    final conversation = _allConversations[index];
    if (conversation.unreadCount > 0) {
      _allConversations[index] = conversation.copyWith(unreadCount: 0);
      _applyFilters();
      notifyListeners();
    }
  }

  /// Update social battery status for a user
  void updateSocialBattery(String userId, SocialBatteryStatus newStatus) {
    bool updated = false;
    
    for (int i = 0; i < _allConversations.length; i++) {
      final conversation = _allConversations[i];
      
      if (conversation.isIndividual && conversation.otherParticipant?.id == userId) {
        final updatedParticipant = conversation.otherParticipant!.copyWith(
          socialBattery: newStatus,
        );
        _allConversations[i] = conversation.copyWith(
          participants: [updatedParticipant],
        );
        updated = true;
      } else if (conversation.isGroup) {
        final updatedParticipants = conversation.participants.map((p) {
          if (p.id == userId) {
            return p.copyWith(socialBattery: newStatus);
          }
          return p;
        }).toList();
        
        if (updatedParticipants.any((p) => p.id == userId)) {
          _allConversations[i] = conversation.copyWith(
            participants: updatedParticipants,
          );
          updated = true;
        }
      }
    }
    
    if (updated) {
      _applyFilters();
      notifyListeners();
    }
  }

  /// Apply current filters and search to conversation list
  void _applyFilters() {
    List<ChatConversation> filtered = List.from(_allConversations);
    
    // Apply filter
    switch (_activeFilter) {
      case ChatFilter.all:
        // No additional filtering
        break;
      case ChatFilter.friends:
        filtered = filtered.where((c) => c.isIndividual).toList();
        break;
      case ChatFilter.groups:
        filtered = filtered.where((c) => c.isGroup).toList();
        break;
      case ChatFilter.unread:
        filtered = filtered.where((c) => c.hasUnreadMessages).toList();
        break;
    }
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) {
        // Search by conversation name
        if (c.displayName.toLowerCase().contains(_searchQuery)) {
          return true;
        }
        
        // Search by last message content
        if (c.lastMessage.content.toLowerCase().contains(_searchQuery)) {
          return true;
        }
        
        // Search by participant names (for groups)
        if (c.isGroup) {
          return c.participants.any((p) => 
            p.name.toLowerCase().contains(_searchQuery));
        }
        
        return false;
      }).toList();
    }
    
    // Sort: Pinned first, then by update time
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    
    _filteredConversations = filtered;
  }

  /// Initialize with mock conversation data
  void _initializeMockData() {
    _allConversations = [
      // Pinned individual chat
      ChatConversation(
        id: '1',
        name: 'Sarah Chen',
        type: ChatType.individual,
        participants: [
          ChatParticipant(
            id: 'sarah_001',
            name: 'Sarah Chen',
            avatarColor: AppColors.sageGreen,
            socialBattery: SocialBatteryPresets.selective(
              message: 'Perfect! I\'m feeling yellow today - selective responses mode. Thanks for checking in 💛',
            ),
            isOnline: true,
          ),
        ],
        lastMessage: LastMessage(
          content: 'Perfect! I\'m feeling yellow today - selective responses mode. Thanks for checking in 💛',
          timestamp: DateTime.now().subtract(const Duration(minutes: 32)),
          senderId: 'sarah_001',
          senderName: 'Sarah Chen',
          status: MessageStatus.read,
        ),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 32)),
        unreadCount: 2,
        isPinned: true,
      ),
      
      // Group chat - Book Club
      GroupChat(
        id: '2',
        name: 'Book Club Introverts',
        avatarEmoji: '📚',
        avatarColor: AppColors.lavenderMist,
        members: [
          GroupMember(
            id: 'jamie_002',
            name: 'Jamie Rivera',
            avatarColor: AppColors.cloudBlue,
            role: GroupRole.admin,
            joinedAt: DateTime.now().subtract(const Duration(days: 120)),
            socialBattery: SocialBatteryPresets.recharging(),
          ),
          GroupMember(
            id: 'alex_003',
            name: 'Alex Chen',
            avatarColor: AppColors.warmPeach,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 90)),
            socialBattery: SocialBatteryPresets.energized(),
          ),
          GroupMember(
            id: 'morgan_004',
            name: 'Morgan Kim',
            avatarColor: AppColors.dustyRose,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 75)),
            socialBattery: SocialBatteryPresets.selective(),
          ),
          GroupMember(
            id: 'taylor_005',
            name: 'Taylor Smith',
            avatarColor: AppColors.sageGreenLight,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 45)),
          ),
        ],
        lastMessage: LastMessage(
          content: 'Jamie: Should we start "Quiet" by Susan Cain next?',
          timestamp: DateTime.now().subtract(const Duration(hours: 18)),
          senderId: 'jamie_002',
          senderName: 'Jamie',
          status: MessageStatus.delivered,
        ),
        updatedAt: DateTime.now().subtract(const Duration(hours: 18)),
        unreadCount: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        createdBy: 'jamie_002',
      ),
      
      // Individual chat - Morgan
      ChatConversation(
        id: '3',
        name: 'Morgan Kim',
        type: ChatType.individual,
        participants: [
          ChatParticipant(
            id: 'morgan_004',
            name: 'Morgan Kim',
            avatarColor: AppColors.dustyRose,
            socialBattery: SocialBatteryPresets.energized(),
            isOnline: true,
          ),
        ],
        lastMessage: LastMessage(
          content: 'Thanks for the comfort stone touch earlier! Really needed that ✨',
          timestamp: DateTime.now().subtract(const Duration(hours: 20)),
          senderId: 'morgan_004',
          senderName: 'Morgan Kim',
          status: MessageStatus.read,
          isFromMe: false,
        ),
        updatedAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      
      // Group chat - Game Night
      GroupChat(
        id: '4',
        name: 'Game Night Squad',
        avatarEmoji: '🎮',
        avatarColor: AppColors.cloudBlue,
        members: [
          GroupMember(
            id: 'alex_003',
            name: 'Alex Chen',
            avatarColor: AppColors.warmPeach,
            role: GroupRole.admin,
            joinedAt: DateTime.now().subtract(const Duration(days: 60)),
            socialBattery: SocialBatteryPresets.energized(),
          ),
          GroupMember(
            id: 'morgan_004',
            name: 'Morgan Kim',
            avatarColor: AppColors.dustyRose,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 50)),
            socialBattery: SocialBatteryPresets.energized(),
          ),
          GroupMember(
            id: 'sam_006',
            name: 'Sam Wilson',
            avatarColor: AppColors.lavenderMist,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 30)),
            socialBattery: SocialBatteryPresets.selective(),
          ),
        ],
        lastMessage: LastMessage(
          content: 'Alex: Chess rematch tonight? 😊',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          senderId: 'alex_003',
          senderName: 'Alex',
          status: MessageStatus.sent,
        ),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        createdBy: 'alex_003',
      ),
      
      // Individual chat - Jamie (recharging)
      ChatConversation(
        id: '5',
        name: 'Jamie Rivera',
        type: ChatType.individual,
        participants: [
          ChatParticipant(
            id: 'jamie_002',
            name: 'Jamie Rivera',
            avatarColor: AppColors.cloudBlue,
            socialBattery: SocialBatteryPresets.recharging(
              message: '💤 Recharging mode activated for the week',
            ),
            isOnline: false,
            lastSeen: DateTime.now().subtract(const Duration(hours: 12)),
          ),
        ],
        lastMessage: LastMessage(
          content: '💤 Recharging mode activated for the week',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          senderId: 'jamie_002',
          senderName: 'Jamie Rivera',
          status: MessageStatus.read,
        ),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      
      // Individual chat - Alex (muted)
      ChatConversation(
        id: '6',
        name: 'Alex Rivera',
        type: ChatType.individual,
        participants: [
          ChatParticipant(
            id: 'alex_007',
            name: 'Alex Rivera',
            avatarColor: AppColors.warmPeach,
            socialBattery: SocialBatteryPresets.energized(),
            isOnline: true,
          ),
        ],
        lastMessage: LastMessage(
          content: 'Good morning! How was your reading session?',
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
          senderId: 'alex_007',
          senderName: 'Alex Rivera',
          status: MessageStatus.sent,
        ),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        isMuted: true,
      ),
      
      // Group chat - Family
      GroupChat(
        id: '7',
        name: 'Family Circle',
        avatarEmoji: '👨‍👩‍👧‍👦',
        avatarColor: AppColors.warmPeach,
        members: [
          GroupMember(
            id: 'mom_001',
            name: 'Mom',
            avatarColor: AppColors.dustyRose,
            role: GroupRole.admin,
            joinedAt: DateTime.now().subtract(const Duration(days: 365)),
            socialBattery: SocialBatteryPresets.energized(),
          ),
          GroupMember(
            id: 'dad_002',
            name: 'Dad',
            avatarColor: AppColors.sageGreen,
            role: GroupRole.admin,
            joinedAt: DateTime.now().subtract(const Duration(days: 365)),
            socialBattery: SocialBatteryPresets.selective(),
          ),
          GroupMember(
            id: 'sister_003',
            name: 'Emma',
            avatarColor: AppColors.lavenderMist,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 300)),
            socialBattery: SocialBatteryPresets.energized(),
          ),
          GroupMember(
            id: 'brother_004',
            name: 'Jake',
            avatarColor: AppColors.cloudBlue,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 280)),
          ),
          GroupMember(
            id: 'user_self',
            name: 'You',
            avatarColor: AppColors.sageGreen,
            role: GroupRole.member,
            joinedAt: DateTime.now().subtract(const Duration(days: 365)),
          ),
        ],
        lastMessage: LastMessage(
          content: 'Mom: Looking forward to our reading session this weekend!',
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          senderId: 'mom_001',
          senderName: 'Mom',
          status: MessageStatus.read,
        ),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        createdBy: 'mom_001',
      ),
    ];
    
    // Set initial quiet hours
    final now = DateTime.now();
    _isQuietHours = now.hour < 9 || now.hour > 22;
    
    _applyFilters();
  }
}