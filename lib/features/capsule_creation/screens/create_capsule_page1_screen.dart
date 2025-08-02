import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_button.dart';
import '../models/time_capsule_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';
import '../widgets/time_capsule_header.dart';
import '../widgets/purpose_card.dart';
import '../widgets/quick_start_section.dart';
import '../widgets/animated_water_droplet_background.dart';

/// First page of time capsule creation flow
/// Pixel-perfect implementation of the HTML design with premium interactions
class CreateCapsulePage1Screen extends ConsumerStatefulWidget {
  const CreateCapsulePage1Screen({super.key});

  @override
  ConsumerState<CreateCapsulePage1Screen> createState() => _CreateCapsulePage1ScreenState();
}

class _CreateCapsulePage1ScreenState extends ConsumerState<CreateCapsulePage1Screen>
    with TickerProviderStateMixin {
  late AnimationController _continueButtonController;
  late Animation<double> _continueButtonAnimation;
  late Animation<Offset> _continueButtonSlide;

  @override
  void initState() {
    super.initState();
    
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
  }

  @override
  void dispose() {
    _continueButtonController.dispose();
    super.dispose();
  }

  void _handlePurposeSelection(TimeCapsulePurpose purpose) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.selectPurpose(purpose);
    
    // Show continue button with animation
    _continueButtonController.forward();
  }

  void _handleQuickStartSelection(QuickStartType quickStartType) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.selectQuickStart(quickStartType);
    
    // Show continue button if not already shown
    if (!_continueButtonController.isCompleted) {
      _continueButtonController.forward();
    }
  }

  void _handleContinue() async {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    final creationState = ref.read(timeCapsuleCreationNotifierProvider);
    
    await notifier.continueToNextStep();
    
    // Navigate based on selected purpose
    if (mounted) {
      switch (creationState.selectedPurpose) {
        case TimeCapsulePurpose.futureMe:
          context.pushNamed('create_capsule_delivery_time');
          break;
        case TimeCapsulePurpose.someoneSpecial:
          // Navigate to friend selection screen
          context.pushNamed('create_capsule_friend_selection');
          break;
        case TimeCapsulePurpose.anonymous:
          // TODO: Navigate to anonymous gift screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Anonymous Gift flow coming soon!',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
              ),
              backgroundColor: AppColors.lavenderMist,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          );
          break;
        default:
          break;
      }
    }
  }

  void _handleBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final creationState = ref.watch(timeCapsuleCreationNotifierProvider);
    final showContinueButton = ref.watch(showContinueButtonProvider);
    final isLoading = ref.watch(isCreationLoadingProvider);
    
    // Monitor continue button visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showContinueButton && !_continueButtonController.isCompleted) {
        _continueButtonController.forward();
      } else if (!showContinueButton && _continueButtonController.isCompleted) {
        _continueButtonController.reverse();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Matching HTML body gradient start
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F5F3), // Matching HTML gradient
              Color(0xFFFEFEFE),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles background
            const AnimatedWaterDropletBackground(),
            
            // Main content with proper scroll handling
            Column(
              children: [
                // Header (fixed)
                TimeCapsuleHeader(
                  currentStep: creationState.currentStep,
                  title: 'Create Time Capsule',
                  subtitle: 'Choose your recipient',
                  onBackPressed: _handleBackPressed,
                ),
                
                // Scrollable content with proper physics
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(), // Prevents stretching
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.spacingXXXL,
                      AppDimensions.screenPadding,
                      120, // Space for continue button only
                    ),
                    child: Column(
                      children: [
                        // Selection title
                        Text(
                          'Who will receive this message?',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: AppDimensions.cardPaddingLarge),
                        
                        // Purpose cards
                        ...TimeCapsulePurpose.values.asMap().entries.map((entry) {
                          final index = entry.key;
                          final purpose = entry.value;
                          
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index < TimeCapsulePurpose.values.length - 1 
                                  ? AppDimensions.spacingXL 
                                  : 0,
                            ),
                            child: PurposeCard(
                              purpose: purpose,
                              isSelected: creationState.selectedPurpose == purpose,
                              onTap: () => _handlePurposeSelection(purpose),
                              animationDelay: Duration(milliseconds: index * 100),
                            ),
                          );
                        }),
                        
                        // Quick start section
                        QuickStartSection(
                          onQuickStartSelected: _handleQuickStartSelection,
                          animationDelay: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Continue button (floating)
            Positioned(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              bottom: AppDimensions.spacingXXXL, // Bottom padding without nav
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
                      text: ref.read(timeCapsuleCreationNotifierProvider.notifier).continueButtonText,
                      onPressed: creationState.selectedPurpose != null && !isLoading 
                          ? _handleContinue 
                          : null,
                      isLoading: isLoading,
                      width: double.infinity,
                      icon: isLoading ? null : Icons.arrow_forward,
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
}

/// Phone container wrapper for desktop preview (optional)
/// This creates the phone mockup effect from the HTML
class PhoneContainerWrapper extends StatelessWidget {
  final Widget child;

  const PhoneContainerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Only show phone container on larger screens
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth > 600) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F5F3),
        body: Center(
          child: Container(
            width: 375,
            height: 812,
            decoration: BoxDecoration(
              color: AppColors.pearlWhite,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.softCharcoalWithOpacity(0.15),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: AppColors.softCharcoalWithOpacity(0.08),
                  blurRadius: 80,
                  offset: const Offset(0, 30),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      );
    }
    
    return child;
  }
}