import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// AI warning widget with premium styling and smooth animations
class AIWarning extends StatefulWidget {
  final String text;

  const AIWarning({
    super.key,
    required this.text,
  });

  @override
  State<AIWarning> createState() => _AIWarningState();
}

class _AIWarningState extends State<AIWarning>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -20.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    // Start animation after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(top: AppDimensions.spacingM),
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.warmPeach.withAlpha(26),
                    AppColors.dustyRose.withAlpha(26),
                  ],
                ),
                border: Border.all(
                  color: AppColors.warmPeach.withAlpha(77),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.warmPeach,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: AppTextStyles.personalContent.copyWith(
                        fontSize: 11,
                        color: AppColors.softCharcoalLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}