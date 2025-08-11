import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/friend_search_models.dart';
import '../services/friend_search_service.dart';

part 'friend_search_provider.freezed.dart';
part 'friend_search_provider.g.dart';

/// Friend search state management
@freezed
class FriendSearchState with _$FriendSearchState {
  const factory FriendSearchState({
    /// Current search results
    @Default([]) List<UserSearchResult> searchResults,
    
    /// User suggestions
    @Default([]) List<UserSearchResult> suggestions,
    
    /// Current search query
    @Default('') String searchQuery,
    
    /// Search type filter
    @Default(SearchType.all) SearchType searchType,
    
    /// Whether search is in progress
    @Default(false) bool isSearching,
    
    /// Whether suggestions are loading
    @Default(false) bool isLoadingSuggestions,
    
    /// Whether friend request is being sent
    @Default(false) bool isSendingFriendRequest,
    
    /// Current search error message
    String? searchError,
    
    /// Current suggestions error message
    String? suggestionsError,
    
    /// Friend request operation error
    String? friendRequestError,
    
    /// Recently looked up user
    UserLookupResult? lookedUpUser,
    
    /// Whether user lookup is in progress
    @Default(false) bool isLookingUpUser,
    
    /// User lookup error
    String? lookupError,
  }) = _FriendSearchState;
}

/// Provider for friend search service
@Riverpod(keepAlive: true)
FriendSearchService friendSearchService(FriendSearchServiceRef ref) {
  return FriendSearchService();
}

/// Provider for friend search state management
@riverpod
class FriendSearchNotifier extends _$FriendSearchNotifier {
  @override
  FriendSearchState build() {
    return const FriendSearchState();
  }

  /// Search for users with the given query
  Future<void> searchUsers({
    required String query,
    SearchType searchType = SearchType.all,
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        searchResults: [],
        searchQuery: '',
        searchError: null,
      );
      return;
    }

    state = state.copyWith(
      isSearching: true,
      searchError: null,
      searchQuery: query.trim(),
      searchType: searchType,
    );

    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.searchUsers(
        query: query.trim(),
        searchType: searchType,
        limit: limit,
      );

      result.when(
        success: (users) {
          state = state.copyWith(
            searchResults: users,
            isSearching: false,
            searchError: null,
          );
        },
        failure: (error) {
          state = state.copyWith(
            searchResults: [],
            isSearching: false,
            searchError: error.message,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        searchResults: [],
        isSearching: false,
        searchError: 'An unexpected error occurred',
      );
      debugPrint('Search error: $e');
    }
  }

  /// Clear search results and query
  void clearSearch() {
    state = state.copyWith(
      searchResults: [],
      searchQuery: '',
      searchError: null,
      isSearching: false,
    );
  }

  /// Update search type filter
  void updateSearchType(SearchType searchType) {
    if (state.searchType != searchType) {
      state = state.copyWith(searchType: searchType);
      
      // Re-search with new filter if there's an active query
      if (state.searchQuery.isNotEmpty) {
        searchUsers(
          query: state.searchQuery,
          searchType: searchType,
        );
      }
    }
  }

