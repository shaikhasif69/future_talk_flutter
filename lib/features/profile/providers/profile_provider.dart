import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chat/models/social_battery_status.dart';
import '../models/profile_data.dart';

/// Profile state management with Riverpod
/// Handles user profile data, social battery updates, and premium features
class ProfileNotifier extends StateNotifier<AsyncValue<ProfileData>> {
  ProfileNotifier() : super(const AsyncValue.loading()) {
    _initializeProfile();
  }

  /// Initialize profile with mock data
  /// In production, this would fetch from API
  Future<void> _initializeProfile() async {
    try {
      state = const AsyncValue.loading();
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      final profileData = ProfileData.createMockData();
      state = AsyncValue.data(profileData);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await _initializeProfile();
  }

  /// Update social battery level
  Future<void> updateBatteryLevel(SocialBatteryLevel newLevel, {String? message}) async {
    final currentData = state.value;
    if (currentData == null) return;

    try {
      final updatedBatteryStatus = SocialBatteryStatus(
        level: newLevel,
        lastUpdated: DateTime.now(),
        message: message,
      );

      final updatedProfile = currentData.copyWith(
        batteryStatus: updatedBatteryStatus,
        lastUpdated: DateTime.now(),
      );

      state = AsyncValue.data(updatedProfile);
      
      // In production, would sync with API
      debugPrint('Social battery updated to: ${newLevel.name}');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update profile information
  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? username,
  }) async {
    final currentData = state.value;
    if (currentData == null) return;

    try {
      final updatedProfile = currentData.copyWith(
        displayName: displayName ?? currentData.displayName,
        bio: bio ?? currentData.bio,
        username: username ?? currentData.username,
        lastUpdated: DateTime.now(),
      );

      state = AsyncValue.data(updatedProfile);
      
      // In production, would sync with API
      debugPrint('Profile updated successfully');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update profile settings
  Future<void> updateSettings(ProfileSettings newSettings) async {
    final currentData = state.value;
    if (currentData == null) return;

    try {
      final updatedProfile = currentData.copyWith(
        settings: newSettings,
        lastUpdated: DateTime.now(),
      );

      state = AsyncValue.data(updatedProfile);
      
      // In production, would sync with API
      debugPrint('Settings updated successfully');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Toggle specific setting
  Future<void> toggleSetting(String settingKey) async {
    final currentData = state.value;
    if (currentData == null) return;

    try {
      ProfileSettings updatedSettings;
      
      switch (settingKey) {
        case 'showOnlineStatus':
          updatedSettings = currentData.settings.copyWith(
            showOnlineStatus: !currentData.settings.showOnlineStatus,
          );
          break;
        case 'allowTimeCapsules':
          updatedSettings = currentData.settings.copyWith(
            allowTimeCapsules: !currentData.settings.allowTimeCapsules,
          );
          break;
        case 'enableNotifications':
          updatedSettings = currentData.settings.copyWith(
            enableNotifications: !currentData.settings.enableNotifications,
          );
          break;
        case 'shareBatteryStatus':
          updatedSettings = currentData.settings.copyWith(
            shareBatteryStatus: !currentData.settings.shareBatteryStatus,
          );
          break;
        case 'premiumNotifications':
          updatedSettings = currentData.settings.copyWith(
            premiumNotifications: !currentData.settings.premiumNotifications,
          );
          break;
        default:
          return;
      }

      await updateSettings(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update avatar (in future version with image picker)
  Future<void> updateAvatar({String? initials, LinearGradient? gradient}) async {
    final currentData = state.value;
    if (currentData == null) return;

    try {
      final updatedProfile = currentData.copyWith(
        avatarInitials: initials ?? currentData.avatarInitials,
        avatarGradient: gradient ?? currentData.avatarGradient,
        lastUpdated: DateTime.now(),
      );

      state = AsyncValue.data(updatedProfile);
      
      debugPrint('Avatar updated successfully');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Handle logout action
  Future<void> logout() async {
    try {
      // In production, would clear auth tokens and navigate
      debugPrint('Logout initiated');
      
      // Reset state
      state = const AsyncValue.loading();
      
      // Simulate logout delay
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Export user data
  Future<void> exportData() async {
    final currentData = state.value;
    if (currentData == null) return;

    try {
      // In production, would generate and download data export
      final exportData = currentData.toJson();
      debugPrint('Data export prepared: ${exportData.keys.length} categories');
      
      // Simulate export process
      await Future.delayed(const Duration(milliseconds: 1000));
      
    } catch (error, stackTrace) {
      debugPrint('Export failed: $error');
    }
  }
}

/// Profile provider instance
final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileData>>((ref) {
  return ProfileNotifier();
});

/// Convenience providers for specific profile data
final profileDataProvider = Provider<ProfileData?>((ref) {
  return ref.watch(profileProvider).value;
});

final socialBatteryProvider = Provider<SocialBatteryStatus?>((ref) {
  return ref.watch(profileProvider).value?.batteryStatus;
});

final profileStatsProvider = Provider<ProfileStats?>((ref) {
  return ref.watch(profileProvider).value?.stats;
});

final premiumFeaturesProvider = Provider<PremiumFeatures?>((ref) {
  return ref.watch(profileProvider).value?.premiumFeatures;
});

final profileFriendsProvider = Provider<List<ProfileFriend>>((ref) {
  return ref.watch(profileProvider).value?.friends ?? [];
});

final profileSettingsProvider = Provider<ProfileSettings?>((ref) {
  return ref.watch(profileProvider).value?.settings;
});

/// Profile loading state provider
final profileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isLoading;
});

/// Profile error provider
final profileErrorProvider = Provider<String?>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState.hasError ? profileState.error.toString() : null;
});

/// Utility providers for UI state
final canEditProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(profileDataProvider);
  return profile != null && !ref.watch(profileLoadingProvider);
});

final isPremiumUserProvider = Provider<bool>((ref) {
  final premiumFeatures = ref.watch(premiumFeaturesProvider);
  return premiumFeatures?.isPremium ?? false;
});

final friendsCountProvider = Provider<int>((ref) {
  return ref.watch(profileFriendsProvider).length;
});

/// Battery level change handler
class BatteryLevelHandler {
  final ProfileNotifier _notifier;

  BatteryLevelHandler(this._notifier);

  /// Handle battery level selection with haptic feedback
  Future<void> handleBatteryLevelChange(
    SocialBatteryLevel newLevel, {
    String? customMessage,
  }) async {
    await _notifier.updateBatteryLevel(newLevel, message: customMessage);
  }

  /// Get suggested message for battery level
  String getSuggestedMessage(SocialBatteryLevel level) {
    switch (level) {
      case SocialBatteryLevel.energized:
        return 'Ready for meaningful conversations';
      case SocialBatteryLevel.selective:
        return 'Prefer thoughtful, slower exchanges';
      case SocialBatteryLevel.recharging:
        return 'Taking quiet time to restore energy';
    }
  }
}

/// Profile action handler
class ProfileActionHandler {
  static Future<void> handleAction(
    String actionId,
    ProfileNotifier notifier,
    BuildContext context,
  ) async {
    switch (actionId) {
      case 'edit_profile':
        // Navigate to edit profile screen
        debugPrint('Navigate to edit profile');
        break;
      case 'activity':
        // Navigate to activity/analytics screen
        debugPrint('Navigate to activity screen');
        break;
      case 'export_data':
        await notifier.exportData();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data export initiated'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        break;
      case 'logout':
        await _showLogoutConfirmation(context, notifier);
        break;
      default:
        debugPrint('Unknown action: $actionId');
    }
  }

  static Future<void> _showLogoutConfirmation(
    BuildContext context,
    ProfileNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.logout();
      if (context.mounted) {
        // Navigate to login screen
        debugPrint('Navigate to login screen');
      }
    }
  }
}