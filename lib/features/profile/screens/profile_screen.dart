import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/indicators/ft_loading_indicator.dart';
// import '../../chat/models/social_battery_status.dart'; // Commented out for now
import '../models/profile_data.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
// import '../widgets/social_battery_section.dart'; // Commented out for now
import '../widgets/profile_stats_section.dart';
import '../widgets/premium_features_section.dart';
import '../widgets/profile_actions_section.dart';
import '../widgets/friends_preview_section.dart';

/// Premium profile screen for Future Talk
/// Features staggered animations, responsive design, and introvert-friendly interactions
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    
    // Listen to scroll changes for parallax effects
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }


  void _handleBackPressed() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
  }

  void _handleSettingsPressed() {
    HapticFeedback.mediumImpact();
    context.push('/settings');
  }

  void _handleAvatarTapped() {
    HapticFeedback.mediumImpact();
    // Show avatar options or photo picker
    debugPrint('Avatar tapped - show photo picker');
  }

  void _handleEditAvatarPressed() {
    HapticFeedback.selectionClick();
    // Show avatar customization options
    debugPrint('Edit avatar pressed');
  }

  // void _handleBatteryLevelChanged(SocialBatteryLevel newLevel) {
  //   ref.read(profileProvider.notifier).updateBatteryLevel(newLevel);
  // }

  void _handleFriendTapped(ProfileFriend friend) {
    HapticFeedback.lightImpact();
    // Navigate to friend's profile or start chat
    debugPrint('Friend tapped: ${friend.name}');
  }

  void _handleViewAllFriends() {
    final friends = ref.read(profileFriendsProvider);
    FriendsListDialog.show(
      context,
      friends: friends,
      onFriendTapped: _handleFriendTapped,
    );
  }

  void _navigateToFriendsScreen() {
    HapticFeedback.lightImpact();
    context.push('/friends');
  }

  Future<void> _handleProfileAction(String actionId) async {
    await ProfileActionHandler.handleAction(
      actionId,
      ref.read(profileProvider.notifier),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: profileState.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(error),
        data: (profileData) => _buildProfileContent(profileData),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FTLoadingIndicator(),
          SizedBox(height: AppDimensions.spacingL),
          Text(
            'Loading your sanctuary...',
            style: TextStyle(
              color: AppColors.softCharcoalLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms)
     .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.dustyRose.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: AppColors.dustyRose,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            Text(
              'Unable to load profile',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingS),
            
            Text(
              'Please check your connection and try again',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppDimensions.spacingXL),
            
            ElevatedButton(
              onPressed: () => ref.read(profileProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingXXL,
                  vertical: AppDimensions.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Text(
                'Try Again',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    ).animate()
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.2);
  }

  Widget _buildProfileContent(ProfileData profileData) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        overscroll: false,
        physics: const ClampingScrollPhysics(),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Profile header with parallax effect
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, _scrollOffset * 0.3),
              child: ProfileHeader(
                profileData: profileData,
                onBackPressed: _handleBackPressed,
                onSettingsPressed: _handleSettingsPressed,
                onAvatarTapped: _handleAvatarTapped,
                onEditAvatarPressed: _handleEditAvatarPressed,
              ),
            ),
          ),
          
          // Social battery section
          // SliverToBoxAdapter(
          //   child: SocialBatterySection(
          //     batteryStatus: profileData.batteryStatus,
          //     onBatteryLevelChanged: _handleBatteryLevelChanged,
          //   ),
          // ),
          
          // Profile content sections
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats section
                ProfileStatsSection(
                  stats: profileData.stats,
                ),
                
                // Friends count button
                _buildFriendsButton(profileData),
                
                // Premium features section
                if (profileData.premiumFeatures.isPremium)
                  PremiumFeaturesSection(
                    premiumFeatures: profileData.premiumFeatures,
                  )
                else
                  _buildUpgradeToPremiumSection(),
                
                // Profile actions section
                ProfileActionsSection(
                  actions: _buildProfileActions(),
                ),
                
                // Friends preview section
                FriendsPreviewSection(
                  friends: profileData.friends,
                  onViewAllPressed: _handleViewAllFriends,
                  onFriendTapped: _handleFriendTapped,
                ),
                
                // Bottom spacing for safe area
                SizedBox(height: AppDimensions.spacingXXXL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeToPremiumSection() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ).copyWith(bottom: AppDimensions.spacingL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXXL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.sageGreen.withAlpha(26),
              AppColors.lavenderMist.withAlpha(26),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          border: Border.all(
            color: AppColors.sageGreen.withAlpha(77),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Text(
              '✨',
              style: TextStyle(fontSize: 32),
            ),
            
            SizedBox(height: AppDimensions.spacingM),
            
            Text(
              'Unlock Premium Features',
              style: AppTextStyles.headlineSmall.copyWith(
                fontFamily: AppTextStyles.headingFont,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingS),
            
            Text(
              'Get access to Connection Stones, Parallel Reading, Premium Games, and more sanctuary features.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppDimensions.spacingXL),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  debugPrint('Navigate to premium upgrade');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sageGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                child: Text(
                  'Upgrade to Premium',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildFriendsButton(ProfileData profileData) {
    // Get friends count - fallback to 0 if friends list is empty
    final friendsCount = profileData.friends.length;
    final friendsText = friendsCount == 1 ? '1 friend' : '$friendsCount friends';
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(
          MediaQuery.of(context).size.width,
        ),
      ).copyWith(bottom: AppDimensions.spacingL),
      child: GestureDetector(
        onTap: _navigateToFriendsScreen,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM + 2,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.sageGreen.withValues(alpha: 0.12),
                AppColors.warmPeach.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: AppColors.sageGreen.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.sageGreen.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Friends icon with stronger background
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.sageGreen.withValues(alpha: 0.2),
                      AppColors.sageGreen.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.sageGreen.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  Icons.people_rounded,
                  size: 22,
                  color: AppColors.sageGreen,
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Text content with better styling
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Friends',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.softCharcoal,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      friendsText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.sageGreen,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon with background
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.sageGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.sageGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: 300.ms)
     .fadeIn(duration: 600.ms)
     .slideX(begin: 0.2)
     .then()
     .shimmer(duration: 2000.ms, color: AppColors.sageGreen.withValues(alpha: 0.1));
  }

  List<ProfileAction> _buildProfileActions() {
    return [
      ProfileAction(
        id: 'edit_profile',
        title: 'Edit Profile',
        subtitle: 'Update your display name, bio, and preferences',
        icon: '✎',
        onTap: () => _handleProfileAction('edit_profile'),
      ),
      ProfileAction(
        id: 'activity',
        title: 'Your Activity',
        subtitle: 'Detailed stats and reading analytics',
        icon: '📊',
        onTap: () => _handleProfileAction('activity'),
      ),
      ProfileAction(
        id: 'export_data',
        title: 'Export Data',
        subtitle: 'Download all your Future Talk content',
        icon: '💾',
        onTap: () => _handleProfileAction('export_data'),
      ),
      ProfileAction(
        id: 'logout',
        title: 'Logout',
        subtitle: 'Sign out of your account',
        icon: '🚪',
        onTap: () => _handleProfileAction('logout'),
        isDestructive: true,
      ),
    ];
  }
}

/// Responsive profile screen wrapper
class ResponsiveProfileScreen extends StatelessWidget {
  const ResponsiveProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use different layouts for different screen sizes
    if (screenWidth > AppDimensions.tabletBreakpoint) {
      return const TabletProfileScreen();
    } else {
      return const ProfileScreen();
    }
  }
}

/// Tablet-optimized profile screen layout
class TabletProfileScreen extends StatelessWidget {
  const TabletProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.maxContentWidth * 1.5,
          ),
          child: const ProfileScreen(),
        ),
      ),
    );
  }
}

/// Profile screen with bottom navigation integration
class ProfileScreenWithBottomNav extends StatelessWidget {
  const ProfileScreenWithBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ResponsiveProfileScreen(),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppColors.whisperGray,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('🏠', 'Home', false, () {}),
            _buildNavItem('💬', 'Chats', false, () {}),
            _buildNavItem('📚', 'Books', false, () {}),
            _buildNavItem('⏰', 'Capsules', false, () {}),
            _buildNavItem('👤', 'Profile', true, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 20,
              color: isActive ? AppColors.sageGreen : AppColors.softCharcoalLight,
            ),
          ),
          SizedBox(height: AppDimensions.spacingXS),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.sageGreen : AppColors.softCharcoalLight,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}