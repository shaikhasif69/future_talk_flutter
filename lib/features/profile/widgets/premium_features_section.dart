import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/profile_data.dart';

/// Premium features showcase section with magical gradient backgrounds
/// Displays Connection Stones, Parallel Reading, and Premium Games
class PremiumFeaturesSection extends StatefulWidget {
  final PremiumFeatures premiumFeatures;
  final EdgeInsetsGeometry? margin;

  const PremiumFeaturesSection({
    super.key,
    required this.premiumFeatures,
    this.margin,
  });

  @override
  State<PremiumFeaturesSection> createState() => _PremiumFeaturesSectionState();
}

class _PremiumFeaturesSectionState extends State<PremiumFeaturesSection>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    // Start shimmer animation
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(screenWidth),
      ).copyWith(bottom: AppDimensions.spacingL),
      child: _buildPremiumCard(),
    ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lavenderMist,
            AppColors.dustyRose,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.lavenderMist.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Shimmer overlay effect
          _buildShimmerOverlay(),
          
          // Magic sparkle
          Positioned(
            top: 16,
            right: 16,
            child: Text(
              '✨',
              style: const TextStyle(
                fontSize: 24,
                height: 1.0,
              ),
            ).animate(delay: 600.ms)
             .fadeIn(duration: 800.ms)
             .scale(begin: const Offset(0.5, 0.5))
             .then()
             .shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.5)),
          ),
          
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumHeader(),
              SizedBox(height: AppDimensions.spacingL),
              _buildPremiumFeaturesList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerOverlay() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
                stops: [
                  0.0,
                  _shimmerAnimation.value,
                  1.0,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Sanctuary',
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.white,
            fontFamily: AppTextStyles.headingFont,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
        
        SizedBox(height: AppDimensions.spacingXS),
        
        Text(
          'Your premium features for deeper connections',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 13,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 600.ms).slideX(begin: -0.3),
      ],
    );
  }

  Widget _buildPremiumFeaturesList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: '🪨',
          title: 'Connection Stones',
          description: '${widget.premiumFeatures.connectionStones.customStones} custom stones • ${widget.premiumFeatures.connectionStones.comfortTouchesGiven} comfort touches given',
          delay: 200,
        ),
        
        SizedBox(height: AppDimensions.spacingM),
        
        _buildFeatureItem(
          icon: '📚',
          title: 'Parallel Reading',
          description: 'Currently reading with ${widget.premiumFeatures.parallelReading.currentlyReadingWith} friends',
          delay: 300,
        ),
        
        SizedBox(height: AppDimensions.spacingM),
        
        _buildFeatureItem(
          icon: '🎮',
          title: 'Premium Games',
          description: '${widget.premiumFeatures.premiumGames.gamesUnlocked} games unlocked • Thoughtful entertainment',
          delay: 400,
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Feature icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.0,
                ),
              ),
            ),
          ),
          
          SizedBox(width: AppDimensions.spacingM),
          
          // Feature details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXS),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay))
     .fadeIn(duration: 600.ms)
     .slideX(begin: 0.3);
  }
}

/// Compact premium badge for use in headers or other contexts
class PremiumBadge extends StatelessWidget {
  final bool isPremium;
  final DateTime? expiryDate;
  final VoidCallback? onTap;

  const PremiumBadge({
    super.key,
    required this.isPremium,
    this.expiryDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPremium) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXS,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lavenderMist,
              AppColors.dustyRose,
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.lavenderMist.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '✨',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(width: AppDimensions.spacingXS),
            Text(
              'Premium',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium feature card for individual features
class PremiumFeatureCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description;
  final String? value;
  final VoidCallback? onTap;
  final Color? accentColor;

  const PremiumFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.value,
    this.onTap,
    this.accentColor,
  });

  @override
  State<PremiumFeatureCard> createState() => _PremiumFeatureCardState();
}

class _PremiumFeatureCardState extends State<PremiumFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
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
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
    final accentColor = widget.accentColor ?? AppColors.lavenderMist;
    
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      AppColors.warmCream,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.1 + (_glowAnimation.value * 0.2)),
                      blurRadius: 8 + (_glowAnimation.value * 8),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        
                        if (widget.value != null) ...[
                          const Spacer(),
                          Text(
                            widget.value!,
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    SizedBox(height: AppDimensions.spacingM),
                    
                    Text(
                      widget.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    SizedBox(height: AppDimensions.spacingXS),
                    
                    Text(
                      widget.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
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

/// Non-premium user upgrade prompt
class UpgradeToPremiumCard extends StatelessWidget {
  final VoidCallback? onUpgradePressed;

  const UpgradeToPremiumCard({
    super.key,
    this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen.withValues(alpha: 0.1),
            AppColors.lavenderMist.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: AppColors.sageGreen.withValues(alpha: 0.3),
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
              onPressed: onUpgradePressed,
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
    );
  }
}