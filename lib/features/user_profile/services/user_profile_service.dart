import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_result.dart';
import '../models/user_profile_model.dart';

/// Service for handling user profile operations
/// 
/// This service provides user profile functionality:
/// - Get user profile by ID with privacy-aware data
/// - Handles friend vs non-friend data visibility
/// - Returns appropriate data based on friendship status
class UserProfileService {
  final ApiClient _apiClient = ApiClient();

  /// Get user profile by user ID
  /// 
  /// Fetches user profile data with privacy controls based on friendship status.
  /// Friends see full data, non-friends see limited public information.
  /// 
  /// Parameters:
  /// - [userId]: ID of the user to fetch profile for
  /// 
  /// Returns:
  /// - Success: UserProfileModel with appropriate data visibility
  /// - Failure: ApiError with details
  /// 
  /// Example:
  /// ```dart
  /// final result = await userProfileService.getUserProfile(userId);
  /// 
  /// result.when(
  ///   success: (profile) => print('Profile: ${profile.displayName}'),
  ///   failure: (error) => print('Failed: ${error.message}'),
  /// );
  /// ```
  Future<ApiResult<UserProfileModel>> getUserProfile(String userId) async {
    try {
      debugPrint('👤 [UserProfileService] Getting user profile: $userId');
      
      // Validate userId
      if (userId.trim().isEmpty) {
        return ApiResult.failure(ApiError(
          message: 'User ID cannot be empty',
          statusCode: 400,
        ));
      }

      final response = await _apiClient.get(
        ApiEndpoints.userProfileById(userId.trim()),
      );

      debugPrint('👤 [UserProfileService] Profile response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        debugPrint('👤 [UserProfileService] Profile retrieved successfully');
        
        try {
          final userData = response.data as Map<String, dynamic>;
          
          // Parse date strings if present
          if (userData['created_at'] != null && userData['created_at'] is String) {
            userData['created_at'] = DateTime.tryParse(userData['created_at'])?.toIso8601String();
          }
          if (userData['last_active'] != null && userData['last_active'] is String) {
            userData['last_active'] = DateTime.tryParse(userData['last_active'])?.toIso8601String();
          }
          
          final profile = UserProfileModel.fromJson(userData);
          debugPrint('👤 [UserProfileService] Parsed profile: ${profile.username}');
          debugPrint('👤 [UserProfileService] Friendship status: ${profile.friendshipStatus}');
          return ApiResult.success(profile);
        } catch (parseError) {
          debugPrint('👤 [UserProfileService] JSON parsing error: $parseError');
          debugPrint('👤 [UserProfileService] Response data: ${response.data}');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse profile data: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        debugPrint('👤 [UserProfileService] Profile failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      debugPrint('👤 [UserProfileService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      debugPrint('👤 [UserProfileService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  // Helper methods for error handling

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