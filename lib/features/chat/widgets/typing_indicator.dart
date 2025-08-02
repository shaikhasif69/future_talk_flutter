import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';

/// Premium typing indicator with smooth animations and participant name
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    required this.userName,
    this.showUserName = true,
    this.dotColor = AppColors.sageGreen,
    this.backgroundColor,
  });

  final String userName;
  final bool showUserName;
  final Color dotColor;
  final Color? backgroundColor;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late List<Animation<double>> _dotAnimations;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Bounce animation for dots
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Fade animation for entire indicator
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Create staggered dot animations
    _dotAnimations = List.generate(3, (index) {
      final delay = index * 0.2; // 200ms delay between dots
      
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _bounceController,
        curve: Interval(
          delay,
          0.6 + delay,
          curve: Curves.elasticOut,
        ),
      ));
    });
  }

  void _startAnimations() {
    _fadeController.forward();
    _bounceController.repeat();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: FTFadeIn(
        child: Align(
          alignment: Alignment.centerLeft,
          child: _buildTypingContainer(),
        ),
      ),
    );
  }

  Widget _buildTypingContainer() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120.0),
      margin: const EdgeInsets.only(right: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User name (optional)
          if (widget.showUserName) _buildUserName(),
          
          // Typing bubble
          _buildTypingBubble(),
        ],
      ),
    );
  }

  Widget _buildUserName() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.paddingM,
        bottom: AppDimensions.spacingXS,
      ),
      child: Text(
        widget.userName,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.softCharcoalLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL).copyWith(
          bottomLeft: const Radius.circular(AppDimensions.spacingS),
        ),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "typing" text
          Text(
            'typing',
            style: AppTextStyles.personalContent.copyWith(
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
              color: widget.dotColor,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingS),
          
          // Animated dots
          _buildAnimatedDots(),
        ],
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return SizedBox(
      width: 16.0,
      height: 12.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _dotAnimations[index],
            builder: (context, child) {
              // Calculate dot position with bounce effect
              final progress = _dotAnimations[index].value;
              final bounceHeight = 4.0 * progress * (1 - progress) * 4;
              
              return Transform.translate(
                offset: Offset(0, -bounceHeight),
                child: Container(
                  width: 3.0,
                  height: 3.0,
                  decoration: BoxDecoration(
                    color: widget.dotColor.withOpacity(0.4 + (0.6 * progress)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Advanced typing indicator with multiple participants
class MultiUserTypingIndicator extends StatefulWidget {
  const MultiUserTypingIndicator({
    super.key,
    required this.typingUsers,
    this.maxVisibleUsers = 3,
  });

  final List<String> typingUsers;
  final int maxVisibleUsers;

  @override
  State<MultiUserTypingIndicator> createState() => _MultiUserTypingIndicatorState();
}

class _MultiUserTypingIndicatorState extends State<MultiUserTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _slideController.forward();
  }

  void _initializeAnimation() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  String _getTypingText() {
    final count = widget.typingUsers.length;
    if (count == 0) return '';
    
    if (count == 1) {
      return '${widget.typingUsers.first} is typing...';
    } else if (count == 2) {
      return '${widget.typingUsers.first} and ${widget.typingUsers.last} are typing...';
    } else if (count <= widget.maxVisibleUsers) {
      final names = widget.typingUsers.sublist(0, count - 1);
      return '${names.join(', ')} and ${widget.typingUsers.last} are typing...';
    } else {
      final visibleCount = widget.maxVisibleUsers - 1;
      final names = widget.typingUsers.sublist(0, visibleCount);
      final remaining = count - visibleCount;
      return '${names.join(', ')} and $remaining others are typing...';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.spacingS,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.sageGreenWithOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.sageGreenWithOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Typing dots
            SizedBox(
              width: 16.0,
              height: 12.0,
              child: _TypingDots(color: AppColors.sageGreen),
            ),
            
            const SizedBox(width: AppDimensions.spacingS),
            
            // Typing text
            Flexible(
              child: Text(
                _getTypingText(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.sageGreen,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable typing dots animation widget
class _TypingDots extends StatefulWidget {
  const _TypingDots({
    required this.color,
    this.dotSize = 3.0,
    this.dotCount = 3,
  });

  final Color color;
  final double dotSize;
  final int dotCount;

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _dotAnimations = List.generate(widget.dotCount, (index) {
      final delay = index * 0.2;
      
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          delay,
          0.6 + delay,
          curve: Curves.elasticOut,
        ),
      ));
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _dotAnimations[index],
          builder: (context, child) {
            final progress = _dotAnimations[index].value;
            final bounceHeight = 4.0 * progress * (1 - progress) * 4;
            final opacity = 0.4 + (0.6 * progress);
            
            return Transform.translate(
              offset: Offset(0, -bounceHeight),
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Typing indicator for different states
enum TypingState {
  typing,
  recording,
  uploading,
  thinking,
}

class StateTypingIndicator extends StatelessWidget {
  const StateTypingIndicator({
    super.key,
    required this.userName,
    required this.state,
  });

  final String userName;
  final TypingState state;

  @override
  Widget build(BuildContext context) {
    return TypingIndicator(
      userName: userName,
      dotColor: _getStateColor(),
    );
  }

  Color _getStateColor() {
    switch (state) {
      case TypingState.typing:
        return AppColors.sageGreen;
      case TypingState.recording:
        return AppColors.dustyRose;
      case TypingState.uploading:
        return AppColors.cloudBlue;
      case TypingState.thinking:
        return AppColors.lavenderMist;
    }
  }

  String _getStateText() {
    switch (state) {
      case TypingState.typing:
        return 'typing';
      case TypingState.recording:
        return 'recording';
      case TypingState.uploading:
        return 'uploading';
      case TypingState.thinking:
        return 'thinking';
    }
  }
}