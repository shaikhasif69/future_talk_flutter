import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:future_talk_frontend/core/storage/secure_storage_service.dart';
import 'package:future_talk_frontend/features/auth/models/auth_models.dart';
import 'package:future_talk_frontend/features/auth/services/auth_service.dart';
import 'package:future_talk_frontend/core/network/api_result.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    AuthUser? user,
    @Default(false) bool isLoading,
    @Default(false) bool isLoggedIn,
    @Default(false) bool isInitialized,
    String? errorMessage,
  }) = _AuthState;
}

@riverpod
class Auth extends _$Auth {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = AuthService();
    // Initialize auth state asynchronously 
    _initializeAuth();
    return const AuthState(isLoading: true);
  }

  Future<void> _initializeAuth() async {
    print('🔐 [Auth] Starting authentication initialization...');
    
    try {
      // Add minimum delay to ensure splash screen is visible
      final authCheckFuture = _performAuthCheck();
      final minSplashFuture = Future.delayed(const Duration(milliseconds: 1500)); // 1.5 seconds minimum
      
      // Wait for both auth check and minimum splash time
      await Future.wait([authCheckFuture, minSplashFuture]);
      
    } catch (e) {
      print('🔐 [Auth] Initialization error: $e');
      // Even on error, wait for minimum splash time
      await Future.delayed(const Duration(milliseconds: 1500));
      state = AuthState(
        isLoggedIn: false,
        isInitialized: true,
        isLoading: false,
        errorMessage: 'Failed to initialize authentication',
      );
    }
    
    print('🔐 [Auth] Initialization complete. State: ${state.isLoggedIn ? "Logged In" : "Not Logged In"}');
  }

  Future<void> _performAuthCheck() async {
    // Check if we have stored tokens
    final accessToken = await SecureStorageService.getAccessToken();
    final refreshToken = await SecureStorageService.getRefreshToken();
    final isLoggedInFlag = await SecureStorageService.isLoggedIn();
    
    print('🔐 [Auth] Token check: accessToken=${accessToken != null ? 'EXISTS' : 'NULL'}, refreshToken=${refreshToken != null ? 'EXISTS' : 'NULL'}, isLoggedInFlag=$isLoggedInFlag');
    print('🔐 [Auth] AccessToken length: ${accessToken?.length ?? 0}, RefreshToken length: ${refreshToken?.length ?? 0}');
    
    if (accessToken != null && refreshToken != null && isLoggedInFlag) {
      print('🔐 [Auth] Tokens found, user authenticated');
      
      state = AuthState(
        isLoggedIn: true,
        isInitialized: true,
        isLoading: false,
      );
      
      // Background validation: Fetch fresh user profile
      print('🔐 [Auth] Background: Validating user profile...');
      _validateUserInBackground();
    } else {
      print('🔐 [Auth] No valid tokens found, user not logged in');
      state = const AuthState(
        isLoggedIn: false,
        isInitialized: true,
        isLoading: false,
      );
    }
  }

  Future<ApiResult<AuthResponse>> login(String emailOrUsername, String password) async {
    print('🔐 [Auth] Starting login process...');
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = LoginRequest(
      emailOrUsername: emailOrUsername,
      password: password,
    );

    final result = await _authService.login(request);

    result.when(
      success: (authResponse) {
        print('🔐 [Auth] Login successful! User: ${authResponse.user.username}');
        state = AuthState(
          user: authResponse.user,
          isLoggedIn: true,
          isInitialized: true,
          isLoading: false,
        );
        print('🔐 [Auth] Auth state updated: isLoggedIn=${state.isLoggedIn}');
      },
      failure: (error) {
        print('🔐 [Auth] Login failed: ${error.message}');
        // IMPORTANT: Keep the user on the current screen, don't change login status
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
          // Explicitly maintain current auth state - don't change isLoggedIn
        );
      },
    );

    return result;
  }

  Future<ApiResult<RegisterResponse>> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = RegisterRequest(
      email: email,
      password: password,
      username: username,
      displayName: displayName,
    );

    final result = await _authService.register(request);

    result.when(
      success: (registerResponse) {
        state = state.copyWith(
          isLoading: false,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );

    return result;
  }

  Future<ApiResult<AuthResponse>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = OtpVerificationRequest(
      email: email,
      otp: otp,
    );

    final result = await _authService.verifyOtp(request);

    result.when(
      success: (authResponse) {
        print('🔐 [Auth] OTP verification successful! User: ${authResponse.user.username}');
        state = AuthState(
          user: authResponse.user,
          isLoggedIn: true,
          isInitialized: true,
          isLoading: false,
        );
        print('🔐 [Auth] Auth state updated after OTP: isLoggedIn=${state.isLoggedIn}');
      },
      failure: (error) {
        print('🔐 [Auth] OTP verification failed: ${error.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );

    return result;
  }

  Future<ApiResult<ResendOtpResponse>> resendOtp(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = ResendOtpRequest(email: email);
    final result = await _authService.resendOtp(request);

    result.when(
      success: (resendResponse) {
        state = state.copyWith(isLoading: false);
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );

    return result;
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _authService.logout();
    
    result.when(
      success: (_) {
        state = const AuthState(
          isLoggedIn: false,
          isInitialized: true,
          isLoading: false,
        );
      },
      failure: (error) {
        state = const AuthState(
          isLoggedIn: false,
          isInitialized: true,
          isLoading: false,
        );
      },
    );
  }

  Future<ApiResult<void>> requestPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = PasswordResetRequest(email: email);
    final result = await _authService.requestPasswordReset(request);

    result.when(
      success: (_) {
        state = state.copyWith(isLoading: false);
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );

    return result;
  }

  Future<ApiResult<void>> confirmPasswordReset(String token, String newPassword) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = PasswordResetConfirmRequest(
      token: token,
      newPassword: newPassword,
    );
    final result = await _authService.confirmPasswordReset(request);

    result.when(
      success: (_) {
        state = state.copyWith(isLoading: false);
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );

    return result;
  }

  Future<void> refreshUser() async {
    if (!state.isLoggedIn) return;

    final result = await _authService.getCurrentUser();
    result.when(
      success: (user) async {
        // Ensure user ID is saved to secure storage
        await SecureStorageService.saveUserId(user.id);
        state = state.copyWith(user: user);
      },
      failure: (error) {
        if (error.isUnauthorized) {
          logout();
        }
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Background validation - doesn't block app startup
  Future<void> _validateUserInBackground() async {
    try {
      final result = await _authService.getCurrentUser();
      result.when(
        success: (user) async {
          print('🔐 [Auth] Background validation successful: ${user.email}');
          // Ensure user ID is saved to secure storage
          await SecureStorageService.saveUserId(user.id);
          print('🔐 [Auth] User ID saved to secure storage: ${user.id}');
          // Update state with fresh user data
          state = state.copyWith(user: user);
        },
        failure: (error) async {
          print('🔐 [Auth] Background validation failed: ${error.message}');
          if (error.isUnauthorized) {
            print('🔐 [Auth] Token invalid, logging out user');
            await SecureStorageService.clearTokens();
            state = const AuthState(
              isLoggedIn: false,
              isInitialized: true,
              isLoading: false,
            );
          }
          // For other errors, we keep user logged in (network issues, server down, etc.)
        },
      );
    } catch (e) {
      print('🔐 [Auth] Background validation error: $e');
      // Don't log out user for unknown errors
    }
  }

}