import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/layouts/ft_scaffold_with_nav.dart';

/// Time Capsules screen - magical time travel messages
class TimeCapsulsScreen extends ConsumerWidget {
  const TimeCapsulsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTScaffoldWithNav(
      currentIndex: 0,
      showBottomNav: true,
      floatingNav: true,
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              size: 80,
              color: AppColors.sageGreen,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'Time Capsules',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Your magical messages across time',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}