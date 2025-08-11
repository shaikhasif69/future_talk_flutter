import 'package:flutter/foundation.dart';
import '../services/friend_search_service.dart';
import '../models/friend_search_models.dart';

/// Example usage and testing class for FriendSearchService
/// 
/// This class demonstrates how to use the friend search API services
/// and provides examples for all available operations.
/// 
/// Usage in your app:
/// ```dart
/// final example = FriendSearchExample();
/// await example.demonstrateUserSearch();
/// ```
class FriendSearchExample {
  final FriendSearchService _friendSearchService = FriendSearchService();

  /// Demonstrates user search functionality with different search types
  Future<void> demonstrateUserSearch() async {
    debugPrint('🧪 [FriendSearchExample] Testing user search functionality...');

    // Example 1: Basic user search
    final searchResult = await _friendSearchService.searchUsers(
      query: 'john',
      searchType: SearchType.all,
      limit: 10,
    );

    searchResult.when(
      success: (users) {
        debugPrint('✅ [Search] Found ${users.length} users');
        for (final user in users) {
          debugPrint('   - ${user.displayName} (@${user.username}) - ${user.friendshipStatus.description}');
        }
      },
      failure: (error) {
        debugPrint('❌ [Search] Error: ${error.message}');
      },
    );

    // Example 2: Username-only search
    final usernameSearchResult = await _friendSearchService.searchUsers(
      query: 'doe',
      searchType: SearchType.username,
      limit: 5,
    );

    usernameSearchResult.when(
      success: (users) {
        debugPrint('✅ [Username Search] Found ${users.length} users');
        for (final user in users) {
          debugPrint('   - @${user.username} (${user.socialBattery}% battery)');
        }
      },
      failure: (error) {
        debugPrint('❌ [Username Search] Error: ${error.message}');
      },
    );
  }

  /// Demonstrates user lookup by exact identifier
  Future<void> demonstrateUserLookup() async {
    debugPrint('🧪 [FriendSearchExample] Testing user lookup functionality...');

    // Example: Lookup user by username
    final lookupResult = await _friendSearchService.lookupUser('john_doe');

    lookupResult.when(
      success: (user) {
        debugPrint('✅ [Lookup] Found user: ${user.displayName}');
        // debugPrint('   - Email: ${user.email}');
        // debugPrint('   - Bio: ${user.bio ?? "No bio"}');
        // debugPrint('   - Friendship Status: ${user.friendshipStatus.description}');
        debugPrint('   - Mutual Friends: ${user.mutualFriendsCount}');
        debugPrint('   - Interest Tags: ${user.interestTags.join(", ")}');
      },
      failure: (error) {
        debugPrint('❌ [Lookup] Error: ${error.message}');
        if (error.statusCode == 404) {
          debugPrint('   User not found with identifier: john_doe');
        }
      },
    );
  }

  /// Demonstrates user suggestions functionality
  Future<void> demonstrateUserSuggestions() async {
    debugPrint('🧪 [FriendSearchExample] Testing user suggestions functionality...');

    final suggestionsResult = await _friendSearchService.getUserSuggestions(
      limit: 5,
    );

    suggestionsResult.when(
      success: (suggestions) {
        debugPrint('✅ [Suggestions] Got ${suggestions.length} suggested users');
        for (final user in suggestions) {
          debugPrint('   - ${user.displayName} (@${user.username})');
          debugPrint('     Mutual friends: ${user.mutualFriendsCount}');
          debugPrint('     Status: ${user.friendshipStatus.description}');
        }
      },
      failure: (error) {
        debugPrint('❌ [Suggestions] Error: ${error.message}');
      },
    );
  }

  /// Demonstrates friend request sending functionality
  Future<void> demonstrateSendFriendRequest() async {
    debugPrint('🧪 [FriendSearchExample] Testing send friend request functionality...');

    final friendRequestResult = await _friendSearchService.sendFriendRequest(
      targetUsername: 'jane_smith',
      message: 'Hi Jane! I found your profile through mutual friends and would love to connect on Future Talk. Looking forward to chatting!',
    );

    friendRequestResult.when(
      success: (response) {
        debugPrint('✅ [Friend Request] ${response.message}');
        if (response.friendshipId != null) {
          debugPrint('   Friendship ID: ${response.friendshipId}');
        }
        if (response.friendRequest != null) {
          debugPrint('   Request ID: ${response.friendRequest!.id}');
          debugPrint('   Status: ${response.friendRequest!.status.description}');
        }
      },
      failure: (error) {
        debugPrint('❌ [Friend Request] Error: ${error.message}');
        switch (error.statusCode) {
          case 404:
            debugPrint('   User "jane_smith" not found');
            break;
          case 400:
            debugPrint('   Cannot send request (already friends/blocked/pending)');
            break;
          case 429:
            debugPrint('   Rate limit exceeded - too many requests');
            break;
        }
      },
    );
  }

