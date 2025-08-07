import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/layouts/ft_scaffold_with_nav.dart';

/// Parallel Reading screen - synchronized reading journeys
class ParallelReadingScreen extends ConsumerWidget {
  const ParallelReadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTScaffoldWithNav(
      currentIndex: 3,
      showBottomNav: true,
      floatingNav: true,
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 80,
              color: AppColors.lavenderMist,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'Parallel Reading',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Synchronized reading journeys together',
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