import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/anonymous_message_settings.dart';

/// Settings section widget for anonymous message configuration
/// Provides toggles and options for privacy and delivery preferences
class AnonymousSettingsSection extends StatefulWidget {
  /// Current anonymous message settings
  final AnonymousMessageSettings settings;
  
  /// Callback when settings are updated
  final ValueChanged<AnonymousMessageSettings> onSettingsChanged;
  
  /// Whether to show the section with animation
  final bool isVisible;
  
  /// Animation delay for entrance
  final Duration animationDelay;

  const AnonymousSettingsSection({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    this.isVisible = true,
    this.animationDelay = Duration.zero,
  });

  @override
  State<AnonymousSettingsSection> createState() => _AnonymousSettingsSectionState();
}

class _AnonymousSettingsSectionState extends State<AnonymousSettingsSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _expandController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    ));

    if (widget.isVisible) {
      Future.delayed(widget.animationDelay, () {
        if (mounted) {
          _slideController.forward();
          _expandController.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(AnonymousSettingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _slideController.forward();
        _expandController.forward();
      } else {
        _slideController.reverse();
        _expandController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _updateSettings(AnonymousMessageSettings newSettings) {
    HapticFeedback.selectionClick();
    widget.onSettingsChanged(newSettings);
  }

  Widget _buildToggleItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 16,
                        color: AppColors.lavenderMist,
                      ),
                      const SizedBox(width: AppDimensions.spacingXS),
                    ],
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.softCharcoal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softCharcoalLight,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Custom toggle switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: value ? AppColors.lavenderMist : AppColors.whisperGray,
                borderRadius: BorderRadius.circular(12),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: AppColors.lavenderMist.withAlpha(77),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    left: value ? 20 : 2,
                    top: 2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.pearlWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.softCharcoalWithOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Identity Reveal Option',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.softCharcoal,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          'Choose how your identity will be handled',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        Row(
          children: IdentityRevealOption.values.map((option) {
            final isSelected = widget.settings.identityRevealOption == option;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  _updateSettings(
                    widget.settings.copyWith(identityRevealOption: option),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: AppDimensions.spacingS),
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.lavenderMist.withAlpha(13)
                        : AppColors.pearlWhite,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.lavenderMist
                          : AppColors.whisperGray.withAlpha(77),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Column(
                    children: [
                      Text(
                        option.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        option.displayText,
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected
                              ? AppColors.lavenderMist
                              : AppColors.softCharcoalLight,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            margin: const EdgeInsets.only(top: AppDimensions.spacingXL),
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            decoration: BoxDecoration(
              color: AppColors.warmPeach.withAlpha(77),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: AppColors.warmPeach.withAlpha(51),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.lavenderMist.withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.security,
                        size: 16,
                        color: AppColors.lavenderMist,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Text(
                      'Anonymous Settings',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.softCharcoal,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                // Notify about capsule toggle
                _buildToggleItem(
                  title: 'Notify About Capsule',
                  description: 'Let them know an anonymous capsule is waiting',
                  value: widget.settings.notifyAboutCapsule,
                  onChanged: (value) => _updateSettings(
                    widget.settings.copyWith(notifyAboutCapsule: value),
                  ),
                  icon: Icons.notifications_outlined,
                ),
                
                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                  color: AppColors.warmPeach.withAlpha(77),
                ),
                
                // Identity reveal options
                _buildRevealOptions(),
                
                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                  color: AppColors.warmPeach.withAlpha(77),
                ),
                
                // One-time view toggle
                _buildToggleItem(
                  title: 'One-Time View',
                  description: 'Message disappears after being read once',
                  value: widget.settings.oneTimeView,
                  onChanged: (value) => _updateSettings(
                    widget.settings.copyWith(oneTimeView: value),
                  ),
                  icon: Icons.visibility_off_outlined,
                ),
                
                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                  color: AppColors.warmPeach.withAlpha(77),
                ),
                
                // Delivery hint toggle
                _buildToggleItem(
                  title: 'Delivery Hint',
                  description: 'Give them a small clue about who might have sent this',
                  value: widget.settings.includeDeliveryHint,
                  onChanged: (value) => _updateSettings(
                    widget.settings.copyWith(includeDeliveryHint: value),
                  ),
                  icon: Icons.lightbulb_outline,
                ),
                
                // Security summary
                const SizedBox(height: AppDimensions.spacingL),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.lavenderMist.withAlpha(13),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    border: Border.all(
                      color: AppColors.lavenderMist.withAlpha(26),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: Color(int.parse(
                          widget.settings.securityLevelColor.substring(1),
                          radix: 16,
                        ) + 0xFF000000),
                      ),
                      const SizedBox(width: AppDimensions.spacingXS),
                      Text(
                        'Security Level: ${widget.settings.securityLevelText}',
                        style: AppTextStyles.caption.copyWith(
                          color: Color(int.parse(
                            widget.settings.securityLevelColor.substring(1),
                            radix: 16,
                          ) + 0xFF000000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}