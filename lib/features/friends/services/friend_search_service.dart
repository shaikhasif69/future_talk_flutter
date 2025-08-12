import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_result.dart';
import '../models/friend_search_models.dart';

/// Service for handling friend search and management operations
/// 
/// This service provides comprehensive friend management functionality:
/// - Search users by partial match (username, email, name)
/// - Lookup users by exact identifier (username or email)
/// - Get user suggestions based on mutual connections
/// - Send, accept, reject, and cancel friend requests
/// - Block and unblock users
/// - Manage friendship relationships
/// 
/// All methods return ApiResult&lt;T&gt; for consistent error handling
/// and follow Future Talk's API patterns and conventions.
class FriendSearchService {
  final ApiClient _apiClient = ApiClient();

  /// Search users with partial matching
  /// 
  /// Searches for users based on a query string with optional filtering.
  /// Results include friendship status for each user.
  /// 
  /// Parameters:
  /// - [query]: Search term (minimum 2 characters)
  /// - [searchType]: Type of search (all, username, email, name)
  /// - [limit]: Maximum number of results (default: 20, max: 50)
  /// 
  /// Returns:
  /// - Success: List of UserSearchResult with friendship status
  /// - Failure: ApiError with details
  /// 
  /// Example:
  /// ```dart
  /// final result = await friendSearchService.searchUsers(
  ///   query: 'john',
  ///   searchType: SearchType.username,
  ///   limit: 10,
  /// );
  /// 
  /// result.when(
  ///   success: (users) => print('Found ${users.length} users'),
  ///   failure: (error) => print('Search failed: ${error.message}'),
  /// );
  /// ```
  Future<ApiResult<List<UserSearchResult>>> searchUsers({
    required String query,
    SearchType searchType = SearchType.all,
    int limit = 20,
  }) async {
    try {
      debugPrint('🔍 [FriendSearchService] Searching users with query: $query');
      
      // Validate query length
      if (query.length < 2) {
        return ApiResult.failure(ApiError(
          message: 'Search query must be at least 2 characters',
          statusCode: 400,
        ));
      }
      
      // Validate limit
      if (limit <= 0 || limit > 50) {
        return ApiResult.failure(ApiError(
          message: 'Limit must be between 1 and 50',
          statusCode: 400,
        ));
      }

      final queryParameters = {
        'q': query,
        'limit': limit.toString(),
      };
      
      // Add search type if not 'all'
      if (searchType != SearchType.all) {
        queryParameters['search_type'] = searchType.name;
      }

      final response = await _apiClient.get(
        ApiEndpoints.searchUsers,
        queryParameters: queryParameters,
      );

      debugPrint('🔍 [FriendSearchService] Search response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] Search successful');
        
        try {
          final List<dynamic> usersData = response.data as List<dynamic>;
          final users = usersData
              .map((userData) => UserSearchResult.fromJson(userData as Map<String, dynamic>))
              .toList();
          
          debugPrint('🔍 [FriendSearchService] Parsed ${users.length} user results');
          return ApiResult.success(users);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse search results: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Search failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Lookup a user by exact identifier
  /// 
  /// Finds a user by exact username or email match.
  /// Returns detailed user information with friendship status.
  /// 
  /// Parameters:
  /// - [identifier]: Exact username or email
  /// 
  /// Returns:
  /// - Success: UserLookupResult with friendship status
  /// - Failure: ApiError (404 if user not found)
  /// 
  /// Example:
  /// ```dart
  /// final result = await friendSearchService.lookupUser('john_doe');
  /// 
  /// result.when(
  ///   success: (user) => print('Found user: ${user.displayName}'),
  ///   failure: (error) => print('User not found: ${error.message}'),
  /// );
  /// ```
  Future<ApiResult<UserLookupResult>> lookupUser(String identifier) async {
    try {
      debugPrint('🔍 [FriendSearchService] Looking up user: $identifier');
      
      // Validate identifier
      if (identifier.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'Identifier cannot be empty',
          statusCode: 400,
        ));
      }

      final requestData = UserLookupRequest(identifier: identifier.trim());
      
      final response = await _apiClient.post(
        ApiEndpoints.userLookup,
        data: requestData.toJson(),
      );

      debugPrint('🔍 [FriendSearchService] Lookup response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] User found successfully');
        
        try {
          final responseData = response.data as Map<String, dynamic>;
          final userData = responseData['user'] as Map<String, dynamic>;
          
          // Handle null friendship_status
          if (userData['friendship_status'] == null) {
            userData['friendship_status'] = 'none';
          }
          
          final user = UserLookupResult.fromJson(userData);
          debugPrint('🔍 [FriendSearchService] Parsed user: ${user.username}');
          return ApiResult.success(user);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          debugPrint('🔍 [FriendSearchService] Response data: ${response.data}');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse user data: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] User lookup failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Get user suggestions
  /// 
  /// Retrieves suggested users based on mutual connections,
  /// interests, and other recommendation algorithms.
  /// All suggestions include friendship status.
  /// 
  /// Parameters:
  /// - [limit]: Maximum number of suggestions (default: 10, max: 20)
  /// 
  /// Returns:
  /// - Success: List of UserSearchResult suggestions
  /// - Failure: ApiError with details
  /// 
  /// Example:
  /// ```dart
  /// final result = await friendSearchService.getUserSuggestions(limit: 5);
  /// 
  /// result.when(
  ///   success: (suggestions) => print('Got ${suggestions.length} suggestions'),
  ///   failure: (error) => print('Failed to get suggestions: ${error.message}'),
  /// );
  /// ```
  Future<ApiResult<List<UserSearchResult>>> getUserSuggestions({
    int limit = 10,
  }) async {
    try {
      debugPrint('🔍 [FriendSearchService] Getting user suggestions');
      
      // Validate limit
      if (limit <= 0 || limit > 20) {
        return ApiResult.failure(ApiError(
          message: 'Limit must be between 1 and 20',
          statusCode: 400,
        ));
      }

      final queryParameters = {
        'limit': limit.toString(),
      };

      final response = await _apiClient.get(
        ApiEndpoints.userSuggestions,
        queryParameters: queryParameters,
      );

      debugPrint('🔍 [FriendSearchService] Suggestions response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] Suggestions retrieved successfully');
        
        try {
          final List<dynamic> suggestionsData = response.data as List<dynamic>;
          final suggestions = suggestionsData
              .map((userData) => UserSearchResult.fromJson(userData as Map<String, dynamic>))
              .toList();
          
          debugPrint('🔍 [FriendSearchService] Parsed ${suggestions.length} suggestions');
          return ApiResult.success(suggestions);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse suggestions: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Suggestions failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Send a friend request
  /// 
  /// Sends a friend request to a user by their username.
  /// Optionally includes a personal message with the request.
  /// 
  /// Parameters:
  /// - [targetUsername]: Username of the user to send request to
  /// - [message]: Optional personal message (max 280 characters)
  /// 
  /// Returns:
  /// - Success: FriendRequestResponse with friendship ID
  /// - Failure: ApiError (404 if user not found, 400 if already friends/blocked)
  /// 
  /// Example:
  /// ```dart
  /// final result = await friendSearchService.sendFriendRequest(
  ///   targetUsername: 'john_doe',
  ///   message: 'Hi John! Would love to connect on Future Talk',
  /// );
  /// 
  /// result.when(
  ///   success: (response) => print('Request sent: ${response.message}'),
  ///   failure: (error) => print('Failed to send request: ${error.message}'),
  /// );
  /// ```
  Future<ApiResult<FriendRequestResponse>> sendFriendRequest({
    required String targetUsername,
    String? message,
  }) async {
    try {
      debugPrint('🔍 [FriendSearchService] Sending friend request to: $targetUsername');
      
      // Validate target username
      if (targetUsername.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'Target username cannot be empty',
          statusCode: 400,
        ));
      }
      
      // Validate message length
      if (message != null && message.length > 280) {
        return ApiResult.failure(ApiError(
          message: 'Message must be 280 characters or less',
          statusCode: 400,
        ));
      }

      final requestData = SendFriendRequestData(
        targetUsername: targetUsername.trim(),
        message: message?.trim(),
      );
      
      final response = await _apiClient.post(
        ApiEndpoints.friendRequests,
        data: requestData.toJson(),
      );

      debugPrint('🔍 [FriendSearchService] Friend request response status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('🔍 [FriendSearchService] Friend request sent successfully');
        
        try {
          final friendRequestResponse = FriendRequestResponse.fromJson(
            response.data as Map<String, dynamic>
          );
          debugPrint('🔍 [FriendSearchService] Friend request ID: ${friendRequestResponse.friendshipId}');
          return ApiResult.success(friendRequestResponse);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Friend request failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Accept a friend request
  /// 
  /// Accepts a pending friend request by its ID.
  /// Creates a mutual friendship between both users.
  /// 
  /// Parameters:
  /// - [requestId]: ID of the friend request to accept
  /// 
  /// Returns:
  /// - Success: FriendRequestResponse confirming acceptance
  /// - Failure: ApiError (404 if request not found, 400 if not pending)
  Future<ApiResult<FriendRequestResponse>> acceptFriendRequest(String requestId) async {
    try {
      debugPrint('🔍 [FriendSearchService] Accepting friend request: $requestId');
      
      if (requestId.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'Request ID cannot be empty',
          statusCode: 400,
        ));
      }
      
      final response = await _apiClient.post(
        ApiEndpoints.acceptFriendRequestById(requestId.trim()),
      );

      debugPrint('🔍 [FriendSearchService] Accept response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] Friend request accepted successfully');
        
        try {
          final friendRequestResponse = FriendRequestResponse.fromJson(
            response.data as Map<String, dynamic>
          );
          return ApiResult.success(friendRequestResponse);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Accept request failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Reject a friend request
  /// 
  /// Rejects a pending friend request by its ID.
  /// The request will be marked as rejected and removed from pending list.
  /// 
  /// Parameters:
  /// - [requestId]: ID of the friend request to reject
  /// 
  /// Returns:
  /// - Success: FriendRequestResponse confirming rejection
  /// - Failure: ApiError (404 if request not found, 400 if not pending)
  Future<ApiResult<FriendRequestResponse>> rejectFriendRequest(String requestId) async {
    try {
      debugPrint('🔍 [FriendSearchService] Rejecting friend request: $requestId');
      
      if (requestId.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'Request ID cannot be empty',
          statusCode: 400,
        ));
      }
      
      final response = await _apiClient.post(
        ApiEndpoints.rejectFriendRequestById(requestId.trim()),
      );

      debugPrint('🔍 [FriendSearchService] Reject response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] Friend request rejected successfully');
        
        try {
          final friendRequestResponse = FriendRequestResponse.fromJson(
            response.data as Map<String, dynamic>
          );
          return ApiResult.success(friendRequestResponse);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Reject request failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Cancel a sent friend request
  /// 
  /// Cancels a friend request that was previously sent.
  /// Only the sender can cancel their own requests.
  /// 
  /// Parameters:
  /// - [requestId]: ID of the friend request to cancel
  /// 
  /// Returns:
  /// - Success: FriendRequestResponse confirming cancellation
  /// - Failure: ApiError (404 if request not found, 403 if not sender)
  Future<ApiResult<FriendRequestResponse>> cancelFriendRequest(String requestId) async {
    try {
      debugPrint('🔍 [FriendSearchService] Cancelling friend request: $requestId');
      
      if (requestId.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'Request ID cannot be empty',
          statusCode: 400,
        ));
      }
      
      final response = await _apiClient.post(
        ApiEndpoints.cancelFriendRequestById(requestId.trim()),
      );

      debugPrint('🔍 [FriendSearchService] Cancel response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] Friend request cancelled successfully');
        
        try {
          final friendRequestResponse = FriendRequestResponse.fromJson(
            response.data as Map<String, dynamic>
          );
          return ApiResult.success(friendRequestResponse);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Cancel request failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Block a user
  /// 
  /// Blocks a user to prevent them from sending messages or friend requests.
  /// If there's an existing friendship, it will be ended.
  /// 
  /// Parameters:
  /// - [userId]: ID of the user to block
  /// 
  /// Returns:
  /// - Success: FriendRequestResponse confirming block
  /// - Failure: ApiError (404 if user not found, 400 if trying to block self)
  Future<ApiResult<FriendRequestResponse>> blockUser(String userId) async {
    try {
      debugPrint('🔍 [FriendSearchService] Blocking user: $userId');
      
      if (userId.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'User ID cannot be empty',
          statusCode: 400,
        ));
      }
      
      final response = await _apiClient.post(
        ApiEndpoints.blockUserById(userId.trim()),
      );

      debugPrint('🔍 [FriendSearchService] Block response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] User blocked successfully');
        
        try {
          final friendRequestResponse = FriendRequestResponse.fromJson(
            response.data as Map<String, dynamic>
          );
          return ApiResult.success(friendRequestResponse);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Block user failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Unblock a user
  /// 
  /// Removes a user from the blocked list, allowing them to send
  /// messages and friend requests again.
  /// 
  /// Parameters:
  /// - [userId]: ID of the user to unblock
  /// 
  /// Returns:
  /// - Success: FriendRequestResponse confirming unblock
  /// - Failure: ApiError (404 if user not found or not blocked)
  Future<ApiResult<FriendRequestResponse>> unblockUser(String userId) async {
    try {
      debugPrint('🔍 [FriendSearchService] Unblocking user: $userId');
      
      if (userId.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'User ID cannot be empty',
          statusCode: 400,
        ));
      }
      
      final response = await _apiClient.post(
        ApiEndpoints.unblockUserById(userId.trim()),
      );

      debugPrint('🔍 [FriendSearchService] Unblock response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('🔍 [FriendSearchService] User unblocked successfully');
        
        try {
          final friendRequestResponse = FriendRequestResponse.fromJson(
            response.data as Map<String, dynamic>
          );
          return ApiResult.success(friendRequestResponse);
        } catch (parseError) {
          debugPrint('🔍 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('🔍 [FriendSearchService] Unblock user failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('🔍 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('🔍 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Get the current user's friends list
  /// 
  /// Retrieves all friends of the current user with their current status.
  /// Results include online status, social battery, and other friend details.
  /// 
  /// Parameters:
  /// - [limit]: Maximum number of friends to return (optional)
  /// - [offset]: Number of friends to skip (for pagination)
  /// 
  /// Returns:
  /// - Success: List of UserSearchResult representing friends
  /// - Failure: ApiError with details
  Future<ApiResult<List<UserSearchResult>>> getFriends({
    int? limit,
    int? offset,
  }) async {
    try {
      debugPrint('👥 [FriendSearchService] Getting friends list');
      
      final queryParameters = <String, String>{};
      if (limit != null) queryParameters['limit'] = limit.toString();
      if (offset != null) queryParameters['offset'] = offset.toString();

      final response = await _apiClient.get(
        ApiEndpoints.friendsList,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      debugPrint('👥 [FriendSearchService] Friends list response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('👥 [FriendSearchService] Friends list retrieved successfully');
        
        try {
          final List<dynamic> friendsData = response.data as List<dynamic>;
          // Convert friend data to UserSearchResult format
          final friends = friendsData
              .map((friendData) => _convertFriendToUserSearchResult(friendData as Map<String, dynamic>))
              .toList();
          
          debugPrint('👥 [FriendSearchService] Parsed ${friends.length} friends');
          return ApiResult.success(friends);
        } catch (parseError) {
          debugPrint('👥 [FriendSearchService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse friends data: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('👥 [FriendSearchService] Friends list failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('👥 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('👥 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  /// Convert friend API response to UserSearchResult format
  UserSearchResult _convertFriendToUserSearchResult(Map<String, dynamic> friendData) {
    // Split display name into firstName and lastName if possible
    final displayName = friendData['friend_display_name'] as String? ?? '';
    final nameParts = displayName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : null;
    final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : null;
    
    return UserSearchResult(
      id: friendData['friend_user_id'] as String,
      username: friendData['friend_username'] as String,
      email: null, // Not provided in friends response
      firstName: firstName,
      lastName: lastName,
      profilePictureUrl: friendData['friend_profile_picture'] as String?,
      bio: null, // Not provided in friends response
      socialBattery: friendData['friend_social_battery'] as int? ?? 75,
      friendshipStatus: FriendshipStatus.accepted, // Already friends
      isOnline: false, // Not provided in friends response
      lastSeen: DateTime.tryParse(friendData['created_at'] as String? ?? ''),
      interestTags: const [], // Not provided in friends response
      mutualFriendsCount: friendData['mutual_friends_count'] as int? ?? 0,
    );
  }

  /// Get pending friend requests
  /// 
  /// Retrieves all pending friend requests for the current user.
  /// This includes requests they have received that need response.
  /// 
  /// Parameters:
  /// - [limit]: Maximum number of requests to return (optional)
  /// - [offset]: Number of requests to skip (for pagination)
  /// 
  /// Returns:
  /// - Success: List of FriendRequest objects
  /// - Failure: ApiError with details
  Future<ApiResult<List<FriendRequest>>> getFriendRequests({
    int? limit,
    int? offset,
  }) async {
    try {
      debugPrint('📬 [FriendSearchService] Getting friend requests list');
      
      final queryParameters = <String, String>{};
      if (limit != null) queryParameters['limit'] = limit.toString();
      if (offset != null) queryParameters['offset'] = offset.toString();

      final response = await _apiClient.get(
        ApiEndpoints.friendRequestsList,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      debugPrint('📬 [FriendSearchService] Friend requests response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('📬 [FriendSearchService] Friend requests retrieved successfully');
        
        try {
          // Handle the response structure - it might have 'received' and 'sent' arrays
          final responseData = response.data as Map<String, dynamic>;
          
          // Extract received requests (ones the user needs to respond to)
          final List<dynamic> receivedData = responseData['received'] as List<dynamic>? ?? [];
          
          final requests = receivedData
              .map((requestData) => FriendRequest.fromJson(requestData as Map<String, dynamic>))
              .toList();
          
          debugPrint('📬 [FriendSearchService] Parsed ${requests.length} friend requests');
          return ApiResult.success(requests);
        } catch (parseError) {
          debugPrint('📬 [FriendSearchService] JSON parsing error: $parseError');
          debugPrint('📬 [FriendSearchService] Response data: ${response.data}');
          
          // If parsing fails, return empty list with warning
          debugPrint('📬 [FriendSearchService] Returning empty list due to parsing issues');
          return ApiResult.success(<FriendRequest>[]);
        }
      } else {
        debugPrint('📬 [FriendSearchService] Friend requests failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('📬 [FriendSearchService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('📬 [FriendSearchService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  // Helper methods for error handling (following existing patterns)

  ApiError _parseError(Response response) {
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final message = data['message'] ?? 'An error occurred';
      final details = data['details'] as Map<String, dynamic>?;
      
      final errorDetails = details?.map((key, value) => 
        MapEntry(key, List<String>.from(value as List? ?? []))
      );

      return ApiError(
        message: message,
        statusCode: response.statusCode ?? -1,
        details: errorDetails,
      );
    }

    return ApiError(
      message: 'Server error occurred',
      statusCode: response.statusCode ?? -1,
    );
  }

  ApiError _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError.timeout();
      case DioExceptionType.connectionError:
        return ApiError.network();
      case DioExceptionType.badResponse:
        if (e.response != null) {
          return _parseError(e.response!);
        }
        return ApiError.serverError();
      case DioExceptionType.cancel:
        return const ApiError(
          message: 'Request was cancelled',
          statusCode: -1,
        );
      case DioExceptionType.unknown:
        return ApiError.unknown();
      default:
        return ApiError.unknown();
    }
  }
}