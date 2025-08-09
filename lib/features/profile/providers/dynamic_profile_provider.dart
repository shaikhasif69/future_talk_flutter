import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_talk_frontend/features/auth/providers/auth_provider.dart';
import 'package:future_talk_frontend/features/auth/services/auth_service.dart';
import 'package:future_talk_frontend/features/auth/models/auth_models.dart';

/// Dynamic profile data based on authenticated user
class DynamicProfileData {
  final AuthUser user;
  final bool isRefreshing;
  final String? error;

  const DynamicProfileData({
    required this.user,
    this.isRefreshing = false,
    this.error,
  });

  DynamicProfileData copyWith({
    AuthUser? user,
    bool? isRefreshing,
    String? error,
  }) {
    return DynamicProfileData(
      user: user ?? this.user,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
    );
  }

  // Helper getters for UI
  String get displayName => user.displayName ?? user.username;
  String get initials {
    if (user.firstName != null && user.lastName != null) {
      return '${user.firstName![0].toUpperCase()}${user.lastName![0].toUpperCase()}';
    } else if (user.displayName != null && user.displayName!.isNotEmpty) {
      final parts = user.displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
      }
      return user.displayName![0].toUpperCase();
    }
    return user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U';
  }

  String get membershipStatus => user.isPremium ? 'Premium Member' : 'Future Talk Member';
  String get joinDate {
    if (user.createdAt != null) {
      try {
        final date = DateTime.parse(user.createdAt!);
        return 'Joined ${_formatDate(date)}';
      } catch (e) {
        return 'Member since ${user.createdAt}';
      }
    }
    return 'Future Talk Member';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference < 30) {
      return 'this month';
    } else if (difference < 365) {
      final months = (difference / 30).round();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference / 365).round();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
}

/// Provider that creates dynamic profile data based on auth user
final dynamicProfileProvider = Provider<DynamicProfileData?>((ref) {
  final authState = ref.watch(authProvider);
  
  // Make sure auth is initialized and user is logged in with user data
  if (!authState.isInitialized || !authState.isLoggedIn || authState.user == null) {
    return null;
  }

  return DynamicProfileData(user: authState.user!);
});

/// State notifier for managing profile refresh and error states
class DynamicProfileNotifier extends StateNotifier<AsyncValue<DynamicProfileData?>> {
  final AuthService _authService;
  final Ref _ref;

  DynamicProfileNotifier(this._authService, this._ref) : super(const AsyncValue.data(null));

  /// Refresh user profile data from server
  Future<void> refreshProfile() async {
    final authState = _ref.read(authProvider);
    if (!authState.isLoggedIn || authState.user == null) return;

    final currentData = DynamicProfileData(user: authState.user!);
    state = AsyncValue.data(currentData.copyWith(isRefreshing: true));

    try {
      final result = await _authService.getCurrentUser();
      
      result.when(
        success: (updatedUser) {
          // Trigger auth provider to update its user data
          _ref.read(authProvider.notifier).refreshUser();
          
          state = AsyncValue.data(
            DynamicProfileData(
              user: updatedUser,
              isRefreshing: false,
            ),
          );
        },
        failure: (error) {
          state = AsyncValue.data(
            currentData.copyWith(
              isRefreshing: false,
              error: error.message,
            ),
          );
        },
      );
    } catch (e) {
      state = AsyncValue.data(
        currentData.copyWith(
          isRefreshing: false,
          error: 'Failed to refresh profile: $e',
        ),
      );
    }
  }

  /// Clear error state
  void clearError() {
    final currentData = state.valueOrNull;
    if (currentData != null && currentData.error != null) {
      state = AsyncValue.data(
        currentData.copyWith(error: null),
      );
    }
  }
}

/// Provider for the profile notifier
final dynamicProfileNotifierProvider = StateNotifierProvider<DynamicProfileNotifier, AsyncValue<DynamicProfileData?>>((ref) {
  return DynamicProfileNotifier(AuthService(), ref);
});