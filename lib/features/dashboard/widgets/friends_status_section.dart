import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../models/friend_status.dart';
import 'social_battery_widget.dart';

/// Friends status section with social battery indicators
/// Features smooth animations and interactive friend cards
class FriendsStatusSection extends StatefulWidget {
  /// List of friends to display
  final List<FriendStatus> friends;
  
  /// Section title
  final String title;
  
  /// Maximum number of friends to show
  final int maxItems;
  
  /// Enable stagger animation
  final bool enableStaggerAnimation;
  
  /// Callback when a friend is tapped
  final ValueChanged<FriendStatus>? onFriendTapped;
  
  /// Callback when "See All" is tapped
  final VoidCallback? onSeeAllTapped;

  const FriendsStatusSection({
    super.key,
    required this.friends,
    this.title = 'Friends',
    this.maxItems = 5,
    this.enableStaggerAnimation = true,
    this.onFriendTapped,
    this.onSeeAllTapped,
  });

  @override
  State<FriendsStatusSection> createState() => _FriendsStatusSectionState();
}

class _FriendsStatusSectionState extends State<FriendsStatusSection>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late List<AnimationController> _itemControllers;

  @override
  void initState() {
    super.initState();
    
    _titleController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    final itemCount = widget.friends.length.clamp(0, widget.maxItems);
    _itemControllers = List.generate(
      itemCount,
      (index) => AnimationController(
        duration: AppDurations.medium,
        vsync: this,
      ),
    );
    
    if (widget.enableStaggerAnimation) {
      _startStaggerAnimation();
    } else {
      _titleController.value = 1.0;
      for (var controller in _itemControllers) {
        controller.value = 1.0;
      }
    }
  }

  void _startStaggerAnimation() {
    _titleController.forward();
    
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 400 + (i * 100)), () {
        if (mounted) {
          _itemControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.friends.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: AppDimensions.spacingL),
        _buildFriendsList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '👥',
              style: TextStyle(
                fontSize: AppTextStyles.headlineSmall.fontSize,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              widget.title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (widget.onSeeAllTapped != null && widget.friends.length > widget.maxItems)
          GestureDetector(
            onTap: widget.onSeeAllTapped,
            child: Text(
              'See all',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.sageGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    )
        .animate(controller: _titleController)
        .fadeIn(duration: AppDurations.medium)
        .slideX(begin: -0.3, end: 0.0, duration: AppDurations.medium);
  }

  Widget _buildFriendsList() {
    final displayFriends = widget.friends.take(widget.maxItems).toList();
    
    return Column(
      children: displayFriends.asMap().entries.map((entry) {
        final index = entry.key;
        final friend = entry.value;
        
        return AnimatedBuilder(
          animation: _itemControllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                (1 - _itemControllers[index].value) * 50,
                0,
              ),
              child: Opacity(
                opacity: _itemControllers[index].value,
                child: FriendStatusItem(
                  friend: friend,
                  onTap: widget.onFriendTapped,
                  itemIndex: index,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXXL),
      decoration: BoxDecoration(
        color: AppColors.warmCreamAlt,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          const Text(
            '👋',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'No friends yet',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Connect with like-minded people',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.slow)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }
}

/// Individual friend status item with avatar and battery indicator
class FriendStatusItem extends StatefulWidget {
  /// The friend to display
  final FriendStatus friend;
  
  /// Callback when tapped
  final ValueChanged<FriendStatus>? onTap;
  
  /// Item index for animations
  final int itemIndex;

  const FriendStatusItem({
    super.key,
    required this.friend,
    this.onTap,
    this.itemIndex = 0,
  });

  @override
  State<FriendStatusItem> createState() => _FriendStatusItemState();
}

class _FriendStatusItemState extends State<FriendStatusItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.selectionClick();
      widget.onTap!(widget.friend);
    }
  }

  void _handleHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _hoverAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? AppColors.sageGreenWithOpacity(0.02)
                      : AppColors.pearlWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: _isHovered 
                        ? AppColors.sageGreenWithOpacity(0.2)
                        : AppColors.sageGreenWithOpacity(0.1),
                  ),
                  boxShadow: _isHovered 
                      ? [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    _buildAvatar(),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(child: _buildFriendInfo()),
                    _buildOnlineIndicator(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.friend.avatarGradientStart,
                widget.friend.avatarGradientEnd,
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.pearlWhite,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.friend.batteryColor.withValues(alpha: 0.2),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.friend.avatarInitial,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.pearlWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
            .animate(target: _isHovered ? 1.0 : 0.0)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: AppDurations.fast,
            ),
        Positioned(
          bottom: -2,
          right: -2,
          child: AnimatedSocialBatteryLevel(
            level: widget.friend.batteryLevel,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildFriendInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.friend.name,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          widget.friend.displayStatusMessage,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildOnlineIndicator() {
    if (!widget.friend.isOnline) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.sageGreen,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.pearlWhite,
          width: 2,
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: AppDurations.medium,
          curve: Curves.elasticOut,
        );
  }
}

/// Horizontal scrollable friends list for compact layouts
class HorizontalFriendsList extends StatelessWidget {
  /// List of friends
  final List<FriendStatus> friends;
  
  /// Callback when friend is tapped
  final ValueChanged<FriendStatus>? onFriendTapped;

  const HorizontalFriendsList({
    super.key,
    required this.friends,
    this.onFriendTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        itemCount: friends.length,
        separatorBuilder: (context, index) => 
            const SizedBox(width: AppDimensions.spacingM),
        itemBuilder: (context, index) {
          final friend = friends[index];
          return GestureDetector(
            onTap: () => onFriendTapped?.call(friend),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            friend.avatarGradientStart,
                            friend.avatarGradientEnd,
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.pearlWhite,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          friend.avatarInitial,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.pearlWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: SocialBatteryIndicator(
                        level: friend.batteryLevel,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                SizedBox(
                  width: 60,
                  child: Text(
                    friend.name.split(' ').first,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.softCharcoal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Friends status summary widget for compact display
class FriendsStatusSummary extends StatelessWidget {
  /// List of friends
  final List<FriendStatus> friends;

  const FriendsStatusSummary({
    super.key,
    required this.friends,
  });

  @override
  Widget build(BuildContext context) {
    final energizedCount = friends
        .where((f) => f.batteryLevel == SocialBatteryLevel.energized)
        .length;
    final selectiveCount = friends
        .where((f) => f.batteryLevel == SocialBatteryLevel.selective)
        .length;
    final rechargingCount = friends
        .where((f) => f.batteryLevel == SocialBatteryLevel.recharging)
        .length;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.warmCreamAlt,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusCount(
            '🟢',
            energizedCount,
            'Ready',
            AppColors.sageGreen,
          ),
          _buildStatusCount(
            '🟡',
            selectiveCount,
            'Selective',
            AppColors.warmPeach,
          ),
          _buildStatusCount(
            '🔴',
            rechargingCount,
            'Recharging',
            AppColors.dustyRose,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCount(
    String icon,
    int count,
    String label,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: AppDimensions.spacingXS),
            Text(
              '$count',
              style: AppTextStyles.titleMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
      ],
    );
  }
}