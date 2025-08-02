import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_button.dart';
import '../models/time_capsule_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';
import '../widgets/time_capsule_header.dart';
import '../widgets/animated_water_droplet_background.dart';

/// Simplified third page of time capsule creation flow - Message Creation
/// Basic implementation without complex providers for MVP
class CreateCapsulePage3ScreenSimple extends ConsumerStatefulWidget {
  const CreateCapsulePage3ScreenSimple({super.key});

  @override
  ConsumerState<CreateCapsulePage3ScreenSimple> createState() => _CreateCapsulePage3ScreenSimpleState();
}

class _CreateCapsulePage3ScreenSimpleState extends ConsumerState<CreateCapsulePage3ScreenSimple>
    with TickerProviderStateMixin {
  
  // Animation controllers
  late AnimationController _continueButtonController;
  late Animation<double> _continueButtonAnimation;
  late Animation<Offset> _continueButtonSlide;
  
  // Text controller
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  
  // State variables
  bool _isFullScreen = false;
  int _wordCount = 0;
  
  @override
  void initState() {
    super.initState();
    
    // Setup animation controllers
    _continueButtonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _continueButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _continueButtonController,
      curve: Curves.easeOut,
    ));
    
    _continueButtonSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _continueButtonController,
      curve: Curves.easeOut,
    ));
    
    // Listen to text changes
    _textController.addListener(_handleTextChanged);
  }
  
  @override
  void dispose() {
    _continueButtonController.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }
  
  void _handleTextChanged() {
    final text = _textController.text;
    final wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    
    setState(() {
      _wordCount = wordCount;
    });
    
    // Show continue button when content is added
    final hasContent = text.trim().isNotEmpty;
    if (hasContent && !_continueButtonController.isCompleted) {
      _continueButtonController.forward();
    } else if (!hasContent && _continueButtonController.isCompleted) {
      _continueButtonController.reverse();
    }
  }
  
  void _handleContinue() async {
    final capsuleNotifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    
    // Strong haptic feedback
    HapticFeedback.heavyImpact();
    
    // Move to next step
    await capsuleNotifier.continueToNextStep();
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Message saved! Your time capsule is being created...',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
          ),
          backgroundColor: AppColors.sageGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
      );
    }
  }
  
  void _handleBackPressed() {
    context.pop();
  }
  
  String _getGreetingText(TimeCapsulePurpose? purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'Dear Future Me,';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Dear Friend,';
      case TimeCapsulePurpose.anonymous:
        return 'Dear Someone,';
      case null:
        return 'Dear Friend,';
    }
  }
  
  String _getPlaceholderText(TimeCapsulePurpose? purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'What would you like to tell your future self? Share your thoughts, dreams, challenges, or wisdom...';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Write a heartfelt message to someone special. What do you want them to know?';
      case TimeCapsulePurpose.anonymous:
        return 'Share words of encouragement, hope, or wisdom. Your message will touch someone\'s heart...';
      case null:
        return 'Start writing your message here...';
    }
  }
  
  String _getSubtitleForRecipient(TimeCapsulePurpose? purpose) {
    if (purpose == null) return 'Write your heartfelt message';
    
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'A message for future you';
      case TimeCapsulePurpose.someoneSpecial:
        return 'A message for someone special';
      case TimeCapsulePurpose.anonymous:
        return 'An anonymous message of hope';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final capsuleState = ref.watch(timeCapsuleCreationNotifierProvider);
    final hasContent = _textController.text.trim().isNotEmpty;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F5F3),
              Color(0xFFFEFEFE),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles background
            const AnimatedWaterDropletBackground(),
            
            // Main content
            Column(
              children: [
                // Header
                TimeCapsuleHeader(
                  currentStep: 3, // Step 3 active, steps 1-2 completed
                  title: 'Your Message',
                  subtitle: _getSubtitleForRecipient(capsuleState.selectedPurpose),
                  onBackPressed: _handleBackPressed,
                ),
                
                // Context bar showing recipient and time selection
                _buildContextBar(capsuleState),
                
                // Main content area
                Expanded(
                  child: _buildMainContent(capsuleState),
                ),
              ],
            ),
            
            // Continue button
            Positioned(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              bottom: AppDimensions.spacingXXXL,
              child: FadeTransition(
                opacity: _continueButtonAnimation,
                child: SlideTransition(
                  position: _continueButtonSlide,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sageGreenWithOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FTButton.primary(
                      text: 'Create Time Capsule',
                      onPressed: hasContent ? _handleContinue : null,
                      width: double.infinity,
                      icon: Icons.rocket_launch,
                      iconPosition: FTButtonIconPosition.right,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContextBar(TimeCapsuleCreationData capsuleState) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoalWithOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recipient section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  capsuleState.selectedPurpose?.emoji ?? '📝',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  'To: ${capsuleState.selectedPurpose?.title ?? 'Someone'}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sageGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
            child: Text(
              '•',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.softCharcoalWithOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),
          
          // Time section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.warmPeach.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  capsuleState.timeMetaphor,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 4),
                Text(
                  'In: ${capsuleState.timeDisplay}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warmPeach,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent(TimeCapsuleCreationData capsuleState) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.spacingL,
        AppDimensions.screenPadding,
        120, // Space for continue button
      ),
      child: Column(
        children: [
          // Message editor
          Container(
            constraints: const BoxConstraints(
              minHeight: 300,
              maxHeight: 500,
            ),
            decoration: BoxDecoration(
              color: AppColors.pearlWhite,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.sageGreenWithOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softCharcoalWithOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Editor header
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.warmCream.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusL),
                      topRight: Radius.circular(AppDimensions.radiusL),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Your Message',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.softCharcoal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Word count
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreenWithOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: Text(
                          '$_wordCount words',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.sageGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Text editor area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: TextField(
                      controller: _textController,
                      focusNode: _textFocusNode,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.softCharcoal,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: '${_getGreetingText(capsuleState.selectedPurpose)}\n\n${_getPlaceholderText(capsuleState.selectedPurpose)}',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.softCharcoalWithOpacity(0.4),
                          height: 1.6,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      cursorColor: AppColors.sageGreen,
                      cursorWidth: 2,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}