  /// Demonstrates friend request management (accept/reject/cancel)
  Future<void> demonstrateFriendRequestManagement() async {
    debugPrint('🧪 [FriendSearchExample] Testing friend request management...');

    // Example request ID (in real usage, get this from friend request lists)
    const requestId = 'request_123456';

    // Example 1: Accept friend request
    final acceptResult = await _friendSearchService.acceptFriendRequest(requestId);
    acceptResult.when(
      success: (response) {
        debugPrint('✅ [Accept] Friend request accepted: ${response.message}');
      },
      failure: (error) {
        debugPrint('❌ [Accept] Error: ${error.message}');
      },
    );

    // Example 2: Reject friend request
    final rejectResult = await _friendSearchService.rejectFriendRequest(requestId);
    rejectResult.when(
      success: (response) {
        debugPrint('✅ [Reject] Friend request rejected: ${response.message}');
      },
      failure: (error) {
        debugPrint('❌ [Reject] Error: ${error.message}');
      },
    );

    // Example 3: Cancel sent friend request
    final cancelResult = await _friendSearchService.cancelFriendRequest(requestId);
    cancelResult.when(
      success: (response) {
        debugPrint('✅ [Cancel] Friend request cancelled: ${response.message}');
      },
      failure: (error) {
        debugPrint('❌ [Cancel] Error: ${error.message}');
      },
    );
  }

  /// Demonstrates user blocking/unblocking functionality
  Future<void> demonstrateUserBlocking() async {
    debugPrint('🧪 [FriendSearchExample] Testing user blocking functionality...');

    // Example user ID (in real usage, get this from user lookup/search)
    const userId = 'user_789012';

    // Example 1: Block user
    final blockResult = await _friendSearchService.blockUser(userId);
    blockResult.when(
      success: (response) {
        debugPrint('✅ [Block] User blocked: ${response.message}');
      },
      failure: (error) {
        debugPrint('❌ [Block] Error: ${error.message}');
        if (error.statusCode == 400) {
          debugPrint('   Cannot block user (may be trying to block self)');
        }
      },
    );

    // Example 2: Unblock user
    final unblockResult = await _friendSearchService.unblockUser(userId);
    unblockResult.when(
      success: (response) {
        debugPrint('✅ [Unblock] User unblocked: ${response.message}');
      },
      failure: (error) {
        debugPrint('❌ [Unblock] Error: ${error.message}');
        if (error.statusCode == 404) {
          debugPrint('   User not found or not currently blocked');
        }
      },
    );
  }

  /// Demonstrates handling of different friendship statuses
  Future<void> demonstrateFriendshipStatusHandling() async {
    debugPrint('🧪 [FriendSearchExample] Testing friendship status handling...');

    // Simulate different users with different statuses
    final testUsers = [
      UserSearchResult(
        id: 'user_1',
        username: 'alice_wonder',
        firstName: 'Alice',
        lastName: 'Wonder',
        friendshipStatus: FriendshipStatus.none,
        socialBattery: 85,
      ),
      UserSearchResult(
        id: 'user_2',
        username: 'bob_builder',
        firstName: 'Bob',
        lastName: 'Builder',
        friendshipStatus: FriendshipStatus.pending,
        socialBattery: 60,
      ),
      UserSearchResult(
        id: 'user_3',
        username: 'carol_singer',
        firstName: 'Carol',
        lastName: 'Singer',
        friendshipStatus: FriendshipStatus.accepted,
        socialBattery: 40,
        mutualFriendsCount: 5,
      ),
      UserSearchResult(
        id: 'user_4',
        username: 'dave_blocked',
        firstName: 'Dave',
        lastName: 'Blocked',
        friendshipStatus: FriendshipStatus.blocked,
        socialBattery: 90,
      ),
    ];

    for (final user in testUsers) {
      debugPrint('👤 [User] ${user.displayName} (@${user.username})');
      debugPrint('   Status: ${user.friendshipStatus.description}');
      debugPrint('   Action: ${user.friendshipStatus.actionLabel}');
      debugPrint('   Can Send Request: ${user.friendshipStatus.canSendRequest}');
      debugPrint('   Can Accept Request: ${user.friendshipStatus.canAcceptRequest}');
      debugPrint('   Is Friend: ${user.friendshipStatus.isFriend}');
      debugPrint('   Is Blocked: ${user.friendshipStatus.isBlocked}');
      debugPrint('   Social Battery: ${user.socialBattery}% (${user.socialBatteryColor})');
      debugPrint('   Mutual Friends: ${user.mutualFriendsCount}');
      debugPrint('   Initials: ${user.initials}');
      debugPrint('');
    }
  }

