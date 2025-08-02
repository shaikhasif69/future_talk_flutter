import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Premium header widget for time capsule creation flow
/// Features back button, step indicator, title and subtitle exactly matching HTML design
class TimeCapsuleHeader extends StatefulWidget {
  /// Current step (1-4)
  final int currentStep;
  
  /// Title text
  final String title;
  
  /// Subtitle text
  final String subtitle;
  
  /// Back button callback
  final VoidCallback? onBackPressed;
  
  /// Total number of steps
  final int totalSteps;

  const TimeCapsuleHeader({
    super.key,
    required this.currentStep,
    required this.title,
    required this.subtitle,
    this.onBackPressed,
    this.totalSteps = 4,
  });

  @override
  State<TimeCapsuleHeader> createState() => _TimeCapsuleHeaderState();
}

class _TimeCapsuleHeaderState extends State<TimeCapsuleHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _backButtonController;
  late Animation<double> _backButtonAnimation;

  @override
  void initState() {
    super.initState();
    
    _backButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _backButtonAnimation = Tween<double>(
      begin: 0.0,
      end: -2.0,
    ).animate(CurvedAnimation(
      parent: _backButtonController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _backButtonController.dispose();
    super.dispose();
  }

  void _handleBackPressed() {
    HapticFeedback.selectionClick();
    
    _backButtonController.forward().then((_) {
      _backButtonController.reverse();
    });
    
    widget.onBackPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pearlWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.whisperGray,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            AppDimensions.cardPaddingLarge,
            AppDimensions.screenPadding,
            AppDimensions.cardPaddingLarge,
          ),
          child: Column(
            children: [
              // Header top row with back button and step indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  AnimatedBuilder(
                    animation: _backButtonAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_backButtonAnimation.value, 0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            onTap: _handleBackPressed,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.warmCream,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                border: Border.all(
                                  color: AppColors.whisperGray,
                                  width: 1.0,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.softCharcoal,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Step indicator
                  _buildStepIndicator(),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingXL),
              
              // Header content with title and subtitle
              Column(
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyles.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppDimensions.spacingS),
                  
                  Text(
                    widget.subtitle,
                    style: AppTextStyles.tagline.copyWith(
                      fontSize: 16,
                      color: AppColors.softCharcoalLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == widget.currentStep;
        final isCompleted = stepNumber < widget.currentStep;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(
            right: index < widget.totalSteps - 1 ? AppDimensions.spacingS : 0,
          ),
          child: Container(
            width: isActive ? 12 : 8,
            height: isActive ? 12 : 8,
            decoration: BoxDecoration(
              color: isCompleted || isActive 
                  ? AppColors.sageGreen 
                  : AppColors.stoneGray,
              shape: BoxShape.circle,
              boxShadow: isActive ? [
                BoxShadow(
                  color: AppColors.sageGreenWithOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
          ),
        );
      }),
    );
  }
}