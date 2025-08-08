import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/layouts/ft_scaffold_with_nav.dart';

/// Chat tab placeholder screen
/// Temporary implementation until actual chat feature is developed
class ChatTabScreen extends ConsumerWidget {
  const ChatTabScreen({super.key});

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
            // Animated chat icon
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.cloudBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_rounded,
                size: 60.w,
                color: AppColors.cloudBlue,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingXXL),
            
            // Title
            Text(
              'Chat',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingM),
            
            // Subtitle
            Text(
              'Thoughtful conversations await',
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
                'Connect with others at your own pace. No pressure, just meaningful exchanges when you\'re ready.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.softCharcoalLight.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingXXXL),
            
            // Coming soon card
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                border: Border.all(
                  color: AppColors.cloudBlue.withOpacity(0.2),
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
                    color: AppColors.cloudBlue,
                  ),
                  SizedBox(width: AppDimensions.spacingS),
                  Text(
                    'Coming Soon',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.cloudBlue,
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
}