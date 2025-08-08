import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../../../shared/widgets/layouts/ft_scaffold_with_nav.dart';
import '../../../shared/providers/navigation_provider.dart';
import '../models/dashboard_data.dart';
import '../models/friend_status.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/friends_status_section.dart';
import '../widgets/dashboard_fab.dart';

/// Main dashboard screen for Future Talk
/// Features staggered entrance animations and premium user experience
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  
  // Animation controllers for smooth transitions
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _refreshController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    _refreshController.forward();
    
    // Use Riverpod to refresh dashboard data
    await ref.read(dashboardProvider.notifier).refresh();
    
    _refreshController.reverse();
    
    // Show refresh success feedback
    HapticFeedback.lightImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dashboard refreshed',
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
    }
  }

  void _handleBatteryLevelChanged(SocialBatteryLevel newLevel) {
    ref.read(dashboardProvider.notifier).updateBatteryLevel(newLevel);
    HapticFeedback.selectionClick();
  }

  void _handleQuickActionTap(String actionId) {
    HapticFeedback.mediumImpact();
    
    // Navigate based on action
    switch (actionId) {
      case '1': // Time Capsule
        _showFeatureSnackBar('Time Capsule', '💌');
        break;
      case '2': // Start Chat
        _showFeatureSnackBar('Start Chat', '💬');
        break;
      case '3': // Touch Stone
        _showFeatureSnackBar('Touch Stone', '🪨');
        break;
      case '4': // Read Together
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

  void _handleFabPressed() {
    HapticFeedback.heavyImpact();
    _showFeatureSnackBar('Quick Action', '⚡');
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(dashboardProvider);
    
    // Set context for navigation in dashboard provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).setContext(context);
    });
    
    return FTScaffold(
      backgroundColor: AppColors.warmCream,
      body: dashboardData.when(
        loading: () => _buildLoadingScreen(),
        error: (error, stackTrace) => _buildErrorScreen(error.toString()),
        data: (data) => Stack(
          children: [
            // Main content
            _buildMainContent(data),
            
            // Floating Action Button
            DashboardFAB(
              onPressed: _handleFabPressed,
              tooltip: 'Create new',
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
    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      color: AppColors.sageGreen,
      backgroundColor: AppColors.pearlWhite,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Dashboard Header
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
                onNotificationsTapped: () => _showFeatureSnackBar('Notifications', '🔔'),
                onBatteryLevelChanged: _handleBatteryLevelChanged,
              ),
            ),
          ),
          
          // Main content sections
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Actions Grid
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
                
                // Recent Activity Section
                FTStaggerAnimation(
                  delay: 500.ms,
                  child: RecentActivitySection(
                    activities: data.recentActivities,
                    onSeeAllTapped: () => _showFeatureSnackBar('Activity History', '📜'),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.sectionPadding),
                
                // Friends Status Section
                FTStaggerAnimation(
                  delay: 700.ms,
                  child: FriendsStatusSection(
                    friends: data.friends,
                    onFriendTapped: (friend) => _handleFriendTapped(friend),
                    onSeeAllTapped: () => _showFeatureSnackBar('All Friends', '👥'),
                  ),
                ),
                
                // Bottom padding for FAB
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
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
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingL),
                decoration: BoxDecoration(
                  color: AppColors.stoneGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Friend info
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
              
              // Action buttons
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

/// Responsive dashboard screen that adapts to different screen sizes
class ResponsiveDashboardScreen extends StatelessWidget {
  const ResponsiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < AppDimensions.tabletBreakpoint) {
      return const DashboardScreen();
    }
    
    // Tablet/Desktop layout
    return const DashboardScreen(); // Can be extended for larger screens
  }
}