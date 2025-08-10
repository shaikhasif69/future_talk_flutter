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
import '../widgets/time_visualization_card.dart';
import '../widgets/time_option_card.dart';
import '../widgets/special_occasion_card.dart';
import '../widgets/custom_date_time_picker.dart';
import '../widgets/selection_context_card.dart';
import '../widgets/animated_water_droplet_background.dart';

/// Second page of time capsule creation flow - Time Selection
/// Pixel-perfect implementation of the HTML design with premium interactions
class CreateCapsulePage2Screen extends ConsumerStatefulWidget {
  const CreateCapsulePage2Screen({super.key});

  @override
  ConsumerState<CreateCapsulePage2Screen> createState() => _CreateCapsulePage2ScreenState();
}

class _CreateCapsulePage2ScreenState extends ConsumerState<CreateCapsulePage2Screen>
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

  void _handleTimeOptionSelected(TimeOption timeOption) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.selectTimeOption(timeOption);
  }

  void _handleOccasionSelected(SpecialOccasion occasion) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.selectSpecialOccasion(occasion);
  }

  void _handleCustomDateTimeSelected(DateTime dateTime) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.setCustomDateTime(dateTime);
  }

  void _handleContinue() async {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    await notifier.continueToNextStep();
    
    // Navigate to message creation screen
    if (mounted) {
      context.go('/capsule/create/message');
    }
  }

  void _handleBackPressed() {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.goToPreviousStep();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasTimeSelection = ref.watch(hasTimeSelectionProvider);
    final isLoading = ref.watch(isCreationLoadingProvider);
    
    // Monitor continue button visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasTimeSelection && !_continueButtonController.isCompleted) {
        _continueButtonController.forward();
      } else if (!hasTimeSelection && _continueButtonController.isCompleted) {
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
                  currentStep: 2, // Step 2 active, step 1 completed
                  title: 'When to Deliver?',
                  subtitle: 'Choose your time travel destination',
                  onBackPressed: _handleBackPressed,
                ),
                
                // Scrollable content with proper physics
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(), // Prevents stretching
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      0,
                      AppDimensions.screenPadding,
                      120, // Space for continue button
                    ),
                    child: Column(
                      children: [
                        // Selection context showing "Future Me"
                        const SelectionContextCard(),
                        
                        const SizedBox(height: AppDimensions.spacingXXXL),
                        
                        // Time visualization card
                        const TimeVisualizationCard(),
                        
                        // Time options grid
                        TimeOptionsGrid(
                          onTimeOptionSelected: _handleTimeOptionSelected,
                          animationDelay: const Duration(milliseconds: 100),
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingXXXL),
                        
                        // Special occasions section
                        SpecialOccasionsSection(
                          onOccasionSelected: _handleOccasionSelected,
                        ),
                        
                        const SizedBox(height: AppDimensions.cardPaddingLarge),
                        
                        // Custom date time picker
                        CustomDateTimePicker(
                          onDateTimeSelected: _handleCustomDateTimeSelected,
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
                          color: AppColors.sageGreen.withAlpha(77),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FTButton.primary(
                      text: isLoading ? 'Preparing canvas...' : 'Continue to Message',
                      onPressed: hasTimeSelection && !isLoading 
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