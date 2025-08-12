import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friend_search_models.dart';
import '../services/friend_search_service.dart';

/// Provider for FriendSearchService instance
final friendSearchServiceProvider = Provider<FriendSearchService>((ref) {
  return FriendSearchService();
});

/// Provider for friends list
final friendsProvider = FutureProvider<List<UserSearchResult>>((ref) async {
  final service = ref.read(friendSearchServiceProvider);
  final result = await service.getFriends();
  
  return result.when(
    success: (friends) => friends,
    failure: (error) => throw Exception(error.message),
  );
});

/// Provider for friend requests list
final friendRequestsProvider = FutureProvider<List<FriendRequest>>((ref) async {
  final service = ref.read(friendSearchServiceProvider);
  final result = await service.getFriendRequests();
  
  return result.when(
    success: (requests) => requests,
    failure: (error) => throw Exception(error.message),
  );
});

/// State notifier for managing friend request actions
class FriendRequestActionsNotifier extends StateNotifier<AsyncValue<String?>> {
  FriendRequestActionsNotifier(this.ref) : super(const AsyncValue.data(null));
  
  final Ref ref;

  /// Accept a friend request
  Future<bool> acceptFriendRequest(String requestId) async {
    state = const AsyncValue.loading();
    
    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.acceptFriendRequest(requestId);
      
      return result.when(
        success: (response) {
          state = AsyncValue.data(response.message);
          // Refresh both friends and friend requests lists
          ref.invalidate(friendsProvider);
          ref.invalidate(friendRequestsProvider);
          return true;
        },
        failure: (error) {
          state = AsyncValue.error(error.message, StackTrace.current);
          return false;
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }

  /// Reject a friend request
  Future<bool> rejectFriendRequest(String requestId) async {
    state = const AsyncValue.loading();
    
    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.rejectFriendRequest(requestId);
      
      return result.when(
        success: (response) {
          state = AsyncValue.data(response.message);
          // Refresh friend requests list
          ref.invalidate(friendRequestsProvider);
          return true;
        },
        failure: (error) {
          state = AsyncValue.error(error.message, StackTrace.current);
          return false;
        },
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return false;
    }
  }

  /// Clear any success/error messages
  void clearMessage() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for friend request actions
final friendRequestActionsProvider = 
    StateNotifierProvider<FriendRequestActionsNotifier, AsyncValue<String?>>((ref) {
  return FriendRequestActionsNotifier(ref);
});

/// Provider for friends count (computed from friends list)
final friendsCountProvider = Provider<int>((ref) {
  final friends = ref.watch(friendsProvider);
  return friends.when(
    data: (friends) => friends.length,
    loading: () => 0,
    error: (error, stack) => 0,
  );
});

/// Provider for friend requests count (computed from friend requests list)
final friendRequestsCountProvider = Provider<int>((ref) {
  final requests = ref.watch(friendRequestsProvider);
  return requests.when(
    data: (requests) => requests.length,
    loading: () => 0,
    error: (error, stack) => 0,
  );
});