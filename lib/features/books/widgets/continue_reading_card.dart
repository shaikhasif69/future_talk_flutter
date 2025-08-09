import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/book_model.dart';

/// Continue reading card with progress tracking and partner sync
class ContinueReadingCard extends StatefulWidget {
  final ReadingProgress progress;
  final VoidCallback onContinue;

  const ContinueReadingCard({
    super.key,
    required this.progress,
    required this.onContinue,
  });

  @override
  State<ContinueReadingCard> createState() => _ContinueReadingCardState();
}

class _ContinueReadingCardState extends State<ContinueReadingCard>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Progress bar animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    final progressValue = widget.progress.currentPage / widget.progress.totalPages;
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: progressValue,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    // Sync status pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    if (widget.progress.isSynced) {
      _pulseController.repeat();
    }
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: AppDimensions.spacingL),
        _buildReadingCard(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Continue Reading',
          style: AppTextStyles.featureHeading,
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            // TODO: Navigate to all reading progress
          },
          child: Text(
            'See all',
            style: AppTextStyles.link.copyWith(
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingCard() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onContinue();
      },
      child: FTCard.elevated(
        backgroundColor: AppColors.pearlWhite,
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            // Progress indicator at top
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whisperGray,
                borderRadius: BorderRadius.circular(1.5),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * _progressAnimation.value,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Book info and progress
            Row(
              children: [
                _buildBookCover(),
                const SizedBox(width: AppDimensions.spacingL),
                Expanded(child: _buildBookInfo()),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Partner info section
            if (widget.progress.partner != null) _buildPartnerInfo(),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildBookCover() {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.dustyRose,
                AppColors.lavenderMist,
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Center(
            child: Text(
              widget.progress.coverEmoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),

        // Reading streak badge
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.warmPeach,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.pearlWhite, width: 2),
            ),
            child: Center(
              child: Text(
                widget.progress.readingStreak.toString(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.pearlWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.progress.bookTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontFamily: AppTextStyles.personalFont,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingXS),

        // Reading meta info
        Row(
          children: [
            _buildMetaChip(
              '📖 ${widget.progress.minutesLeft} min left',
              AppColors.cloudBlue,
            ),
            const SizedBox(width: AppDimensions.spacingS),
            _buildMetaChip(
              '${widget.progress.mood.emoji} ${widget.progress.mood.displayName}',
              AppColors.warmPeach,
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingS),

        // Progress bar
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.whisperGray,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 120) * _progressAnimation.value,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Chapter ${widget.progress.currentChapter} of ${widget.progress.totalChapters} • ${(_progressAnimation.value * 100).toInt()}% complete',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetaChip(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: backgroundColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPartnerInfo() {
    final partner = widget.progress.partner!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.whisperGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Partner avatar
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.warmPeach,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    partner.avatarInitial,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.pearlWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppDimensions.spacingS),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reading with ${partner.name}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Page ${partner.currentPage}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.softCharcoalLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Sync status
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingS,
                    vertical: AppDimensions.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: widget.progress.isSynced 
                        ? AppColors.sageGreen.withValues(alpha: 0.1)
                        : AppColors.dustyRose.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.progress.isSynced ? 'In sync' : 'Syncing',
                        style: AppTextStyles.caption.copyWith(
                          color: widget.progress.isSynced 
                              ? AppColors.sageGreen 
                              : AppColors.dustyRose,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingXS),
                      Text(
                        widget.progress.isSynced ? '✨' : '⏳',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}