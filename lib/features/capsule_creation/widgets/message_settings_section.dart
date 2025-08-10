import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/message_settings.dart';

/// Message settings section widget for customizing capsule delivery
/// Matches the HTML design with premium Flutter implementation
class MessageSettingsSection extends StatelessWidget {
  const MessageSettingsSection({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  final MessageSettings settings;
  final ValueChanged<MessageSettings> onSettingsChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              const Text(
                '⚙️',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Message Settings',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.softCharcoal,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Notify About Capsule
          _buildToggleSetting(
            label: 'Notify About Capsule',
            description: 'Let them know a time capsule is waiting (they can\'t read it yet)',
            value: settings.notifyAboutCapsule,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              onSettingsChanged(settings.copyWith(notifyAboutCapsule: value));
            },
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Anonymous Sending
          _buildToggleSetting(
            label: 'Anonymous Sending',
            description: 'Hide your identity until delivery (option to reveal later)',
            value: settings.anonymousSending,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              onSettingsChanged(settings.copyWith(anonymousSending: value));
            },
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // One-Time View
          _buildToggleSetting(
            label: 'One-Time View',
            description: 'Message disappears after being read once',
            value: settings.oneTimeView,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              onSettingsChanged(settings.copyWith(oneTimeView: value));
            },
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Delivery Method
          _buildDeliveryMethodSetting(),
        ],
      ),
    );
  }

  Widget _buildToggleSetting({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.sageGreen.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Setting info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.softCharcoal,
                  ),
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
          
          // Toggle switch
          _buildToggleSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? AppColors.sageGreen : AppColors.whisperGray,
          boxShadow: value
              ? [
                  BoxShadow(
                    color: AppColors.sageGreen.withAlpha(77),
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
              left: value ? 22 : 2,
              top: 2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethodSetting() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Setting info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Method',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.softCharcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'How should they receive the final message?',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCharcoalLight,
                  height: 1.3,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          // Delivery method options
          Row(
            children: [
              Expanded(
                child: _buildDeliveryMethodOption(
                  method: DeliveryMethod.appOnly,
                  isSelected: settings.deliveryMethod == DeliveryMethod.appOnly,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: _buildDeliveryMethodOption(
                  method: DeliveryMethod.appAndEmail,
                  isSelected: settings.deliveryMethod == DeliveryMethod.appAndEmail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryMethodOption({
    required DeliveryMethod method,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onSettingsChanged(settings.copyWith(deliveryMethod: method));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingS,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.sageGreen : AppColors.whisperGray,
            width: 1,
          ),
          color: isSelected 
              ? AppColors.sageGreen.withAlpha(13)
              : Colors.white,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.sageGreen.withAlpha(26),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              method.icon,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                method.displayText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.sageGreen : AppColors.softCharcoalLight,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings template selector widget
class MessageSettingsTemplateSelector extends StatelessWidget {
  const MessageSettingsTemplateSelector({
    super.key,
    required this.onTemplateSelected,
  });

  final ValueChanged<String> onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Templates',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.softCharcoal,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Wrap(
            spacing: AppDimensions.spacingS,
            runSpacing: AppDimensions.spacingS,
            children: MessageSettingsTemplates.templateNames.map((templateName) {
              return _buildTemplateChip(templateName);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateChip(String templateName) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTemplateSelected(templateName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.sageGreen.withAlpha(77),
            width: 1,
          ),
          color: AppColors.sageGreen.withAlpha(13),
        ),
        child: Text(
          templateName,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.sageGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Settings summary widget showing current configuration
class MessageSettingsSummary extends StatelessWidget {
  const MessageSettingsSummary({
    super.key,
    required this.settings,
  });

  final MessageSettings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.sageGreen.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.sageGreen.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.sageGreen,
              ),
              const SizedBox(width: 4),
              Text(
                'Configuration Summary',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.sageGreen,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Text(
            settings.summaryDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
          
          if (settings.recommendation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              settings.recommendation,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.sageGreen,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}