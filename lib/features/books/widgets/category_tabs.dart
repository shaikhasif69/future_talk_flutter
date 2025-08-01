import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Category tabs for book filtering with personality
class CategoryTabs extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs>
    with TickerProviderStateMixin {
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _selectionAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _onCategoryTapped(String category) {
    if (category != widget.selectedCategory) {
      HapticFeedback.selectionClick();
      _selectionController.forward().then((_) {
        _selectionController.reverse();
      });
      widget.onCategorySelected(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: widget.categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = category == widget.selectedCategory;
            
            return Padding(
              padding: EdgeInsets.only(
                right: index < widget.categories.length - 1 
                    ? AppDimensions.spacingM 
                    : 0,
              ),
              child: _buildCategoryTab(category, isSelected, index),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String category, bool isSelected, int index) {
    return AnimatedBuilder(
      animation: _selectionAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _selectionAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _onCategoryTapped(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.sageGreen : AppColors.pearlWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.sageGreen : AppColors.whisperGray,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.sageGreen.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ] : [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getCategoryEmoji(category),
                    style: TextStyle(
                      fontSize: isSelected ? 16 : 14,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? AppColors.pearlWhite : AppColors.softCharcoal,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    child: Text(category),
                  ),
                ],
              ),
            ),
          ).animate(delay: (100 + index * 75).ms)
            .fadeIn(duration: 300.ms)
            .slideX(begin: 0.2, end: 0),
        );
      },
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category) {
      case 'For You':
        return '✨';
      case 'Romance':
        return '💝';
      case 'Growth':
        return '🌱';
      case 'Classics':
        return '📚';
      case 'Poetry':
        return '🎭';
      case 'Mindful':
        return '🧘';
      case 'Adventure':
        return '🗺️';
      case 'Mystery':
        return '🔍';
      case 'Fantasy':
        return '🏰';
      case 'Biography':
        return '👤';
      case 'Science':
        return '🔬';
      case 'History':
        return '📜';
      default:
        return '📖';
    }
  }
}