  /// Runs all example demonstrations
  Future<void> runAllExamples() async {
    debugPrint('🚀 [FriendSearchExample] Running all friend search examples...\n');

    try {
      await demonstrateUserSearch();
      debugPrint('');

      await demonstrateUserLookup();
      debugPrint('');

      await demonstrateUserSuggestions();
      debugPrint('');

      await demonstrateSendFriendRequest();
      debugPrint('');

      await demonstrateFriendRequestManagement();
      debugPrint('');

      await demonstrateUserBlocking();
      debugPrint('');

      await demonstrateFriendshipStatusHandling();
      debugPrint('');

      debugPrint('✅ [FriendSearchExample] All examples completed successfully!');
    } catch (e) {
      debugPrint('❌ [FriendSearchExample] Error running examples: $e');
    }
  }

  /// Validates input parameters for common operations
  void demonstrateInputValidation() {
    debugPrint('🧪 [FriendSearchExample] Testing input validation...');

    // Test search query validation
    final shortQuerySearch = _friendSearchService.searchUsers(query: 'a');
    shortQuerySearch.then((result) {
      result.when(
        success: (_) => debugPrint('❌ [Validation] Short query should fail'),
        failure: (error) => debugPrint('✅ [Validation] Short query rejected: ${error.message}'),
      );
    });

    // Test limit validation
    final invalidLimitSearch = _friendSearchService.searchUsers(query: 'test', limit: 100);
    invalidLimitSearch.then((result) {
      result.when(
        success: (_) => debugPrint('❌ [Validation] Invalid limit should fail'),
        failure: (error) => debugPrint('✅ [Validation] Invalid limit rejected: ${error.message}'),
      );
    });

    // Test message length validation
    final longMessageRequest = _friendSearchService.sendFriendRequest(
      targetUsername: 'test_user',
      message: 'A' * 300, // 300 characters - exceeds 280 limit
    );
    longMessageRequest.then((result) {
      result.when(
        success: (_) => debugPrint('❌ [Validation] Long message should fail'),
        failure: (error) => debugPrint('✅ [Validation] Long message rejected: ${error.message}'),
      );
    });

    debugPrint('✅ [Validation] All input validation tests completed');
  }
}

/// Usage examples for integrating with UI components
class FriendSearchUIExamples {
  final FriendSearchService _friendSearchService = FriendSearchService();

  /// Example: Building a search results list
  Future<List<UserSearchResult>> buildSearchResultsList(String query) async {
    final result = await _friendSearchService.searchUsers(
      query: query,
      searchType: SearchType.all,
      limit: 20,
    );

    return result.when(
      success: (users) => users,
      failure: (error) {
        debugPrint('Search failed: ${error.message}');
        return <UserSearchResult>[];
      },
    );
  }

  /// Example: Handling friend request actions
  Future<bool> handleFriendRequest({
    required String action, // 'send', 'accept', 'reject', 'cancel'
    required String identifier, // username for send, requestId for others
    String? message,
  }) async {
    switch (action.toLowerCase()) {
      case 'send':
        final result = await _friendSearchService.sendFriendRequest(
          targetUsername: identifier,
          message: message,
        );
        return result.when(
          success: (_) => true,
          failure: (error) {
            debugPrint('Send request failed: ${error.message}');
            return false;
          },
        );

      case 'accept':
        final result = await _friendSearchService.acceptFriendRequest(identifier);
        return result.when(
          success: (_) => true,
          failure: (error) {
            debugPrint('Accept request failed: ${error.message}');
            return false;
          },
        );

      case 'reject':
        final result = await _friendSearchService.rejectFriendRequest(identifier);
        return result.when(
          success: (_) => true,
          failure: (error) {
            debugPrint('Reject request failed: ${error.message}');
            return false;
          },
        );

      case 'cancel':
        final result = await _friendSearchService.cancelFriendRequest(identifier);
        return result.when(
          success: (_) => true,
          failure: (error) {
            debugPrint('Cancel request failed: ${error.message}');
            return false;
          },
        );

      default:
        debugPrint('Invalid action: $action');
        return false;
    }
  }

  /// Example: Getting personalized suggestions
  Future<List<UserSearchResult>> getPersonalizedSuggestions() async {
    final result = await _friendSearchService.getUserSuggestions(limit: 10);

    return result.when(
      success: (suggestions) => suggestions,
      failure: (error) {
        debugPrint('Failed to get suggestions: ${error.message}');
        return <UserSearchResult>[];
      },
    );
  }

  /// Example: User profile lookup with error handling
  Future<UserLookupResult?> safeUserLookup(String identifier) async {
    final result = await _friendSearchService.lookupUser(identifier);

    return result.when(
      success: (user) => user,
      failure: (error) {
        if (error.statusCode == 404) {
          debugPrint('User not found: $identifier');
        } else {
          debugPrint('Lookup failed: ${error.message}');
        }
        return null;
      },
    );
  }
}