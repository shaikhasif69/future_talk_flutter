import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/constants/app_text_styles.dart';

/// Section divider for grouping chats (Pinned, Recent, Earlier)
/// Features gentle styling and smooth animations
class ChatSectionDivider extends StatelessWidget {
  const ChatSectionDivider({
    super.key,
    required this.title,
    this.showLine = true,
    this.actions,
  });

  final String title;
  final bool showLine;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingS,
      ),
      child: Row(
        children: [
          // Section title
          Text(
            title.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.softCharcoalLight,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          
          // Divider line
          if (showLine) ...[
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Container(
                height: 1.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.softCharcoalLight.withOpacity( 0.2),
                      AppColors.softCharcoalLight.withOpacity( 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
          
          // Actions (optional)
          if (actions != null) ...[
            const SizedBox(width: AppDimensions.spacingM),
            ...actions!,
          ],
        ],
      ),
    ).animate().fadeIn().slideX(
      begin: -0.2,
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
    );
  }
}

/// Section divider with count badge
class ChatSectionDividerWithCount extends StatelessWidget {
  const ChatSectionDividerWithCount({
    super.key,
    required this.title,
    required this.count,
    this.showLine = true,
    this.actions,
  });

  final String title;
  final int count;
  final bool showLine;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingS,
      ),
      child: Row(
        children: [
          // Section title with count
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.softCharcoalLight,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 1.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softCharcoalLight.withOpacity( 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: AppColors.softCharcoalLight.withOpacity( 0.8),
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          // Divider line
          if (showLine) ...[
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Container(
                height: 1.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.softCharcoalLight.withOpacity( 0.2),
                      AppColors.softCharcoalLight.withOpacity( 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
          
          // Actions (optional)
          if (actions != null) ...[
            const SizedBox(width: AppDimensions.spacingM),
            ...actions!,
          ],
        ],
      ),
    );
  }
}

/// Expandable section divider for collapsible sections
class ExpandableChatSectionDivider extends StatefulWidget {
  const ExpandableChatSectionDivider({
    super.key,
    required this.title,
    this.count,
    this.isExpanded = true,
    this.onToggle,
    this.showLine = true,
  });

  final String title;
  final int? count;
  final bool isExpanded;
  final Function(bool)? onToggle;
  final bool showLine;

  @override
  State<ExpandableChatSectionDivider> createState() =>
      _ExpandableChatSectionDividerState();
}

class _ExpandableChatSectionDividerState
    extends State<ExpandableChatSectionDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.mediumFast,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    if (widget.isExpanded) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpandableChatSectionDivider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleToggle() {
    if (widget.onToggle != null) {
      widget.onToggle!(!widget.isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleToggle,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingS,
          ),
          child: Row(
            children: [
              // Expand/collapse icon
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 3.14159, // 180 degrees in radians
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.0,
                      color: AppColors.softCharcoalLight,
                    ),
                  );
                },
              ),
              
              const SizedBox(width: AppDimensions.spacingS),
              
              // Section title with count
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.softCharcoalLight,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  if (widget.count != null) ...[
                    const SizedBox(width: AppDimensions.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softCharcoalLight.withOpacity( 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        widget.count.toString(),
                        style: TextStyle(
                          color: AppColors.softCharcoalLight.withOpacity( 0.8),
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              // Divider line
              if (widget.showLine) ...[
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.softCharcoalLight.withOpacity( 0.2),
                          AppColors.softCharcoalLight.withOpacity( 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal section divider for clean layouts
class MinimalChatSectionDivider extends StatelessWidget {
  const MinimalChatSectionDivider({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.spacingL,
        bottom: AppDimensions.spacingS,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.softCharcoalLight.withOpacity( 0.7),
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}