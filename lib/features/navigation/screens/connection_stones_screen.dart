import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/layouts/ft_scaffold_with_nav.dart';

/// Connection Stones screen - mystical connection experiences
class ConnectionStonesScreen extends ConsumerWidget {
  const ConnectionStonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTScaffold(
      backgroundColor: AppColors.warmCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.scatter_plot,
              size: 80,
              color: AppColors.dustyRose,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'Connection Stones',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Feel the mystical connections',
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