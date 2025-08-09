import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/book_model.dart';

/// AI-powered book recommendation banner with magical feel
class AIRecommendationBanner extends StatefulWidget {
  final BookRecommendation recommendation;
  final VoidCallback onTap;

  const AIRecommendationBanner({
    super.key,
    required this.recommendation,
    required this.onTap,
  });

  @override
  State<AIRecommendationBanner> createState() => _AIRecommendationBannerState();
}

class _AIRecommendationBannerState extends State<AIRecommendationBanner>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lavenderMist,
              AppColors.dustyRose,
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.lavenderMist.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Shimmer effect
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          AppColors.pearlWhite.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                        stops: [
                          0.0,
                          _shimmerController.value,
                          1.0,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Floating sparkles
            Positioned(
              top: 12,
              right: 16,
              child: AnimatedBuilder(
                animation: _sparkleAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: (0.5 + 0.5 * _sparkleAnimation.value),
                    child: Transform.rotate(
                      angle: _sparkleAnimation.value * 2 * 3.14159,
                      child: const Text(
                        '✨',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI Badge and Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingS,
                          vertical: AppDimensions.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pearlWhite.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🤖', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: AppDimensions.spacingXS),
                            Text(
                              'AI Curated',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.pearlWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingS),

                  Text(
                    'Perfect for You Right Now',
                    style: AppTextStyles.featureHeading.copyWith(
                      color: AppColors.pearlWhite,
                      fontFamily: AppTextStyles.headingFont,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingXS),

                  Text(
                    'Based on ${widget.recommendation.basedOn}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.pearlWhite.withValues(alpha: 0.9),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingM),

                  // Book suggestion card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    decoration: BoxDecoration(
                      color: AppColors.pearlWhite.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Book cover emoji
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.pearlWhite.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                              ),
                              child: Center(
                                child: Text(
                                  widget.recommendation.coverEmoji.isNotEmpty
                                      ? widget.recommendation.coverEmoji
                                      : '📖',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),

                            const SizedBox(width: AppDimensions.spacingM),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.recommendation.title,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: AppColors.pearlWhite,
                                      fontFamily: AppTextStyles.personalFont,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimensions.spacingXS),
                                  Text(
                                    'by ${widget.recommendation.author}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.pearlWhite.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Confidence indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingS,
                                vertical: AppDimensions.spacingXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warmPeach.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                              ),
                              child: Text(
                                '${(widget.recommendation.confidenceScore * 100).toInt()}%',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.pearlWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppDimensions.spacingS),

                        Text(
                          widget.recommendation.reason,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.pearlWhite.withValues(alpha: 0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
    );
  }
}