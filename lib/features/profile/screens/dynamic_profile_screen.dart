import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../providers/dynamic_profile_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/widgets/sign_out_modal.dart';

/// Dynamic profile screen that shows user data from auth provider
class DynamicProfileScreen extends ConsumerStatefulWidget {
  const DynamicProfileScreen({super.key});

  @override
  ConsumerState<DynamicProfileScreen> createState() => _DynamicProfileScreenState();
}

class _DynamicProfileScreenState extends ConsumerState<DynamicProfileScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _handleBackPressed() {
    HapticFeedback.lightImpact();
    context.pop();
  }

  void _handleSettingsPressed() {
    HapticFeedback.mediumImpact();
    context.push('/settings');
  }

  void _handleEditProfile() {
    HapticFeedback.selectionClick();
    _showComingSoonSnackBar('Edit Profile');
  }

  void _handleLogout() async {
    HapticFeedback.mediumImpact();
    
    final confirmed = await SignOutModal.show(context);
    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        context.go('/splash');
      }
    }
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature coming soon!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.pearlWhite,
          ),
        ),
        backgroundColor: AppColors.lavenderMist,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(dynamicProfileProvider);
    final profileState = ref.watch(dynamicProfileNotifierProvider);
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: profileData == null 
          ? _buildNotLoggedInState() 
          : _buildProfileContent(profileData, profileState),
    );
  }

  Widget _buildNotLoggedInState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🔒',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Text(
            'Please log in to view your profile',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.softCharcoal,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          ElevatedButton(
            onPressed: () => context.go('/sign_in'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sageGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXXL,
                vertical: AppDimensions.spacingM,
              ),
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(DynamicProfileData profileData, AsyncValue<DynamicProfileData?> profileState) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        // App bar
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.warmCream,
          foregroundColor: AppColors.softCharcoal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: _handleBackPressed,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: _handleSettingsPressed,
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Profile',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: false,
          ),
        ),

        // Profile header
        SliverToBoxAdapter(
          child: _buildProfileHeader(profileData),
        ),

        // Profile content
        SliverToBoxAdapter(
          child: _buildProfileInfo(profileData),
        ),

        // Profile actions
        SliverToBoxAdapter(
          child: _buildProfileActions(),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(DynamicProfileData profileData) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.screenPadding),
      padding: const EdgeInsets.all(AppDimensions.spacingXXL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withAlpha(26),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.sageGreen,
                  AppColors.lavenderMist,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                profileData.initials,
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.pearlWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // Name
          Text(
            profileData.displayName,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingS),

          // Username
          Text(
            '@${profileData.user.username}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Membership status
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              color: profileData.user.isPremium 
                  ? AppColors.sageGreen.withAlpha(26)
                  : AppColors.lavenderMist.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              border: Border.all(
                color: profileData.user.isPremium 
                    ? AppColors.sageGreen.withAlpha(77)
                    : AppColors.lavenderMist.withAlpha(77),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profileData.user.isPremium ? '✨' : '🌱',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  profileData.membershipStatus,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: profileData.user.isPremium 
                        ? AppColors.sageGreen
                        : AppColors.lavenderMist,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.2);
  }

  Widget _buildProfileInfo(DynamicProfileData profileData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding)
              .copyWith(bottom: AppDimensions.spacingL),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withAlpha(26),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          _buildInfoRow('Email', profileData.user.email),
          _buildInfoRow('Join Date', profileData.joinDate),

          if (profileData.user.bio != null && profileData.user.bio!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingM),
            _buildInfoRow('Bio', profileData.user.bio!),
          ],

          if (profileData.user.location != null && profileData.user.location!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingM),
            _buildInfoRow('Location', profileData.user.location!),
          ],
        ],
      ),
    ).animate(delay: 200.ms)
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.2);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.softCharcoalLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions() {
    final actions = [
      {
        'icon': '✏️',
        'title': 'Edit Profile',
        'subtitle': 'Update your display name, bio, and preferences',
        'onTap': _handleEditProfile,
      },
      {
        'icon': '📊',
        'title': 'Activity Stats',
        'subtitle': 'View your reading and chat statistics',
        'onTap': () => _showComingSoonSnackBar('Activity Stats'),
      },
      {
        'icon': '🎨',
        'title': 'Appearance',
        'subtitle': 'Customize your app theme and colors',
        'onTap': () => _showComingSoonSnackBar('Appearance Settings'),
      },
      {
        'icon': '🚪',
        'title': 'Sign Out',
        'subtitle': 'Sign out of your account',
        'onTap': _handleLogout,
        'isDestructive': true,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withAlpha(26),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          ...actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            final isLast = index == actions.length - 1;

            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (action['isDestructive'] == true)
                          ? AppColors.dustyRose.withAlpha(26)
                          : AppColors.sageGreen.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        action['icon'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  title: Text(
                    action['title'] as String,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: (action['isDestructive'] == true)
                          ? AppColors.dustyRose
                          : AppColors.softCharcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    action['subtitle'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.softCharcoalLight,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.stoneGray,
                  ),
                  onTap: action['onTap'] as VoidCallback,
                ),
                if (!isLast)
                  Divider(
                    color: AppColors.whisperGray,
                    height: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    ).animate(delay: 400.ms)
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.2);
  }
}