import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../models/dashboard_data.dart';

/// Recent activity section with timeline and beautiful animations
/// Features staggered entrance animations and interactive timeline items
class RecentActivitySection extends StatefulWidget {
  /// List of recent activities
  final List<RecentActivity> activities;
  
  /// Section title
  final String title;
  
  /// Maximum number of activities to show
  final int maxItems;
  
  /// Enable stagger animation
  final bool enableStaggerAnimation;
  
  /// Callback when "See All" is tapped
  final VoidCallback? onSeeAllTapped;

  const RecentActivitySection({
    super.key,
    required this.activities,
    this.title = 'Recent Activity',
    this.maxItems = 5,
    this.enableStaggerAnimation = true,
    this.onSeeAllTapped,
  });

  @override
  State<RecentActivitySection> createState() => _RecentActivitySectionState();
}

class _RecentActivitySectionState extends State<RecentActivitySection>
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
    
    final itemCount = widget.activities.length.clamp(0, widget.maxItems);
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
      Future.delayed(Duration(milliseconds: 300 + (i * 150)), () {
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
    if (widget.activities.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: AppDimensions.spacingL),
        _buildActivityList(),
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
              '🕒',
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
        if (widget.onSeeAllTapped != null && widget.activities.length > widget.maxItems)
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

  Widget _buildActivityList() {
    final displayItems = widget.activities.take(widget.maxItems).toList();
    
    return Column(
      children: displayItems.asMap().entries.map((entry) {
        final index = entry.key;
        final activity = entry.value;
        final isLast = index == displayItems.length - 1;
        
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
                child: RecentActivityItem(
                  activity: activity,
                  showConnector: !isLast,
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
            '💫',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'No recent activity',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Your activities will appear here',
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

/// Individual activity item with timeline connector and hover effects
class RecentActivityItem extends StatefulWidget {
  /// The activity to display
  final RecentActivity activity;
  
  /// Whether to show the timeline connector
  final bool showConnector;
  
  /// Item index for animation delays
  final int itemIndex;

  const RecentActivityItem({
    super.key,
    required this.activity,
    this.showConnector = true,
    this.itemIndex = 0,
  });

  @override
  State<RecentActivityItem> createState() => _RecentActivityItemState();
}

class _RecentActivityItemState extends State<RecentActivityItem>
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
    if (widget.activity.onTap != null) {
      HapticFeedback.selectionClick();
      widget.activity.onTap!();
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
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimelineIcon(),
                      const SizedBox(width: AppDimensions.spacingM),
                      Expanded(child: _buildContent()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineIcon() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: widget.activity.iconBackgroundGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.pearlWhite,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: _isHovered ? 8 : 4,
                offset: Offset(0, _isHovered ? 3 : 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.activity.icon,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        )
            .animate(target: _isHovered ? 1.0 : 0.0)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: AppDurations.fast,
            ),
        if (widget.showConnector)
          Container(
            width: 2,
            height: 24,
            margin: const EdgeInsets.only(top: AppDimensions.spacingS),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.sageGreenWithOpacity(0.3),
                  AppColors.sageGreenWithOpacity(0.1),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: _isHovered 
            ? AppColors.sageGreenWithOpacity(0.02)
            : Colors.transparent,
        border: Border.all(
          color: _isHovered 
              ? AppColors.sageGreenWithOpacity(0.2)
              : AppColors.sageGreenWithOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.activity.title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            widget.activity.timeAgo,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
          if (widget.activity.subtitle != null) ...[
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              widget.activity.subtitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.softCharcoalLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact recent activity list for smaller spaces
class CompactRecentActivityList extends StatelessWidget {
  /// List of activities
  final List<RecentActivity> activities;
  
  /// Maximum items to show
  final int maxItems;

  const CompactRecentActivityList({
    super.key,
    required this.activities,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = activities.take(maxItems).toList();
    
    return Column(
      children: displayItems.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: AppColors.warmCreamAlt,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(
              color: AppColors.sageGreenWithOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: activity.iconBackgroundGradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    activity.icon,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      activity.timeAgo,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}