import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../models/friend_status.dart';
import 'social_battery_widget.dart';

/// Dashboard header with personalized greeting and actions
/// Features smooth animations and interactive elements
class DashboardHeader extends StatefulWidget {
  /// User's name for personalized greeting
  final String userName;
  
  /// Time-based greeting message
  final String greeting;
  
  /// Subtitle message
  final String subtitle;
  
  /// Current user's social battery level
  final SocialBatteryLevel batteryLevel;
  
  /// Number of unread notifications
  final int unreadNotifications;
  
  /// Callback when search is tapped
  final VoidCallback? onSearchTapped;
  
  /// Callback when notifications is tapped
  final VoidCallback? onNotificationsTapped;
  
  /// Callback when battery level changes
  final ValueChanged<SocialBatteryLevel>? onBatteryLevelChanged;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.subtitle,
    required this.batteryLevel,
    this.unreadNotifications = 0,
    this.onSearchTapped,
    this.onNotificationsTapped,
    this.onBatteryLevelChanged,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _actionController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _actionController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    
    // Start entrance animation
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  void _handleActionTap(VoidCallback? callback) {
    if (callback == null) return;
    
    _actionController.forward().then((_) {
      _actionController.reverse();
      callback();
    });
    
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.warmCream,
            AppColors.warmCreamAlt,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.sageGreenWithOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            AppDimensions.spacingL,
            AppDimensions.screenPadding,
            AppDimensions.spacingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(),
              const SizedBox(height: AppDimensions.spacingL),
              _buildSocialBatterySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildGreetingSection(),
        ),
        const SizedBox(width: AppDimensions.spacingL),
        _buildActionButtons(),
      ],
    )
        .animate(controller: _headerController)
        .fadeIn(duration: AppDurations.medium)
        .slideY(begin: -0.2, end: 0.0, duration: AppDurations.medium);
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.greeting}, ${widget.userName}',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.softCharcoal,
            height: 1.2,
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: AppDurations.medium)
            .slideX(begin: -0.3, end: 0.0, duration: AppDurations.medium),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          widget.subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: AppDurations.medium)
            .slideX(begin: -0.3, end: 0.0, duration: AppDurations.medium),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.search_rounded,
          onTap: () => _handleActionTap(widget.onSearchTapped),
          tooltip: 'Search',
        )
            .animate(delay: 600.ms)
            .fadeIn(duration: AppDurations.medium)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
        const SizedBox(width: AppDimensions.spacingM),
        _buildNotificationButton()
            .animate(delay: 800.ms)
            .fadeIn(duration: AppDurations.medium)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: _actionController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_actionController.value * 0.05),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.sageGreenWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: AppColors.sageGreenWithOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.iconS,
                  color: AppColors.sageGreen,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    final hasUnread = widget.unreadNotifications > 0;
    
    return Tooltip(
      message: 'Notifications',
      child: GestureDetector(
        onTap: () => _handleActionTap(widget.onNotificationsTapped),
        child: AnimatedBuilder(
          animation: _actionController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_actionController.value * 0.05),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.sageGreenWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(
                        color: AppColors.sageGreenWithOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      hasUnread 
                          ? Icons.notifications_active_rounded 
                          : Icons.notifications_rounded,
                      size: AppDimensions.iconS,
                      color: AppColors.sageGreen,
                    ),
                  ),
                  if (hasUnread)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dustyRose,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.pearlWhite,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          widget.unreadNotifications > 99 
                              ? '99+' 
                              : '${widget.unreadNotifications}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.pearlWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.0, 0.0),
                          end: const Offset(1.0, 1.0),
                          duration: AppDurations.fast,
                          curve: Curves.elasticOut,
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialBatterySection() {
    if (widget.onBatteryLevelChanged == null) {
      return const SizedBox.shrink();
    }
    
    return SocialBatteryWidget(
      currentLevel: widget.batteryLevel,
      onLevelChanged: widget.onBatteryLevelChanged!,
    )
        .animate(delay: 1000.ms)
        .fadeIn(duration: AppDurations.medium)
        .slideY(begin: 0.3, end: 0.0, duration: AppDurations.medium);
  }
}

/// Compact version of dashboard header for smaller screens
class CompactDashboardHeader extends StatelessWidget {
  /// User's name
  final String userName;
  
  /// Greeting message
  final String greeting;
  
  /// Battery level
  final SocialBatteryLevel batteryLevel;
  
  /// Unread notifications count
  final int unreadNotifications;
  
  /// Action callbacks
  final VoidCallback? onSearchTapped;
  final VoidCallback? onNotificationsTapped;

  const CompactDashboardHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.batteryLevel,
    this.unreadNotifications = 0,
    this.onSearchTapped,
    this.onNotificationsTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.warmCream,
            AppColors.warmCreamAlt,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${greeting.split(' ').first}, $userName',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.softCharcoal,
                      ),
                    ),
                    Row(
                      children: [
                        SocialBatteryIndicator(
                          level: batteryLevel,
                          showLabel: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onSearchTapped,
                    icon: const Icon(Icons.search_rounded),
                    color: AppColors.sageGreen,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: onNotificationsTapped,
                        icon: Icon(
                          unreadNotifications > 0
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_rounded,
                        ),
                        color: AppColors.sageGreen,
                      ),
                      if (unreadNotifications > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.dustyRose,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}