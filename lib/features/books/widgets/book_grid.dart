import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/book_model.dart';

/// Magazine-style book grid with premium design and comfort indicators
class BookGrid extends StatefulWidget {
  final List<Book> books;
  final ValueChanged<Book> onBookTapped;

  const BookGrid({
    super.key,
    required this.books,
    required this.onBookTapped,
  });

  @override
  State<BookGrid> createState() => _BookGridState();
}

class _BookGridState extends State<BookGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _hoverControllers;
  late List<Animation<double>> _hoverAnimations;

  @override
  void initState() {
    super.initState();
    _initializeHoverAnimations();
  }

  void _initializeHoverAnimations() {
    _hoverControllers = List.generate(
      widget.books.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _hoverAnimations = _hoverControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _hoverControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingL,
        mainAxisSpacing: AppDimensions.spacingL,
        childAspectRatio: 0.8, // Optimized ratio to prevent overflow
      ),
      itemCount: widget.books.length,
      itemBuilder: (context, index) {
        final book = widget.books[index];
        return _buildBookCard(book, index);
      },
    );
  }

  Widget _buildBookCard(Book book, int index) {
    return AnimatedBuilder(
      animation: _hoverAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimations[index].value,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onBookTapped(book);
            },
            onTapDown: (_) => _hoverControllers[index].forward(),
            onTapUp: (_) => _hoverControllers[index].reverse(),
            onTapCancel: () => _hoverControllers[index].reverse(),
            child: FTCard.elevated(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              backgroundColor: AppColors.pearlWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Book cover with badges
                  _buildBookCover(book),
                  
                  const SizedBox(height: AppDimensions.spacingS),
                  
                  // Book details
                  _buildBookDetails(book),
                ],
              ),
            ),
          ).animate(delay: (100 + index * 100).ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.3, end: 0),
        );
      },
    );
  }

  Widget _buildBookCover(Book book) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: _getCoverGradient(book.id),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main cover content
          Center(
            child: Text(
              book.coverEmoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),

          // Premium/Free badge
          Positioned(
            top: 8,
            right: 8,
            child: _buildPremiumBadge(book.isPremium),
          ),

          // Comfort level badge
          Positioned(
            top: 8,
            left: 8,
            child: _buildComfortBadge(book.comfortLevel),
          ),

          // Parallel reading indicator
          if (book.isAvailableForParallel)
            Positioned(
              bottom: 8,
              left: 8,
              child: _buildParallelBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadge(bool isPremium) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isPremium ? AppColors.warmPeach : AppColors.sageGreen,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        isPremium ? 'Premium' : 'Free',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.pearlWhite,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildComfortBadge(BookComfortLevel comfortLevel) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.softCharcoal.withAlpha(179),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
      ),
      child: Text(
        comfortLevel.displayName,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.pearlWhite,
          fontWeight: FontWeight.w500,
          fontSize: 8,
        ),
      ),
    );
  }

  Widget _buildParallelBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cloudBlue.withAlpha(230),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.people_rounded,
        size: 12,
        color: AppColors.pearlWhite,
      ),
    );
  }

  Widget _buildBookDetails(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title and author
        Text(
          book.title,
          style: AppTextStyles.titleMedium.copyWith(
            fontFamily: AppTextStyles.personalFont,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: AppDimensions.spacingXS),
        
        Text(
          book.author,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: AppDimensions.spacingXS),

        // Rating and duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (book.rating > 0) ...[
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 2),
                    Text(
                      book.rating.toString(),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            if (book.durationHours > 0) ...[
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🕐', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 2),
                    Text(
                      '${book.durationHours}h',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        if (book.tags.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingXS),
          _buildBookTags(book.tags),
        ],
      ],
    );
  }

  Widget _buildBookTags(List<String> tags) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.take(2).map((tag) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXS,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.warmCream,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
        ),
        child: Text(
          tag,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.softCharcoalLight,
            fontSize: 9,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '📚',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Text(
            'No books found',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.softCharcoal,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Try adjusting your mood or category',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  LinearGradient _getCoverGradient(String bookId) {
    // Generate consistent gradients based on book ID
    final gradients = [
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lavenderMist, AppColors.dustyRose],
      ),
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.cloudBlue, AppColors.lavenderMist],
      ),
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.warmPeach, AppColors.dustyRose],
      ),
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.sageGreenLight, AppColors.cloudBlue],
      ),
    ];
    
    final hash = bookId.hashCode.abs();
    return gradients[hash % gradients.length];
  }
}