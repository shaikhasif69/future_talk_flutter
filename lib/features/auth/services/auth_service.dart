import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:future_talk_frontend/core/network/api_client.dart';
import 'package:future_talk_frontend/core/network/api_endpoints.dart';
import 'package:future_talk_frontend/core/network/api_result.dart';
import 'package:future_talk_frontend/core/storage/secure_storage_service.dart';
import 'package:future_talk_frontend/features/auth/models/auth_models.dart';
import '../../../features/chat/providers/realtime_chat_provider.dart';
import '../../../features/chat/services/pinned_conversations_service.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResult<AuthResponse>> login(LoginRequest request) async {
    try {
      print('🔌 [AuthService] Sending login request...');
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      print('🔌 [AuthService] Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('🔌 [AuthService] Parsing response data...');
        print('🔌 [AuthService] Raw response: ${response.data}');
        
        try {
          final authResponse = AuthResponse.fromJson(response.data);
          print('🔌 [AuthService] Successfully parsed AuthResponse');
          print('🔌 [AuthService] User: ${authResponse.user.username}');
          
          await SecureStorageService.saveTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );
          
          await SecureStorageService.saveUserId(authResponse.user.id);
          print('🔌 [AuthService] Tokens saved successfully');
          print('🔌 [AuthService] AccessToken saved length: ${authResponse.accessToken.length}');
          print('🔌 [AuthService] RefreshToken saved length: ${authResponse.refreshToken.length}');

          return ApiResult.success(authResponse);
        } catch (parseError) {
          print('🔌 [AuthService] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse server response: $parseError',
            statusCode: response.statusCode ?? -1,
          ));
        }
      } else {
        print('🔌 [AuthService] Non-200 response: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      print('🔌 [AuthService] Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      print('🔌 [AuthService] Unknown error: $e');
      return ApiResult.failure(ApiError(
        message: 'Unknown error occurred: $e',
        statusCode: -1,
      ));
    }
  }

  Future<ApiResult<RegisterResponse>> register(RegisterRequest request) async {
    try {
      print('🔌 [AuthService] Sending registration request...');
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      print('🔌 [AuthService] Registration response status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('🔌 [AuthService] Registration successful, OTP sent');
        final registerResponse = RegisterResponse.fromJson(response.data);
        return ApiResult.success(registerResponse);
      } else {
        print('🔌 [AuthService] Registration failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      print('🔌 [AuthService] Registration Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      print('🔌 [AuthService] Registration unknown error: $e');
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<ApiResult<AuthResponse>> verifyOtp(OtpVerificationRequest request) async {
    try {
      print('🔌 [AuthService] Sending OTP verification request...');
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: request.toJson(),
      );

      print('🔌 [AuthService] OTP verification response status: ${response.statusCode}');
      if (response.statusCode == 201) {
        print('🔌 [AuthService] OTP verification successful');
        final authResponse = AuthResponse.fromJson(response.data);
        
        await SecureStorageService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );
        
        await SecureStorageService.saveUserId(authResponse.user.id);
        
        print('🔌 [AuthService] User authenticated successfully');
        return ApiResult.success(authResponse);
      } else {
        print('🔌 [AuthService] OTP verification failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      print('🔌 [AuthService] OTP verification Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      print('🔌 [AuthService] OTP verification unknown error: $e');
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<ApiResult<ResendOtpResponse>> resendOtp(ResendOtpRequest request) async {
    try {
      print('🔌 [AuthService] Sending resend OTP request...');
      final response = await _apiClient.post(
        ApiEndpoints.resendOtp,
        data: request.toJson(),
      );

      print('🔌 [AuthService] Resend OTP response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('🔌 [AuthService] OTP resent successfully');
        final resendResponse = ResendOtpResponse.fromJson(response.data);
        return ApiResult.success(resendResponse);
      } else {
        print('🔌 [AuthService] Resend OTP failed: ${response.statusCode}');
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      print('🔌 [AuthService] Resend OTP Dio exception: $e');
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      print('🔌 [AuthService] Resend OTP unknown error: $e');
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<ApiResult<AuthResponse>> refreshToken() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();
      if (refreshToken == null) {
        return ApiResult.failure(ApiError.unauthorized());
      }

      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _apiClient.post(
        ApiEndpoints.refresh,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        
        await SecureStorageService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );
        
        // Save user ID when refreshing tokens
        await SecureStorageService.saveUserId(authResponse.user.id);
        
        return ApiResult.success(authResponse);
      } else {
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
      await _clearAllUserData();
      return const ApiResult.success(null);
    } on DioException catch (e) {
      await _clearAllUserData();
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      await _clearAllUserData();
      return ApiResult.failure(ApiError.unknown());
    }
  }

  /// Clear all user data during logout to prevent cache issues
  Future<void> _clearAllUserData() async {
    // Clear secure storage (tokens, user ID, etc.)
    await SecureStorageService.clearTokens();
    
    // Clear chat-related data
    await _clearChatData();
    
    // Clear any other cached data
    debugPrint('🧹 [AuthService] All user data cleared during logout');
  }

  /// Clear all chat-related data and disconnect WebSocket
  Future<void> _clearChatData() async {
    try {
      debugPrint('🧹 [AuthService] Clearing chat data...');
      
      // Clear RealtimeChatProvider data and disconnect WebSocket
      try {
        await realtimeChatProvider.disconnect();
        debugPrint('🧹 [AuthService] Chat provider disconnected');
      } catch (e) {
        debugPrint('⚠️ [AuthService] Error disconnecting chat provider: $e');
      }
      
      // Clear local storage for UI preferences (pinned chats, etc.)
      try {
        await PinnedConversationsService.clearAllData();
        debugPrint('🧹 [AuthService] Pinned conversations cleared');
      } catch (e) {
        debugPrint('⚠️ [AuthService] Error clearing pinned conversations: $e');
      }
      
      debugPrint('✅ [AuthService] Chat data cleared successfully');
      
    } catch (e) {
      debugPrint('⚠️ [AuthService] Error clearing chat data: $e');
    }
  }

  Future<ApiResult<void>> requestPasswordReset(PasswordResetRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.passwordReset,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return const ApiResult.success(null);
      } else {
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<ApiResult<void>> confirmPasswordReset(PasswordResetConfirmRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.passwordResetConfirm,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return const ApiResult.success(null);
      } else {
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<ApiResult<AuthUser>> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);

      if (response.statusCode == 200) {
        // The API returns {"user": {...}, "social_battery": {...}, "privacy_settings": {...}}
        // We need to extract the user object and add privacy_settings to it
        final responseData = response.data as Map<String, dynamic>;
        final userData = responseData['user'] as Map<String, dynamic>;
        final privacyData = responseData['privacy_settings'] as Map<String, dynamic>?;
        
        // Add privacy settings to user data if available
        if (privacyData != null) {
          userData['privacySettings'] = privacyData;
        }
        
        final user = AuthUser.fromJson(userData);
        return ApiResult.success(user);
      } else {
        return ApiResult.failure(_parseError(response));
      }
    } on DioException catch (e) {
      return ApiResult.failure(_handleDioError(e));
    } catch (e) {
      print('🔐 [AuthService] getCurrentUser parsing error: $e');
      return ApiResult.failure(ApiError.unknown());
    }
  }

  Future<bool> isLoggedIn() async {
    return await SecureStorageService.isLoggedIn();
  }

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