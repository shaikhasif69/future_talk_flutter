import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_button.dart';
import '../models/time_capsule_creation_data.dart';
import '../models/message_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';
import '../providers/message_creation_provider.dart';
import '../widgets/time_capsule_header.dart';
import '../widgets/animated_water_droplet_background.dart';

/// Final step of time capsule creation flow - "Ready to Plant" screen
/// Premium Flutter implementation with capsule preview, delivery settings, and planting animation
/// Matches the HTML reference design with Future Talk's premium aesthetic
class CreateCapsuleFinalScreen extends ConsumerStatefulWidget {
  const CreateCapsuleFinalScreen({super.key});

  @override
  ConsumerState<CreateCapsuleFinalScreen> createState() => _CreateCapsuleFinalScreenState();
}

class _CreateCapsuleFinalScreenState extends ConsumerState<CreateCapsuleFinalScreen>
    with TickerProviderStateMixin {
  
  // Animation controllers
  late AnimationController _plantButtonController;
  late AnimationController _successController;
  late AnimationController _plantingController;
  late AnimationController _settingsController;
  
  // Animations
  late Animation<double> _plantButtonAnimation;
  late Animation<Offset> _plantButtonSlide;
  late Animation<double> _successFadeAnimation;
  late Animation<double> _successScaleAnimation;
  late Animation<double> _plantingPulseAnimation;
  late Animation<double> _settingsAnimation;
  
  // State variables
  bool _isPlanting = false;
  bool _showSuccess = false;
  String _generatedTrackingId = '';
  
  // Delivery settings state
  bool _appNotification = true;
  bool _emailBackup = true;
  bool _growthUpdates = true;
  bool _oneTimeView = false;
  EmailDeliveryOption _emailOption = EmailDeliveryOption.primary;

  @override
  void initState() {
    super.initState();
    
    // Setup animation controllers
    _plantButtonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _plantingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Setup animations
    _plantButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _plantButtonController,
      curve: Curves.easeOut,
    ));
    
    _plantButtonSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _plantButtonController,
      curve: Curves.easeOut,
    ));
    
    _successFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeOut,
    ));
    
    _successScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
    
    _plantingPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _plantingController,
      curve: Curves.easeInOut,
    ));
    
    _settingsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _settingsController,
      curve: Curves.easeOut,
    ));
    
    // Start entrance animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _plantButtonController.forward();
      _settingsController.forward();
      _generateTrackingId();
    });
  }
  
  @override
  void dispose() {
    _plantButtonController.dispose();
    _successController.dispose();
    _plantingController.dispose();
    _settingsController.dispose();
    super.dispose();
  }
  
  void _generateTrackingId() {
    final now = DateTime.now();
    final year = now.year;
    final random = (now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');
    _generatedTrackingId = 'TC-$year-FM-$random';
  }
  
  void _handleBackPressed() {
    HapticFeedback.selectionClick();
    context.pop();
  }
  
  Future<void> _handlePlantCapsule() async {
    if (_isPlanting) return;
    
    setState(() => _isPlanting = true);
    
    // Strong haptic feedback for major action
    HapticFeedback.heavyImpact();
    
    // Start planting animation
    _plantingController.repeat(reverse: true);
    
    // Simulate planting process
    await Future.delayed(const Duration(milliseconds: 3000));
    
    // Stop planting animation
    _plantingController.stop();
    
    // Show success overlay
    setState(() {
      _isPlanting = false;
      _showSuccess = true;
    });
    
    // Start success animation
    _successController.forward();
    
    // Final success haptic
    await Future.delayed(const Duration(milliseconds: 300));
    HapticFeedback.heavyImpact();
  }
  
  void _handleSettingToggle(String setting) {
    HapticFeedback.selectionClick();
    
    setState(() {
      switch (setting) {
        case 'app-notification':
          _appNotification = !_appNotification;
          break;
        case 'email-backup':
          _emailBackup = !_emailBackup;
          break;
        case 'growth-updates':
          _growthUpdates = !_growthUpdates;
          break;
        case 'one-time-view':
          _oneTimeView = !_oneTimeView;
          break;
      }
    });
  }
  
  void _handleEmailOptionChange(EmailDeliveryOption option) {
    HapticFeedback.selectionClick();
    setState(() => _emailOption = option);
  }
  
  void _handleSuccessAction(String action) {
    HapticFeedback.mediumImpact();
    
    switch (action) {
      case 'plant-another':
        // Reset providers and navigate to start
        ref.read(timeCapsuleCreationNotifierProvider.notifier).resetFlow();
        ref.read(messageCreationNotifierProvider.notifier).reset();
        context.go('/capsule/create');
        break;
      case 'view-garden':
        // Navigate to capsule garden
        context.go('/capsule-garden');
        break;
    }
  }
  
  String _getDeliveryTimelineText() {
    final capsuleState = ref.watch(timeCapsuleCreationNotifierProvider);
    if (capsuleState.selectedTimeOption != null) {
      return capsuleState.selectedTimeOption!.display;
    } else if (capsuleState.selectedOccasion != null) {
      return capsuleState.selectedOccasion!.display;
    } else if (capsuleState.customDateTime != null) {
      return capsuleState.customDateTime!.previewText;
    }
    return '6 months';
  }
  
  DateTime _getDeliveryDate() {
    final capsuleState = ref.watch(timeCapsuleCreationNotifierProvider);
    final now = DateTime.now();
    
    if (capsuleState.selectedTimeOption != null) {
      switch (capsuleState.selectedTimeOption!) {
        case TimeOption.oneHour:
          return now.add(const Duration(hours: 1));
        case TimeOption.oneDay:
          return now.add(const Duration(days: 1));
        case TimeOption.oneWeek:
          return now.add(const Duration(days: 7));
        case TimeOption.oneMonth:
          return now.add(const Duration(days: 30));
        case TimeOption.sixMonths:
          return now.add(const Duration(days: 180));
        case TimeOption.oneYear:
          return now.add(const Duration(days: 365));
      }
    } else if (capsuleState.customDateTime != null) {
      return capsuleState.customDateTime!.dateTime;
    }
    
    // Default: 6 months
    return now.add(const Duration(days: 180));
  }
  
  String _formatDeliveryDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageCreationNotifierProvider);
    final capsuleState = ref.watch(timeCapsuleCreationNotifierProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          // Floating particles background
          const AnimatedWaterDropletBackground(),
          
          // Main content
          Column(
            children: [
              // Header
              TimeCapsuleHeader(
                currentStep: 4, // Final step
                title: 'Ready to Plant',
                subtitle: 'Review your time capsule before planting',
                onBackPressed: _handleBackPressed,
              ),
              
              // Main scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.screenPadding,
                    0,
                    AppDimensions.screenPadding,
                    120, // Space for plant button
                  ),
                  child: FadeTransition(
                    opacity: _settingsAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Capsule Preview Card
                        _buildCapsulePreviewCard(messageState, capsuleState),
                        
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Delivery Settings Section
                        _buildDeliverySettingsSection(),
                        
                        const SizedBox(height: AppDimensions.spacingXXL),
                        
                        // Animation Section
                        _buildAnimationSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Plant Button (fixed at bottom)
          Positioned(
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
            bottom: AppDimensions.spacingXXXL,
            child: FadeTransition(
              opacity: _plantButtonAnimation,
              child: SlideTransition(
                position: _plantButtonSlide,
                child: _buildPlantButton(),
              ),
            ),
          ),
          
          // Success Overlay
          if (_showSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }
  
  Widget _buildCapsulePreviewCard(MessageCreationData messageState, TimeCapsuleCreationData capsuleState) {
    final deliveryText = _getDeliveryTimelineText();
    final messagePreview = messageState.textContent.isNotEmpty 
        ? messageState.textContent 
        : 'Your heartfelt message will be preserved here...';
    
    // Limit preview to first 100 characters
    final truncatedPreview = messagePreview.length > 100 
        ? '${messagePreview.substring(0, 100)}...'
        : messagePreview;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreenWithOpacity(0.05),
            AppColors.pearlWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
        child: Column(
          children: [
            // Preview header
            Column(
              children: [
                // Capsule icon with animation
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.sageGreenWithOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '🌰',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacingM),
                
                Text(
                  _getPurposeTitle(capsuleState.selectedPurpose),
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppDimensions.spacingXS),
                
                Text(
                  'Delivering in $deliveryText',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Message preview
            Container(
              decoration: BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border(
                  left: BorderSide(
                    color: AppColors.sageGreen,
                    width: 4.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MESSAGE PREVIEW',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.sageGreen,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.spacingS),
                  
                  Text(
                    '"$truncatedPreview"',
                    style: AppTextStyles.personalContent.copyWith(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Delivery timeline
            _buildDeliveryTimeline(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDeliveryTimeline() {
    final deliveryDate = _getDeliveryDate();
    final formattedDate = _formatDeliveryDate(deliveryDate);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sageGreenWithOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingM,
      ),
      child: Row(
        children: [
          // Today
          Expanded(
            child: Column(
              children: [
                Text(
                  'Today',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'PLANTED',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow
          Icon(
            Icons.arrow_forward,
            color: AppColors.sageGreen,
            size: AppDimensions.iconS,
          ),
          
          // Growing phase
          Expanded(
            child: Column(
              children: [
                Text(
                  'Growing',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getDeliveryTimelineText().toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow
          Icon(
            Icons.arrow_forward,
            color: AppColors.sageGreen,
            size: AppDimensions.iconS,
          ),
          
          // Delivered
          Expanded(
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'DELIVERED',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDeliverySettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.sageGreenWithOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text('⚙️', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              'Delivery Settings',
              style: AppTextStyles.headlineSmall,
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingL),
        
        // Setting cards
        _buildSettingCard(
          title: 'App Notification',
          description: 'Get notified in the app when your message is ready',
          isEnabled: _appNotification,
          onToggle: () => _handleSettingToggle('app-notification'),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        _buildSettingCard(
          title: 'Email Backup',
          description: 'Also send to your email for extra security',
          isEnabled: _emailBackup,
          onToggle: () => _handleSettingToggle('email-backup'),
          child: _emailBackup ? _buildEmailOptions() : null,
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        _buildSettingCard(
          title: 'Growth Updates',
          description: 'Gentle reminders about your growing message',
          isEnabled: _growthUpdates,
          onToggle: () => _handleSettingToggle('growth-updates'),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        _buildSettingCard(
          title: 'One-Time View',
          description: 'Message disappears after reading (like a real letter)',
          isEnabled: _oneTimeView,
          onToggle: () => _handleSettingToggle('one-time-view'),
        ),
      ],
    );
  }
  
  Widget _buildSettingCard({
    required String title,
    required String description,
    required bool isEnabled,
    required VoidCallback onToggle,
    Widget? child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isEnabled 
              ? AppColors.sageGreenWithOpacity(0.2)
              : AppColors.whisperGray,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                _buildToggleSwitch(isEnabled, onToggle),
              ],
            ),
            if (child != null) ...[
              const SizedBox(height: AppDimensions.spacingM),
              child,
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggleSwitch(bool isEnabled, VoidCallback onToggle) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.sageGreen : AppColors.stoneGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.pearlWhite,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.softCharcoalWithOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmailOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildEmailOption(
            icon: '📧',
            text: 'Primary Email',
            isSelected: _emailOption == EmailDeliveryOption.primary,
            onTap: () => _handleEmailOptionChange(EmailDeliveryOption.primary),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: _buildEmailOption(
            icon: '📱',
            text: 'App Only',
            isSelected: _emailOption == EmailDeliveryOption.appOnly,
            onTap: () => _handleEmailOptionChange(EmailDeliveryOption.appOnly),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmailOption({
    required String icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.sageGreenWithOpacity(0.1)
              : AppColors.warmCream,
          border: Border.all(
            color: isSelected 
                ? AppColors.sageGreen
                : AppColors.whisperGray,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: AppDimensions.spacingXS),
            Text(
              text,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected 
                    ? AppColors.sageGreen
                    : AppColors.softCharcoalLight,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnimationSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.warmCream,
            AppColors.pearlWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXL,
        vertical: AppDimensions.spacingXXXL,
      ),
      child: Column(
        children: [
          // Animation placeholder with planting pulse effect
          AnimatedBuilder(
            animation: _plantingPulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isPlanting ? _plantingPulseAnimation.value : 1.0,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.sageGreen,
                        AppColors.sageGreenLight,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sageGreenWithOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🌱',
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppDimensions.spacingXL),
          
          Text(
            _isPlanting ? 'Planting Your Capsule...' : 'Ready for Time Travel',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            _isPlanting 
                ? 'Your message is being planted in time\'s garden'
                : 'Your message is ready to be planted in time\'s garden',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlantButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreenWithOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FTButton.primary(
        text: _isPlanting ? 'Planting...' : 'Plant Time Capsule',
        onPressed: _isPlanting ? null : _handlePlantCapsule,
        isLoading: _isPlanting,
        width: double.infinity,
        size: FTButtonSize.large,
        icon: _isPlanting ? null : Icons.eco,
        iconPosition: FTButtonIconPosition.left,
      ),
    );
  }
  
  Widget _buildSuccessOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.sageGreenWithOpacity(0.95),
        ),
        child: FadeTransition(
          opacity: _successFadeAnimation,
          child: ScaleTransition(
            scale: _successScaleAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingXXXL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.pearlWhite.withAlpha(51),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '🎉',
                          style: TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                    
                    Text(
                      'Capsule Planted!',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.pearlWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingL),
                    
                    Text(
                      'Your message has been planted in time\'s garden and will grow over the next ${_getDeliveryTimelineText().toLowerCase()}.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.pearlWhite.withAlpha(230),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                    
                    // Tracking ID
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.pearlWhite.withAlpha(26),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        border: Border.all(
                          color: AppColors.pearlWhite.withAlpha(77),
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(AppDimensions.spacingL),
                      child: Column(
                        children: [
                          Text(
                            'Tracking ID',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.pearlWhite.withAlpha(204),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingXS),
                          Text(
                            _generatedTrackingId,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.pearlWhite,
                              fontFamily: 'monospace',
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppDimensions.spacingXXXL),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: FTButton.outlined(
                            text: 'Plant Another',
                            onPressed: () => _handleSuccessAction('plant-another'),
                            size: FTButtonSize.medium,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacingM),
                        Expanded(
                          child: FTButton.secondary(
                            text: 'View Garden',
                            onPressed: () => _handleSuccessAction('view-garden'),
                            size: FTButtonSize.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  String _getPurposeTitle(TimeCapsulePurpose? purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'Message to Future Me';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Message to Someone Special';
      case TimeCapsulePurpose.anonymous:
        return 'Anonymous Message of Hope';
      case null:
        return 'Your Time Capsule';
    }
  }
}

/// Email delivery options
enum EmailDeliveryOption {
  primary,
  appOnly,
}