  /// Load user suggestions
  Future<void> loadSuggestions({int limit = 10}) async {
    state = state.copyWith(
      isLoadingSuggestions: true,
      suggestionsError: null,
    );

    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.getUserSuggestions(limit: limit);

      result.when(
        success: (suggestions) {
          state = state.copyWith(
            suggestions: suggestions,
            isLoadingSuggestions: false,
            suggestionsError: null,
          );
        },
        failure: (error) {
          state = state.copyWith(
            suggestions: [],
            isLoadingSuggestions: false,
            suggestionsError: error.message,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        suggestions: [],
        isLoadingSuggestions: false,
        suggestionsError: 'Failed to load suggestions',
      );
      debugPrint('Suggestions error: $e');
    }
  }

  /// Look up a user by exact identifier
  Future<void> lookupUser(String identifier) async {
    if (identifier.trim().isEmpty) {
      state = state.copyWith(
        lookedUpUser: null,
        lookupError: 'Identifier cannot be empty',
      );
      return;
    }

    state = state.copyWith(
      isLookingUpUser: true,
      lookupError: null,
      lookedUpUser: null,
    );

    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.lookupUser(identifier.trim());

      result.when(
        success: (user) {
          state = state.copyWith(
            lookedUpUser: user,
            isLookingUpUser: false,
            lookupError: null,
          );
        },
        failure: (error) {
          state = state.copyWith(
            lookedUpUser: null,
            isLookingUpUser: false,
            lookupError: error.message,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        lookedUpUser: null,
        isLookingUpUser: false,
        lookupError: 'An unexpected error occurred',
      );
      debugPrint('Lookup error: $e');
    }
  }

  /// Send a friend request
  Future<bool> sendFriendRequest({
    required String targetUsername,
    String? message,
  }) async {
    state = state.copyWith(
      isSendingFriendRequest: true,
      friendRequestError: null,
    );

    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.sendFriendRequest(
        targetUsername: targetUsername,
        message: message,
      );

      return result.when(
        success: (response) {
          state = state.copyWith(
            isSendingFriendRequest: false,
            friendRequestError: null,
          );
          
          // Update the friendship status in search results if the user is present
          _updateUserFriendshipStatus(targetUsername, FriendshipStatus.pending);
          
          return true;
        },
        failure: (error) {
          state = state.copyWith(
            isSendingFriendRequest: false,
            friendRequestError: error.message,
          );
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isSendingFriendRequest: false,
        friendRequestError: 'An unexpected error occurred',
      );
      debugPrint('Send friend request error: $e');
      return false;
    }
  }

  /// Accept a friend request
  Future<bool> acceptFriendRequest(String requestId, String username) async {
    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.acceptFriendRequest(requestId);

      return result.when(
        success: (response) {
          // Update friendship status to accepted
          _updateUserFriendshipStatus(username, FriendshipStatus.accepted);
          return true;
        },
        failure: (error) {
          state = state.copyWith(friendRequestError: error.message);
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        friendRequestError: 'Failed to accept friend request',
      );
      debugPrint('Accept friend request error: $e');
      return false;
    }
  }

  /// Block a user
  Future<bool> blockUser(String userId, String username) async {
    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.blockUser(userId);

      return result.when(
        success: (response) {
          // Update friendship status to blocked
          _updateUserFriendshipStatus(username, FriendshipStatus.blocked);
          return true;
        },
        failure: (error) {
          state = state.copyWith(friendRequestError: error.message);
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        friendRequestError: 'Failed to block user',
      );
      debugPrint('Block user error: $e');
      return false;
    }
  }

  /// Unblock a user
  Future<bool> unblockUser(String userId, String username) async {
    try {
      final service = ref.read(friendSearchServiceProvider);
      final result = await service.unblockUser(userId);

      return result.when(
        success: (response) {
          // Update friendship status to none
          _updateUserFriendshipStatus(username, FriendshipStatus.none);
          return true;
        },
        failure: (error) {
          state = state.copyWith(friendRequestError: error.message);
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
        friendRequestError: 'Failed to unblock user',
      );
      debugPrint('Unblock user error: $e');
      return false;
    }
  }

  /// Update friendship status for a user in search results and suggestions
  void _updateUserFriendshipStatus(String username, FriendshipStatus status) {
    // Update search results
    final updatedSearchResults = state.searchResults.map((user) {
      if (user.username == username) {
        return user.copyWith(friendshipStatus: status);
      }
      return user;
    }).toList();

    // Update suggestions
    final updatedSuggestions = state.suggestions.map((user) {
      if (user.username == username) {
        return user.copyWith(friendshipStatus: status);
      }
      return user;
    }).toList();

    // Update looked up user if it matches
    UserLookupResult? updatedLookedUpUser = state.lookedUpUser;
    if (state.lookedUpUser?.username == username) {
      updatedLookedUpUser = state.lookedUpUser!.copyWith(friendshipStatus: status);
    }

    state = state.copyWith(
      searchResults: updatedSearchResults,
      suggestions: updatedSuggestions,
      lookedUpUser: updatedLookedUpUser,
    );
  }

  /// Clear all error messages
  void clearErrors() {
    state = state.copyWith(
      searchError: null,
      suggestionsError: null,
      friendRequestError: null,
      lookupError: null,
    );
  }

  /// Refresh suggestions
  Future<void> refreshSuggestions() async {
    await loadSuggestions();
  }

  /// Get filtered search results based on friendship status
  List<UserSearchResult> getFilteredResults(FriendshipStatus? statusFilter) {
    if (statusFilter == null) {
      return state.searchResults;
    }
    
    return state.searchResults
        .where((user) => user.friendshipStatus == statusFilter)
        .toList();
  }

  /// Get users that can receive friend requests
  List<UserSearchResult> get usersAvailableForFriendRequest {
    return state.searchResults
        .where((user) => user.friendshipStatus.canSendRequest)
        .toList();
  }

  /// Get current friends from search results
  List<UserSearchResult> get friendsFromResults {
    return state.searchResults
        .where((user) => user.friendshipStatus.isFriend)
        .toList();
  }
}