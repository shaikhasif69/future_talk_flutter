import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/book_model.dart';

/// Reading statistics bar with premium design
class ReadingStatsBar extends StatelessWidget {
  final ReadingStats stats;

  const ReadingStatsBar({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        0,
        AppDimensions.screenPadding,
        AppDimensions.spacingL,
      ),
      transform: Matrix4.translationValues(0, -20, 0), // Proper half overlap with header
      child: FTCard.elevated(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingXL,
          horizontal: AppDimensions.spacingM,
        ),
        backgroundColor: AppColors.pearlWhite,
        elevation: 8,
        child: Row(
          children: [
            _buildStatItem(
              value: stats.booksRead.toString(),
              label: 'Books Read',
              index: 0,
            ),
            _buildStatItem(
              value: stats.currentStreak.toString(),
              label: 'Day Streak',
              index: 1,
            ),
            _buildStatItem(
              value: stats.friendsReading.toString(),
              label: 'Friends\nReading',
              index: 2,
            ),
            _buildStatItem(
              value: '${stats.hoursThisMonth}h',
              label: 'This Month',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required int index,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.sageGreen,
              fontFamily: AppTextStyles.headingFont,
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ).animate().fadeIn(delay: (200 + index * 100).ms)
            .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0)),
          
          const SizedBox(height: AppDimensions.spacingXS),
          
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCharcoalLight,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: (300 + index * 100).ms)
            .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

}