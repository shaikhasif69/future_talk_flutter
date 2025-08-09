import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../../navigation/widgets/side_menu.dart';
import '../models/dashboard_data.dart';
import '../models/friend_status.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/friends_status_section.dart';
import '../widgets/sign_out_modal.dart';
import '../../auth/providers/auth_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  
  late AnimationController _refreshController;
  late AnimationController _sideMenuAnimationController;
  late Animation<double> _sideMenuAnimation;
  late Animation<double> _contentScaleAnimation;
  late Animation<double> _contentSlideAnimation;
  
  bool _isSideMenuOpen = false;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _refreshController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );
    
    _sideMenuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _sideMenuAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _sideMenuAnimationController, curve: Curves.easeOut),
    );
    
    _contentScaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _sideMenuAnimationController, curve: Curves.easeOut),
    );
    
    _contentSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sideMenuAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    _sideMenuAnimationController.dispose();
    super.dispose();
  }


  void _handleBatteryLevelChanged(SocialBatteryLevel newLevel) {
    ref.read(dashboardProvider.notifier).updateBatteryLevel(newLevel);
    HapticFeedback.selectionClick();
  }

  void _handleQuickActionTap(String actionId) {
    HapticFeedback.mediumImpact();
    
    switch (actionId) {
      case '1':
        _showFeatureSnackBar('Time Capsule', '💌');
        break;
      case '2':
        _showFeatureSnackBar('Start Chat', '💬');
        break;
      case '3':
        _showFeatureSnackBar('Touch Stone', '🪨');
        break;
      case '4':
        _showFeatureSnackBar('Read Together', '📚');
        break;
    }
  }

  void _showFeatureSnackBar(String feature, String emoji) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              '$feature feature coming soon!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pearlWhite,
              ),
            ),
          ],
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


  void _toggleSideMenu() {
    setState(() {
      _isSideMenuOpen = !_isSideMenuOpen;
    });
    
    if (_isSideMenuOpen) {
      _sideMenuAnimationController.forward();
    } else {
      _sideMenuAnimationController.reverse();
    }
    
    HapticFeedback.mediumImpact();
  }

  void _closeSideMenu() {
    if (_isSideMenuOpen) {
      setState(() {
        _isSideMenuOpen = false;
      });
      _sideMenuAnimationController.reverse();
    }
  }

  Future<void> _showSignOutModal() async {
    print('🚪 [Logout] ShowSignOutModal called');
    
    // First close the side menu
    _closeSideMenu();
    
    // Wait for side menu animation to complete
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;
    
    print('🚪 [Logout] Showing sign out modal');
    // Show the sign out modal
    final result = await SignOutModal.show(context);
    
    print('🚪 [Logout] Modal result: $result');
    if (result == true && mounted) {
      print('🚪 [Logout] User confirmed logout, calling _performLogout');
      await _performLogout();
    } else {
      print('🚪 [Logout] User cancelled logout');
    }
  }

  Future<void> _performLogout() async {
    print('🚪 [Logout] _performLogout called');
    if (_isLoggingOut) {
      print('🚪 [Logout] Already logging out, returning');
      return;
    }
    
    print('🚪 [Logout] Setting _isLoggingOut = true');
    setState(() {
      _isLoggingOut = true;
    });

    try {
      HapticFeedback.lightImpact();
      print('🚪 [Logout] Showing loading dialog');
      
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingXXL),
              margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
              decoration: BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.sageGreen,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    'Signing out...',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.softCharcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      print('🚪 [Logout] Calling AuthProvider logout (which will call API then clear storage)...');
      // Use AuthProvider logout method which properly manages auth state
      // This will call the API with the token, then clear storage
      await ref.read(authProvider.notifier).logout();
      print('🚪 [Logout] AuthProvider logout completed');
      
      if (mounted) {
        print('🚪 [Logout] Closing loading dialog');
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
        
        print('🚪 [Logout] Showing success snackbar');
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signed out successfully',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pearlWhite,
              ),
            ),
            backgroundColor: AppColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        
        print('🚪 [Logout] Navigating to splash screen');
        // Small delay to ensure state is fully updated
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Navigate to splash screen - the router will handle the redirect
        context.go('/splash');
        print('🚪 [Logout] Navigation to splash completed');
      }
    } catch (e) {
      print('🚪 [Logout] Error during logout: $e');
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
        
        // Still show success and navigate (logout succeeded locally)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signed out successfully',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pearlWhite,
              ),
            ),
            backgroundColor: AppColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
        context.go('/splash');
        print('🚪 [Logout] Error case: Navigated to splash');
      }
    } finally {
      if (mounted) {
        print('🚪 [Logout] Setting _isLoggingOut = false');
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(dashboardProvider);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).setContext(context);
    });
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: dashboardData.when(
        loading: () => _buildLoadingScreen(),
        error: (error, stackTrace) => _buildErrorScreen(error.toString()),
        data: (data) => Stack(
          children: [
            // Side menu
            AnimatedBuilder(
              animation: _sideMenuAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_sideMenuAnimation.value * MediaQuery.of(context).size.width / 1.35, 0),
                  child: SideMenu(
                    onSignOut: _showSignOutModal,
                    onMenuClose: _closeSideMenu,
                  ),
                );
              },
            ),
            
            // Main content with scaling and sliding animation
            AnimatedBuilder(
              animation: _sideMenuAnimationController,
              builder: (context, child) {
                final slideOffset = _contentSlideAnimation.value * MediaQuery.of(context).size.width / 1.35;
                return Transform.translate(
                  offset: Offset(slideOffset, 0),
                  child: Transform.scale(
                    scale: _contentScaleAnimation.value,
                    child: GestureDetector(
                      onTap: _closeSideMenu,
                      child: AbsorbPointer(
                        absorbing: _isSideMenuOpen,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: _contentSlideAnimation.value > 0.1
                                ? BorderRadius.circular(20) 
                                : BorderRadius.zero,
                            boxShadow: _contentSlideAnimation.value > 0.1
                                ? [
                                    BoxShadow(
                                      color: AppColors.sageGreen.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                      offset: const Offset(-2, 0),
                                    )
                                  ]
                                : null,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _buildMainContent(data),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'Preparing your sanctuary...',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.softCharcoalLight,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.medium);
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '😔',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Text(
                'Something went wrong',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.softCharcoal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'We couldn\'t load your dashboard right now',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingXXL),
              ElevatedButton(
                onPressed: () {
                  ref.read(dashboardProvider.notifier).refresh();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sageGreen,
                  foregroundColor: AppColors.pearlWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingXXL,
                    vertical: AppDimensions.spacingL,
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(DashboardData data) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: FTStaggerAnimation(
              delay: 100.ms,
              child: DashboardHeader(
                userName: data.userName,
                greeting: data.greeting,
                subtitle: data.subtitle,
                batteryLevel: data.userBatteryLevel,
                unreadNotifications: data.unreadNotifications,
                onSearchTapped: () => _showFeatureSnackBar('Search', '🔍'),
                onNotificationsTapped: _toggleSideMenu,
                onBatteryLevelChanged: _handleBatteryLevelChanged,
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FTStaggerAnimation(
                  delay: 300.ms,
                  child: QuickActionsGrid(
                    actions: data.quickActions.map((action) {
                      return action.copyWith(
                        onTap: () => _handleQuickActionTap(action.id),
                      );
                    }).toList(),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.sectionPadding),
                
                FTStaggerAnimation(
                  delay: 500.ms,
                  child: RecentActivitySection(
                    activities: data.recentActivities,
                    onSeeAllTapped: () => _showFeatureSnackBar('Activity History', '📜'),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.sectionPadding),
                
                FTStaggerAnimation(
                  delay: 700.ms,
                  child: FriendsStatusSection(
                    friends: data.friends,
                    onFriendTapped: (friend) => _handleFriendTapped(friend),
                    onSeeAllTapped: () => _showFeatureSnackBar('All Friends', '👥'),
                  ),
                ),
                
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
    );
  }

  void _handleFriendTapped(FriendStatus friend) {
    HapticFeedback.selectionClick();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFriendModal(friend),
    );
  }

  Widget _buildFriendModal(FriendStatus friend) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.modalRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.modalShadow,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingL),
                decoration: BoxDecoration(
                  color: AppColors.stoneGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          friend.avatarGradientStart,
                          friend.avatarGradientEnd,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        friend.avatarInitial,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.pearlWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.softCharcoal,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXS),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: friend.batteryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingS),
                            Text(
                              friend.displayStatusMessage,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.softCharcoalLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingXXL),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showFeatureSnackBar('Message', '💬');
                      },
                      icon: const Icon(Icons.message_rounded),
                      label: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sageGreen,
                        foregroundColor: AppColors.pearlWhite,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingL,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showFeatureSnackBar('Profile', '👤');
                      },
                      icon: const Icon(Icons.person_rounded),
                      label: const Text('Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.sageGreen,
                        side: const BorderSide(color: AppColors.sageGreen),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingL,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .slideY(begin: 1.0, end: 0.0, duration: AppDurations.medium)
        .fadeIn(duration: AppDurations.medium);
  }
}

class ResponsiveDashboardScreen extends StatelessWidget {
  const ResponsiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < AppDimensions.tabletBreakpoint) {
      return const DashboardScreen();
    }
    
    return const DashboardScreen();
  }
}