import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../models/dashboard_data.dart';

/// 2x2 grid of quick action cards with premium badges and animations
/// Features staggered entrance animations and hover effects
class QuickActionsGrid extends StatefulWidget {
  /// List of quick actions to display
  final List<QuickAction> actions;
  
  /// Section title
  final String title;
  
  /// Enable stagger animation on initial load
  final bool enableStaggerAnimation;
  
  /// Custom grid spacing
  final double? gridSpacing;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.title = 'Quick Actions',
    this.enableStaggerAnimation = true,
    this.gridSpacing,
  });

  @override
  State<QuickActionsGrid> createState() => _QuickActionsGridState();
}

class _QuickActionsGridState extends State<QuickActionsGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _cardControllers;
  late AnimationController _titleController;

  @override
  void initState() {
    super.initState();
    
    _titleController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _cardControllers = List.generate(
      widget.actions.length,
      (index) => AnimationController(
        duration: AppDurations.medium,
        vsync: this,
      ),
    );
    
    if (widget.enableStaggerAnimation) {
      _startStaggerAnimation();
    } else {
      _titleController.value = 1.0;
      for (var controller in _cardControllers) {
        controller.value = 1.0;
      }
    }
  }

  void _startStaggerAnimation() {
    _titleController.forward();
    
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + (i * 100)), () {
        if (mounted) {
          _cardControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = widget.gridSpacing ?? AppDimensions.spacingM;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: AppDimensions.spacingL),
        _buildActionsGrid(spacing),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Text(
          '⚡',
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
    )
        .animate(controller: _titleController)
        .fadeIn(duration: AppDurations.medium)
        .slideX(begin: -0.3, end: 0.0, duration: AppDurations.medium);
  }

  Widget _buildActionsGrid(double spacing) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.1,
      ),
      itemCount: widget.actions.length,
      itemBuilder: (context, index) {
        final action = widget.actions[index];
        return _buildActionCard(action, index);
      },
    );
  }

  Widget _buildActionCard(QuickAction action, int index) {
    return AnimatedBuilder(
      animation: _cardControllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardControllers[index].value,
          child: Transform.translate(
            offset: Offset(
              0,
              (1 - _cardControllers[index].value) * 20,
            ),
            child: Opacity(
              opacity: _cardControllers[index].value,
              child: QuickActionCard(
                action: action,
                animationDelay: Duration(milliseconds: index * 100),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Individual quick action card with premium badge and hover effects
class QuickActionCard extends StatefulWidget {
  /// The action to display
  final QuickAction action;
  
  /// Animation delay for entrance
  final Duration animationDelay;
  
  /// Custom card height
  final double? height;

  const QuickActionCard({
    super.key,
    required this.action,
    this.animationDelay = Duration.zero,
    this.height,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _hoverScale;
  late Animation<double> _tapScale;
  late Animation<double> _shadowAnimation;
  
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: AppDurations.cardHover,
      vsync: this,
    );
    
    _tapController = AnimationController(
      duration: AppDurations.cardTap,
      vsync: this,
    );
    
    _hoverScale = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _tapScale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeOut,
    ));
    
    _shadowAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.action.isEnabled) return;
    
    _tapController.forward().then((_) {
      _tapController.reverse();
    });
    
    HapticFeedback.lightImpact();
    
    // Small delay to show the tap animation
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.action.onTap();
    });
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
          animation: Listenable.merge([_hoverScale, _tapScale, _shadowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _hoverScale.value * _tapScale.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.action.isPremium
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.lavenderMistLight.withOpacity( 0.1),
                            AppColors.sageGreenWithOpacity(0.1),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.pearlWhite,
                            AppColors.warmCream,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                  border: Border.all(
                    color: widget.action.isPremium
                        ? AppColors.lavenderMist.withOpacity( 0.3)
                        : AppColors.sageGreenWithOpacity(0.1),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: _shadowAnimation.value,
                      offset: Offset(0, _shadowAnimation.value / 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    _buildCardContent(),
                    if (widget.action.isPremium) _buildPremiumBadge(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(height: AppDimensions.spacingS),
          _buildTitle(),
          const SizedBox(height: AppDimensions.spacingXS),
          _buildSubtitle(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _isHovered 
            ? AppColors.sageGreenWithOpacity(0.15)
            : AppColors.sageGreenWithOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Center(
        child: Text(
          widget.action.icon,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    )
        .animate(target: _isHovered ? 1.0 : 0.0)
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.1, 1.1),
          duration: AppDurations.fast,
        );
  }

  Widget _buildTitle() {
    return Text(
      widget.action.title,
      style: AppTextStyles.titleMedium.copyWith(
        color: widget.action.isEnabled 
            ? AppColors.softCharcoal 
            : AppColors.softCharcoalLight,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      widget.action.subtitle,
      style: AppTextStyles.bodySmall.copyWith(
        color: widget.action.isEnabled 
            ? AppColors.softCharcoalLight 
            : AppColors.stoneGray,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPremiumBadge() {
    return Positioned(
      top: AppDimensions.spacingS,
      right: AppDimensions.spacingS,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lavenderMist,
              AppColors.warmPeach,
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          boxShadow: [
            BoxShadow(
              color: AppColors.lavenderMist.withOpacity( 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Text(
          '✨',
          style: TextStyle(fontSize: 12),
        ),
      ),
    )
        .animate(delay: widget.animationDelay + 300.ms)
        .scale(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 1.0),
          duration: AppDurations.medium,
          curve: Curves.elasticOut,
        );
  }
}

/// Simplified quick action card for compact layouts
class CompactQuickActionCard extends StatelessWidget {
  /// The action to display
  final QuickAction action;
  
  /// Custom width
  final double? width;

  const CompactQuickActionCard({
    super.key,
    required this.action,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.isEnabled ? action.onTap : null,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          gradient: action.isPremium
              ? LinearGradient(
                  colors: [
                    AppColors.lavenderMistLight.withOpacity( 0.1),
                    AppColors.sageGreenWithOpacity(0.1),
                  ],
                )
              : null,
          color: action.isPremium ? null : AppColors.warmCreamAlt,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: action.isPremium
                ? AppColors.lavenderMist.withOpacity( 0.3)
                : AppColors.sageGreenWithOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              action.icon,
              style: const TextStyle(fontSize: 20),
            ),
            if (width == null) ...[
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (action.isPremium)
                      Text(
                        'Premium',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.lavenderMist,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}