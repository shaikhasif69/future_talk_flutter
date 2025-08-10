import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/profile_data.dart';

/// Profile statistics section showing user's journey metrics
/// Features animated counters and beautiful visual hierarchy
class ProfileStatsSection extends StatefulWidget {
  final ProfileStats stats;
  final EdgeInsetsGeometry? margin;

  const ProfileStatsSection({
    super.key,
    required this.stats,
    this.margin,
  });

  @override
  State<ProfileStatsSection> createState() => _ProfileStatsSectionState();
}

class _ProfileStatsSectionState extends State<ProfileStatsSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _counterControllers;
  late List<Animation<int>> _counterAnimations;
  
  final List<int> _targetValues = [];
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    
    // Set up target values
    _targetValues.addAll([
      widget.stats.timeCapsulesSent,
      widget.stats.booksRead,
      widget.stats.dayStreak,
      widget.stats.deepChats,
    ]);
    
    // Initialize animation controllers
    _counterControllers = List.generate(
      _targetValues.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1200 + (index * 200)),
        vsync: this,
      ),
    );
    
    // Initialize counter animations
    _counterAnimations = _counterControllers
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return IntTween(
            begin: 0,
            end: _targetValues[index],
          ).animate(CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ));
        })
        .toList();
    
    // Start animations after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasAnimated) {
        _startCounterAnimations();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _counterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startCounterAnimations() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    
    for (int i = 0; i < _counterControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _counterControllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(screenWidth),
      ).copyWith(bottom: AppDimensions.spacingL),
      child: FTCard.elevated(
        child: Column(
          children: [
            _buildStatsHeader(),
            SizedBox(height: AppDimensions.spacingL),
            _buildStatsGrid(),
          ],
        ),
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildStatsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Your Journey',
          style: AppTextStyles.headlineSmall.copyWith(
            fontFamily: AppTextStyles.headingFont,
            color: AppColors.softCharcoal,
          ),
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingS,
            vertical: AppDimensions.spacingXS,
          ),
          decoration: BoxDecoration(
            color: AppColors.sageGreen.withAlpha(26),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Text(
            widget.stats.periodDescription,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.sageGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppDimensions.spacingM,
      mainAxisSpacing: AppDimensions.spacingM,
      childAspectRatio: 1.2,
      children: [
        _buildStatItem(
          index: 0,
          label: 'Time Capsules',
          sublabel: 'Sent to future',
          icon: '💌',
          color: AppColors.lavenderMist,
        ),
        _buildStatItem(
          index: 1,
          label: 'Books Read',
          sublabel: 'Peaceful hours',
          icon: '📚',
          color: AppColors.cloudBlue,
        ),
        _buildStatItem(
          index: 2,
          label: 'Day Streak',
          sublabel: 'Mindful check-ins',
          icon: '🔥',
          color: AppColors.warmPeach,
        ),
        _buildStatItem(
          index: 3,
          label: 'Deep Chats',
          sublabel: 'Meaningful talks',
          icon: '💬',
          color: AppColors.sageGreen,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required int index,
    required String label,
    required String sublabel,
    required String icon,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _counterAnimations[index],
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.warmCream,
                AppColors.pearlWhite,
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: color.withAlpha(26),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(13),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with subtle background
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacingS),
              
              // Animated counter
              Text(
                '${_counterAnimations[index].value}',
                style: AppTextStyles.displaySmall.copyWith(
                  color: color,
                  fontFamily: AppTextStyles.headingFont,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
              ),
              
              SizedBox(height: AppDimensions.spacingXS),
              
              // Label
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Sublabel
              Text(
                sublabel,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    ).animate(delay: Duration(milliseconds: 300 + (index * 100)))
     .fadeIn(duration: 600.ms)
     .scale(begin: const Offset(0.8, 0.8));
  }
}

/// Compact stats widget for use in other contexts
class CompactProfileStats extends StatelessWidget {
  final ProfileStats stats;
  final bool showPeriod;

  const CompactProfileStats({
    super.key,
    required this.stats,
    this.showPeriod = true,
  });

  @override
  Widget build(BuildContext context) {
    return FTCard.flat(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        children: [
          if (showPeriod) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Journey',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  stats.periodDescription,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.sageGreen,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingM),
          ],
          
          Row(
            children: [
              _buildCompactStat('💌', '${stats.timeCapsulesSent}', 'Capsules'),
              const Spacer(),
              _buildCompactStat('📚', '${stats.booksRead}', 'Books'),
              const Spacer(),
              _buildCompactStat('🔥', '${stats.dayStreak}', 'Streak'),
              const Spacer(),
              _buildCompactStat('💬', '${stats.deepChats}', 'Chats'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(String icon, String value, String label) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 16),
        ),
        SizedBox(height: AppDimensions.spacingXS),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.sageGreen,
            fontWeight: FontWeight.w600,
          ),
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

/// Individual stat card for detailed views
class StatCard extends StatefulWidget {
  final String icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
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
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: widget.color.withAlpha(51),
                    width: _isHovered ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withAlpha(26),
                      blurRadius: _elevationAnimation.value,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: AppDimensions.spacingS),
                    Text(
                      widget.value,
                      style: AppTextStyles.displaySmall.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingXS),
                    Text(
                      widget.title,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.subtitle,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}