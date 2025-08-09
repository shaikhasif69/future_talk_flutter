import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/book_model.dart';

/// Friends reading section with real-time status and join capabilities
class FriendsReadingSection extends StatefulWidget {
  final List<FriendReading> friends;
  final Function(String friendId, String bookTitle) onJoinReading;

  const FriendsReadingSection({
    super.key,
    required this.friends,
    required this.onJoinReading,
  });

  @override
  State<FriendsReadingSection> createState() => _FriendsReadingSectionState();
}

class _FriendsReadingSectionState extends State<FriendsReadingSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _pulseControllers;
  late List<Animation<double>> _pulseAnimations;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimations();
  }

  void _initializePulseAnimations() {
    _pulseControllers = List.generate(
      widget.friends.length,
      (index) => AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      ),
    );

    _pulseAnimations = _pulseControllers.map((controller) {
      return Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Start pulse animation for online friends
    for (int i = 0; i < widget.friends.length; i++) {
      if (widget.friends[i].status == FriendActivityStatus.reading) {
        _pulseControllers[i].repeat();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _pulseControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.friends.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: AppDimensions.spacingL),
        _buildFriendsList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Friends are Reading',
          style: AppTextStyles.featureHeading,
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            // TODO: Navigate to all friends reading
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

  Widget _buildFriendsList() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: widget.friends.length,
        separatorBuilder: (context, index) => 
            const SizedBox(width: AppDimensions.spacingM),
        itemBuilder: (context, index) {
          final friend = widget.friends[index];
          return _buildFriendCard(friend, index);
        },
      ),
    );
  }

  Widget _buildFriendCard(FriendReading friend, int index) {
    return SizedBox(
      width: 200,
      height: 240, // Fixed height to prevent overflow
      child: FTCard.elevated(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        backgroundColor: AppColors.pearlWhite,
        child: Stack(
          children: [
            // Status indicator
            Positioned(
              top: 0,
              right: 0,
              child: _buildStatusIndicator(friend, index),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Friend header
                _buildFriendHeader(friend),

                const SizedBox(height: AppDimensions.spacingM),

                // Book info
                Flexible(child: _buildBookInfo(friend)),

                const SizedBox(height: AppDimensions.spacingM),

                // Action button
                _buildActionButton(friend),
              ],
            ),
          ],
        ),
      ).animate(delay: (100 + index * 150).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.3, end: 0),
    );
  }

  Widget _buildStatusIndicator(FriendReading friend, int index) {
    if (friend.status != FriendActivityStatus.reading) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: _getStatusColor(friend.status),
          shape: BoxShape.circle,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _pulseAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimations[index].value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(friend.status),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor(friend.status).withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendHeader(FriendReading friend) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getAvatarColor(friend.friendId),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              friend.avatarInitial,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pearlWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: AppDimensions.spacingS),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.friendName,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Row(
                children: [
                  Text(
                    friend.status.emoji,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: AppDimensions.spacingXS),
                  Expanded(
                    child: Text(
                      friend.status.displayName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookInfo(FriendReading friend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          friend.bookTitle,
          style: AppTextStyles.bodyMedium.copyWith(
            fontFamily: AppTextStyles.personalFont,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          'by ${friend.bookAuthor}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          '${friend.currentChapter} • ${friend.timeAgo}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(FriendReading friend) {
    String buttonText;
    bool isEnabled;
    Color buttonColor;

    switch (friend.status) {
      case FriendActivityStatus.reading:
        buttonText = 'Join Reading';
        isEnabled = friend.canJoin;
        buttonColor = AppColors.sageGreen;
        break;
      case FriendActivityStatus.recentlyActive:
        buttonText = friend.isOpenForPartners ? 'Send Request' : 'Not Available';
        isEnabled = friend.isOpenForPartners;
        buttonColor = AppColors.cloudBlue;
        break;
      case FriendActivityStatus.recharging:
        buttonText = 'Respect space';
        isEnabled = false;
        buttonColor = AppColors.dustyRose;
        break;
      case FriendActivityStatus.offline:
        buttonText = 'Offline';
        isEnabled = false;
        buttonColor = AppColors.stoneGray;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? () {
          HapticFeedback.lightImpact();
          widget.onJoinReading(friend.friendId, friend.bookTitle);
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? buttonColor : AppColors.stoneGray,
          foregroundColor: AppColors.pearlWhite,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          elevation: isEnabled ? 2 : 0,
        ),
        child: Text(
          buttonText,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.pearlWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(FriendActivityStatus status) {
    switch (status) {
      case FriendActivityStatus.reading:
        return const Color(0xFF4CAF50); // Green
      case FriendActivityStatus.recentlyActive:
        return const Color(0xFFFFC107); // Amber
      case FriendActivityStatus.recharging:
        return AppColors.dustyRose;
      case FriendActivityStatus.offline:
        return AppColors.stoneGray;
    }
  }

  Color _getAvatarColor(String friendId) {
    // Generate consistent colors based on friend ID
    final colors = [
      AppColors.cloudBlue,
      AppColors.warmPeach,
      AppColors.lavenderMist,
      AppColors.sageGreenLight,
      AppColors.dustyRose,
    ];
    
    final hash = friendId.hashCode.abs();
    return colors[hash % colors.length];
  }
}