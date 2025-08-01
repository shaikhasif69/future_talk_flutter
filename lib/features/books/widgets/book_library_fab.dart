import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Premium floating action button for book library
class BookLibraryFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const BookLibraryFAB({
    super.key,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  State<BookLibraryFAB> createState() => _BookLibraryFABState();
}

class _BookLibraryFABState extends State<BookLibraryFAB>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _glowController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Floating animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 6.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: AppDimensions.screenPadding,
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatingAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withOpacity(0.4 * _glowAnimation.value),
                    blurRadius: 16 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    widget.onPressed();
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '📝',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ).animate().fadeIn(delay: const Duration(seconds: 1)).scale(
        begin: const Offset(0.5, 0.5),
        end: const Offset(1.0, 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
      ),
    );
  }
}