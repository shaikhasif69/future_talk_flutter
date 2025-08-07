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
      // Check if we have stored tokens
      final accessToken = await SecureStorageService.getAccessToken();
      final refreshToken = await SecureStorageService.getRefreshToken();
      final isLoggedInFlag = await SecureStorageService.isLoggedIn();
      
      print('🔐 [Auth] Token check: accessToken=${accessToken != null}, refreshToken=${refreshToken != null}, isLoggedInFlag=$isLoggedInFlag');
      
      if (accessToken != null && refreshToken != null && isLoggedInFlag) {
        print('🔐 [Auth] Tokens found, fetching user profile...');
        final result = await _authService.getCurrentUser();
        result.when(
          success: (user) {
            print('🔐 [Auth] User profile loaded: ${user.email}');
            state = AuthState(
              user: user,
              isLoggedIn: true,
              isInitialized: true,
              isLoading: false,
            );
          },
          failure: (error) async {
            print('🔐 [Auth] Failed to get user profile: ${error.message}. Clearing tokens.');
            await SecureStorageService.clearTokens();
            state = AuthState(
              isLoggedIn: false,
              isInitialized: true,
              isLoading: false,
              errorMessage: error.message,
            );
          },
        );
      } else {
        print('🔐 [Auth] No valid tokens found, user not logged in');
        state = const AuthState(
          isLoggedIn: false,
          isInitialized: true,
          isLoading: false,
        );
      }
    } catch (e) {
      print('🔐 [Auth] Initialization error: $e');
      state = AuthState(
        isLoggedIn: false,
        isInitialized: true,
        isLoading: false,
        errorMessage: 'Failed to initialize authentication',
      );
    }
    
    print('🔐 [Auth] Initialization complete. State: ${state.isLoggedIn ? "Logged In" : "Not Logged In"}');
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
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );

    return result;
  }

  Future<ApiResult<AuthResponse>> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final request = RegisterRequest(
      email: email,
      password: password,
      username: username,
      firstName: firstName,
      lastName: lastName,
    );

    final result = await _authService.register(request);

    result.when(
      success: (authResponse) {
        state = AuthState(
          user: authResponse.user,
          isLoggedIn: true,
          isInitialized: true,
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
      success: (user) {
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
}