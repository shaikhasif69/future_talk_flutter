import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_toggle.dart';
import '../widgets/preference_grid.dart';
import '../widgets/ai_warning.dart';

/// Future Talk's premium settings screen
/// Designed with beautiful animations and introvert-friendly UX
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  
  // Settings state
  bool _grammarAssistant = false;
  bool _conversationAssistant = false;
  bool _showAIWarning = false;
  bool _anonymousMessages = true;
  bool _readReceipts = true;
  bool _onlineStatus = true;
  bool _messagePreviews = true;
  bool _slowModeDefault = false;
  bool _readingNotifications = true;
  bool _timeCapsuleNotifications = true;
  bool _connectionStoneNotifications = true;
  bool _friendBatteryChanges = false;
  bool _marketingUpdates = false;
  bool _autoDownloadMedia = true;
  bool _backupChatHistory = true;
  bool _twoFactorAuth = false;
  
  // Reading preferences
  Set<String> _readingPreferences = {'evening', 'slow_pace', 'romance'};

  @override
  void initState() {
    super.initState();
  }

  void _onAIToggleChanged(bool isLayer1, bool value) {
    setState(() {
      if (isLayer1) {
        _grammarAssistant = value;
      } else {
        _conversationAssistant = value;
      }
      _showAIWarning = _grammarAssistant || _conversationAssistant;
    });
    
    // Haptic feedback
    HapticFeedback.selectionClick();
  }

  void _onPreferenceToggled(String preference) {
    setState(() {
      if (_readingPreferences.contains(preference)) {
        _readingPreferences.remove(preference);
      } else {
        _readingPreferences.add(preference);
      }
    });
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = AppDimensions.getResponsivePadding(screenWidth);
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.warmCream, AppColors.pearlWhite],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Premium Header
              FTFadeIn(
                delay: const Duration(milliseconds: 100),
                child: SettingsHeader(
                  onBackPressed: () => Navigator.of(context).pop(),
                  onSearchPressed: () {
                    // TODO: Implement search functionality
                    HapticFeedback.selectionClick();
                  },
                ),
              ),
              
              // Main Content
              Expanded(
                child: FTStaggerAnimation(
                  delay: const Duration(milliseconds: 300),
                  child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        padding,
                        AppDimensions.spacingXXL,
                        padding,
                        AppDimensions.spacingMassive + AppDimensions.bottomNavHeight,
                      ),
                      child: Column(
                        children: [
                          // AI & Privacy Settings
                          _buildAISection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Privacy Sanctuary
                          _buildPrivacySection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Communication Preferences
                          _buildCommunicationSection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Reading Sanctuary
                          _buildReadingSection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Notifications
                          _buildNotificationsSection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Account & Security
                          _buildAccountSection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Data & Storage
                          _buildDataSection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // Danger Zone
                          _buildDangerZoneSection(),
                          
                          const SizedBox(height: AppDimensions.spacingXXL),
                          
                          // About
                          _buildAboutSection(),
                        ],
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAISection() {
    return SettingsSection(
      icon: '🤖',
      title: 'AI Assistance',
      description: 'Control how AI helps you communicate while respecting your privacy',
      children: [
        SettingsToggle(
          title: 'Grammar Assistant (Layer 1)',
          description: 'Help with spelling and grammar only - no message reading',
          value: _grammarAssistant,
          onChanged: (value) => _onAIToggleChanged(true, value),
        ),
        SettingsToggle(
          title: 'Conversation Assistant (Layer 2)',
          description: 'Full AI help with message composition and suggestions',
          value: _conversationAssistant,
          onChanged: (value) => _onAIToggleChanged(false, value),
        ),
        if (_showAIWarning)
          AIWarning(
            text: '🛡️ Enabling AI assistance allows our systems to process your messages for improvement. Your privacy remains our highest priority and data is never stored permanently.',
          ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return SettingsSection(
      icon: '🔒',
      title: 'Privacy Sanctuary',
      description: 'Your safe space - control exactly who can reach you and how',
      children: [
        SettingsToggle(
          title: 'Anonymous Messages',
          description: 'Allow others to send you anonymous time capsules',
          value: _anonymousMessages,
          onChanged: (value) => setState(() => _anonymousMessages = value),
        ),
        SettingsToggle(
          title: 'Read Receipts',
          description: 'Show when you\'ve read messages from friends',
          value: _readReceipts,
          onChanged: (value) => setState(() => _readReceipts = value),
        ),
        _buildSettingItem(
          title: 'Profile Visibility',
          description: 'Control who can see your profile and information',
          trailing: _buildSettingValue('Friends Only'),
        ),
        SettingsToggle(
          title: 'Online Status',
          description: 'Show when you\'re online and available to chat',
          value: _onlineStatus,
          onChanged: (value) => setState(() => _onlineStatus = value),
        ),
      ],
    );
  }

  Widget _buildCommunicationSection() {
    return SettingsSection(
      icon: '💬',
      title: 'Communication',
      description: 'Customize how you connect and communicate with others',
      children: [
        SettingsToggle(
          title: 'Message Previews',
          description: 'Show message content in notifications',
          value: _messagePreviews,
          onChanged: (value) => setState(() => _messagePreviews = value),
        ),
        SettingsToggle(
          title: 'Slow Mode Default',
          description: 'Enable thoughtful conversation pace by default',
          value: _slowModeDefault,
          onChanged: (value) => setState(() => _slowModeDefault = value),
        ),
        _buildSettingItem(
          title: 'Quiet Hours',
          description: 'Automatically mute notifications during set times',
          trailing: _buildSettingValue('10 PM - 8 AM'),
        ),
      ],
    );
  }

  Widget _buildReadingSection() {
    return SettingsSection(
      icon: '📚',
      title: 'Reading Sanctuary',
      description: 'Personalize your reading experience and preferences',
      children: [
        SettingsToggle(
          title: 'Reading Notifications',
          description: 'Get notified when friends start reading sessions',
          value: _readingNotifications,
          onChanged: (value) => setState(() => _readingNotifications = value),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        PreferenceGrid(
          preferences: [
            PreferenceOption(
              id: 'evening',
              icon: '🌙',
              label: 'Evening Reader',
              description: 'Peaceful nights',
              isSelected: _readingPreferences.contains('evening'),
            ),
            PreferenceOption(
              id: 'morning',
              icon: '☀️',
              label: 'Morning Reader',
              description: 'Fresh starts',
              isSelected: _readingPreferences.contains('morning'),
            ),
            PreferenceOption(
              id: 'slow_pace',
              icon: '🐌',
              label: 'Slow Pace',
              description: 'Savor each word',
              isSelected: _readingPreferences.contains('slow_pace'),
            ),
            PreferenceOption(
              id: 'romance',
              icon: '💝',
              label: 'Romance Lover',
              description: 'Heart stories',
              isSelected: _readingPreferences.contains('romance'),
            ),
          ],
          onPreferenceToggled: _onPreferenceToggled,
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return SettingsSection(
      icon: '🔔',
      title: 'Notifications',
      description: 'Stay connected without feeling overwhelmed',
      children: [
        SettingsToggle(
          title: 'Time Capsule Deliveries',
          description: 'Get notified when your future messages arrive',
          value: _timeCapsuleNotifications,
          onChanged: (value) => setState(() => _timeCapsuleNotifications = value),
        ),
        SettingsToggle(
          title: 'Connection Stone Touches',
          description: 'Feel when friends touch their comfort stones',
          value: _connectionStoneNotifications,
          onChanged: (value) => setState(() => _connectionStoneNotifications = value),
        ),
        SettingsToggle(
          title: 'Friend Battery Changes',
          description: 'Know when friends\' social energy levels change',
          value: _friendBatteryChanges,
          onChanged: (value) => setState(() => _friendBatteryChanges = value),
        ),
        SettingsToggle(
          title: 'Marketing Updates',
          description: 'Receive news about Future Talk features',
          value: _marketingUpdates,
          onChanged: (value) => setState(() => _marketingUpdates = value),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return SettingsSection(
      icon: '⚙️',
      title: 'Account & Security',
      description: 'Manage your account and keep your data secure',
      children: [
        _buildSettingItem(
          title: 'Change Email',
          description: 'asif****@gmail.com',
          trailing: _buildSettingArrow(),
        ),
        _buildSettingItem(
          title: 'Update Password',
          description: 'Last changed 3 months ago',
          trailing: _buildSettingArrow(),
        ),
        SettingsToggle(
          title: 'Two-Factor Authentication',
          description: 'Add an extra layer of security to your account',
          value: _twoFactorAuth,
          onChanged: (value) => setState(() => _twoFactorAuth = value),
        ),
        _buildSettingItem(
          title: 'Login Sessions',
          description: 'Manage devices signed into your account',
          trailing: _buildNotificationBadge('3'),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return SettingsSection(
      icon: '💾',
      title: 'Data & Storage',
      description: 'Control your data and storage preferences',
      children: [
        SettingsToggle(
          title: 'Auto-Download Media',
          description: 'Automatically download images and voice messages',
          value: _autoDownloadMedia,
          onChanged: (value) => setState(() => _autoDownloadMedia = value),
        ),
        _buildSettingItem(
          title: 'Storage Used',
          description: '248 MB of messages, books, and media',
          trailing: _buildSettingArrow(),
        ),
        SettingsToggle(
          title: 'Backup Chat History',
          description: 'Automatically backup your conversations',
          value: _backupChatHistory,
          onChanged: (value) => setState(() => _backupChatHistory = value),
        ),
        _buildSettingItem(
          title: 'Export All Data',
          description: 'Download a complete copy of your Future Talk data',
          trailing: _buildSettingArrow(),
        ),
      ],
    );
  }

  Widget _buildDangerZoneSection() {
    return SettingsSection(
      icon: '⚠️',
      title: 'Danger Zone',
      description: 'Irreversible actions that permanently affect your account',
      isDangerZone: true,
      children: [
        _buildDangerItem(
          title: 'Deactivate Account',
          description: 'Temporarily disable your account and hide your profile',
          onTap: () {
            // TODO: Implement deactivate account
            HapticFeedback.heavyImpact();
          },
        ),
        _buildDangerItem(
          title: 'Delete Account',
          description: 'Permanently delete your account and all data',
          onTap: () {
            // TODO: Implement delete account
            HapticFeedback.heavyImpact();
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return FTCard.gradient(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.lavenderMist, AppColors.dustyRose],
          ),
        ),
        child: Stack(
          children: [
            // Decorative sparkle
            const Positioned(
              top: AppDimensions.spacingL,
              right: AppDimensions.spacingL,
              child: Text(
                '✨',
                style: TextStyle(fontSize: 24),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Future Talk',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: AppColors.pearlWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingXS),
                          Text(
                            'Version 1.0.0 (Beta)',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.pearlWhite.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Text(
                    'Your sanctuary for thoughtful communication. Built with love for introverts who value meaningful connections over noise.',
                    style: AppTextStyles.personalContent.copyWith(
                      color: AppColors.pearlWhite.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String description,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingL,
              horizontal: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.whisperGray,
                  width: AppDimensions.dividerHeight,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.settingsLabel,
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
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDangerItem({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return _buildSettingItem(
      title: title,
      description: description,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppDimensions.iconS,
        color: AppColors.dustyRose,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSettingArrow() {
    return Icon(
      Icons.arrow_forward_ios,
      size: AppDimensions.iconS,
      color: AppColors.softCharcoalLight,
    );
  }

  Widget _buildSettingValue(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.sageGreenWithOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        value,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.sageGreen,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNotificationBadge(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        count,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.pearlWhite,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}