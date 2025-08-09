import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/book_model.dart';

/// Mood selector widget for personalized book recommendations
class MoodSelector extends StatefulWidget {
  final ReadingMood selectedMood;
  final ValueChanged<ReadingMood> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector>
    with TickerProviderStateMixin {
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _selectionAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  void _onMoodTapped(ReadingMood mood) {
    if (mood != widget.selectedMood) {
      HapticFeedback.selectionClick();
      _selectionController.forward().then((_) {
        _selectionController.reverse();
      });
      widget.onMoodSelected(mood);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTCard.flat(
      backgroundColor: AppColors.pearlWhite,
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppDimensions.spacingL),
          _buildMoodOptions(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: AppTextStyles.titleLarge.copyWith(
            fontFamily: AppTextStyles.headingFont,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          'We\'ll suggest books that match your current energy',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodOptions() {
    final moods = ReadingMood.values;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: moods.asMap().entries.map((entry) {
          final index = entry.key;
          final mood = entry.value;
          final isSelected = mood == widget.selectedMood;
          
          return Padding(
            padding: EdgeInsets.only(
              right: index < moods.length - 1 ? AppDimensions.spacingM : 0,
            ),
            child: _buildMoodChip(mood, isSelected, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMoodChip(ReadingMood mood, bool isSelected, int index) {
    return AnimatedBuilder(
      animation: _selectionAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _selectionAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _onMoodTapped(mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minWidth: 80),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingM,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.sageGreen : AppColors.warmCream,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.sageGreen : AppColors.whisperGray,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.sageGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 20,
                    ),
                    child: Text(mood.emoji),
                  ),
                  const SizedBox(height: AppDimensions.spacingXS),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.pearlWhite : AppColors.softCharcoal,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    child: Text(mood.displayName),
                  ),
                ],
              ),
            ),
          ).animate(delay: (100 + index * 50).ms)
            .fadeIn(duration: 300.ms)
            .slideX(begin: 0.3, end: 0),
        );
      },
    );
  }
}