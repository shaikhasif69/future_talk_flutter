import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing pinned conversations using Hive local storage
/// This provides UI-only functionality for pinning conversations
class PinnedConversationsService {
  static const String _boxName = 'pinned_conversations';
  static const String _pinnedKey = 'pinned_list';
  static const String _mutedKey = 'muted_list';
  static const String _archivedKey = 'archived_list';
  
  static Box<List>? _box;
  
  /// Initialize the service
  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<List>(_boxName);
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to initialize: $e');
    }
  }
  
  /// Get pinned conversation IDs
  static Set<String> getPinnedConversations() {
    try {
      final pinnedList = _box?.get(_pinnedKey, defaultValue: <String>[]) ?? <String>[];
      return pinnedList.cast<String>().toSet();
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to get pinned conversations: $e');
      return <String>{};
    }
  }
  
  /// Pin a conversation
  static Future<bool> pinConversation(String conversationId) async {
    try {
      final currentPinned = getPinnedConversations();
      if (currentPinned.contains(conversationId)) {
        return true; // Already pinned
      }
      
      final updatedList = [...currentPinned, conversationId];
      await _box?.put(_pinnedKey, updatedList);
      debugPrint('📌 [PinnedConversationsService] Pinned conversation: $conversationId');
      return true;
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to pin conversation: $e');
      return false;
    }
  }
  
  /// Unpin a conversation
  static Future<bool> unpinConversation(String conversationId) async {
    try {
      final currentPinned = getPinnedConversations();
      if (!currentPinned.contains(conversationId)) {
        return true; // Already not pinned
      }
      
      final updatedList = currentPinned.where((id) => id != conversationId).toList();
      await _box?.put(_pinnedKey, updatedList);
      debugPrint('📌 [PinnedConversationsService] Unpinned conversation: $conversationId');
      return true;
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to unpin conversation: $e');
      return false;
    }
  }
  
  /// Toggle pin status
  static Future<bool> togglePinConversation(String conversationId) async {
    final isPinned = getPinnedConversations().contains(conversationId);
    if (isPinned) {
      return await unpinConversation(conversationId);
    } else {
      return await pinConversation(conversationId);
    }
  }
  
  /// Check if conversation is pinned
  static bool isConversationPinned(String conversationId) {
    return getPinnedConversations().contains(conversationId);
  }
  
  /// Get muted conversation IDs
  static Set<String> getMutedConversations() {
    try {
      final mutedList = _box?.get(_mutedKey, defaultValue: <String>[]) ?? <String>[];
      return mutedList.cast<String>().toSet();
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to get muted conversations: $e');
      return <String>{};
    }
  }
  
  /// Toggle mute status
  static Future<bool> toggleMuteConversation(String conversationId) async {
    try {
      final currentMuted = getMutedConversations();
      final updatedList = currentMuted.contains(conversationId)
          ? currentMuted.where((id) => id != conversationId).toList()
          : [...currentMuted, conversationId];
          
      await _box?.put(_mutedKey, updatedList);
      final action = currentMuted.contains(conversationId) ? 'Unmuted' : 'Muted';
      debugPrint('🔇 [PinnedConversationsService] $action conversation: $conversationId');
      return true;
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to toggle mute: $e');
      return false;
    }
  }
  
  /// Check if conversation is muted
  static bool isConversationMuted(String conversationId) {
    return getMutedConversations().contains(conversationId);
  }
  
  /// Get archived conversation IDs
  static Set<String> getArchivedConversations() {
    try {
      final archivedList = _box?.get(_archivedKey, defaultValue: <String>[]) ?? <String>[];
      return archivedList.cast<String>().toSet();
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to get archived conversations: $e');
      return <String>{};
    }
  }
  
  /// Toggle archive status
  static Future<bool> toggleArchiveConversation(String conversationId) async {
    try {
      final currentArchived = getArchivedConversations();
      final updatedList = currentArchived.contains(conversationId)
          ? currentArchived.where((id) => id != conversationId).toList()
          : [...currentArchived, conversationId];
          
      await _box?.put(_archivedKey, updatedList);
      final action = currentArchived.contains(conversationId) ? 'Unarchived' : 'Archived';
      debugPrint('📦 [PinnedConversationsService] $action conversation: $conversationId');
      return true;
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to toggle archive: $e');
      return false;
    }
  }
  
  /// Check if conversation is archived
  static bool isConversationArchived(String conversationId) {
    return getArchivedConversations().contains(conversationId);
  }
  
  /// Clear all pinned conversations (useful for logout)
  static Future<void> clearAllData() async {
    try {
      await _box?.clear();
      debugPrint('🧹 [PinnedConversationsService] Cleared all local data');
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to clear data: $e');
    }
  }
  
  /// Close the service (useful for app shutdown)
  static Future<void> close() async {
    try {
      await _box?.close();
      debugPrint('🔒 [PinnedConversationsService] Closed service');
    } catch (e) {
      debugPrint('❌ [PinnedConversationsService] Failed to close: $e');
    }
  }
}