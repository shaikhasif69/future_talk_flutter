import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/layouts/ft_scaffold_with_nav.dart';

/// Read tab placeholder screen
/// Temporary implementation until actual reading feature is developed
class ReadTabScreen extends ConsumerWidget {
  const ReadTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTScaffold(
      showAppBar: false,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.screenPadding),
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated book icon
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.warmPeach.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 60.w,
                color: AppColors.warmPeach,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingXXL),
            
            // Title
            Text(
              'Parallel Reading',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingM),
            
            // Subtitle
            Text(
              'Read together, think deeply',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.softCharcoalLight,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
              child: Text(
                'Share the joy of reading with friends. Discuss insights, exchange thoughts, and discover new perspectives together.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.softCharcoalLight.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingXXXL),
            
            // Feature highlights
            _buildFeatureCard(
              context,
              icon: Icons.people_rounded,
              title: 'Reading Groups',
              description: 'Join cozy reading circles',
              color: AppColors.cloudBlue,
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            _buildFeatureCard(
              context,
              icon: Icons.chat_rounded,
              title: 'Thoughtful Discussions',
              description: 'Share insights and reflections',
              color: AppColors.sageGreen,
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            _buildFeatureCard(
              context,
              icon: Icons.bookmark_rounded,
              title: 'Personal Library',
              description: 'Track your reading journey',
              color: AppColors.dustyRose,
            ),
            
            SizedBox(height: AppDimensions.spacingXXL),
            
            // Coming soon card
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                border: Border.all(
                  color: AppColors.warmPeach.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: AppDimensions.iconS,
                    color: AppColors.warmPeach,
                  ),
                  SizedBox(width: AppDimensions.spacingS),
                  Text(
                    'Coming Soon',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.warmPeach,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconS,
              color: color,
            ),
          ),
          SizedBox(width: AppDimensions.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.softCharcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}