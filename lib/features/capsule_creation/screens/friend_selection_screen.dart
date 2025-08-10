import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../widgets/animated_water_droplet_background.dart';
import '../widgets/time_capsule_header.dart';
import '../widgets/selection_context_card.dart';
import '../widgets/friend_list_item.dart';
import '../widgets/message_settings_section.dart';
import '../providers/time_capsule_creation_provider.dart';
import '../models/friend_model.dart';
import '../models/message_settings.dart';

/// Friend Selection Screen for "Someone Special" time capsule flow
/// Second screen after purpose selection with exact HTML design fidelity
class FriendSelectionScreen extends ConsumerStatefulWidget {
  const FriendSelectionScreen({super.key});

  @override
  ConsumerState<FriendSelectionScreen> createState() => _FriendSelectionScreenState();
}

class _FriendSelectionScreenState extends ConsumerState<FriendSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _continueButtonController;
  late Animation<Offset> _continueButtonSlideAnimation;
  late Animation<double> _continueButtonFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _continueButtonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _continueButtonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _continueButtonController,
      curve: Curves.easeOut,
    ));
    
    _continueButtonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _continueButtonController,
      curve: Curves.easeOut,
    ));
    
    // Start entrance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _continueButtonController.dispose();
    super.dispose();
  }

  void _showContinueButton() {
    _continueButtonController.forward();
  }

  void _hideContinueButton() {
    _continueButtonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final creationData = ref.watch(timeCapsuleCreationNotifierProvider);
    final selectedFriend = ref.watch(selectedFriendProvider);
    final filteredFriends = ref.watch(filteredFriendsProvider);
    final messageSettings = ref.watch(messageSettingsProvider) ?? const MessageSettings();
    final canProceed = ref.watch(canProceedFromFriendSelectionProvider);

    // Show/hide continue button based on selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedFriend != null && !_continueButtonController.isCompleted) {
        _showContinueButton();
      } else if (selectedFriend == null && _continueButtonController.isCompleted) {
        _hideContinueButton();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          // Animated water droplet background
          const AnimatedWaterDropletBackground(),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Status bar
                
                // Header with step indicator and title
                _buildHeader(),
                
                // Context bar
                _buildContextBar(),
                
                // Scrollable content
                Expanded(
                  child: _buildScrollableContent(
                    filteredFriends: filteredFriends,
                    selectedFriend: selectedFriend,
                    messageSettings: messageSettings,
                  ),
                ),
              ],
            ),
          ),
          
          // Continue button (positioned overlay)
          if (selectedFriend != null)
            _buildContinueButton(canProceed: canProceed),
          
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        children: [
          // Header top row with back button and step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sageGreen.withAlpha(26),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.softCharcoal,
                    size: 18,
                  ),
                ),
              ),
              
              // Step indicator
              _buildStepIndicator(),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Page title and subtitle
          FTFadeIn(
            delay: const Duration(milliseconds: 200),
            child: Column(
              children: [
                Text(
                  'Choose Your Friend',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.softCharcoal,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Who will receive this special message?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(5, (index) {
        final isCompleted = index < 1; // Step 1 completed
        final isActive = index == 1; // Step 2 active
        
        return Container(
          margin: const EdgeInsets.only(left: 8),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive 
                ? AppColors.sageGreen 
                : AppColors.whisperGray,
          ),
        );
      }),
    );
  }

  Widget _buildContextBar() {
    return FTFadeIn(
      delay: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
        child: SelectionContextCard(),
      ),
    );
  }

  Widget _buildScrollableContent({
    required List<Friend> filteredFriends,
    required Friend? selectedFriend,
    required MessageSettings messageSettings,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search section
          FTFadeIn(
            delay: const Duration(milliseconds: 400),
            child: _buildSearchSection(),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Friends section
          FTFadeIn(
            delay: const Duration(milliseconds: 500),
            child: _buildFriendsSection(filteredFriends, selectedFriend),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Message settings section
          FTFadeIn(
            delay: const Duration(milliseconds: 600),
            child: MessageSettingsSection(
              settings: messageSettings,
              onSettingsChanged: (newSettings) {
                ref.read(timeCapsuleCreationNotifierProvider.notifier)
                    .updateMessageSettings(newSettings);
              },
            ),
          ),
          
          // Extra space for continue button
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FriendSearchBar(
          onChanged: (query) {
            ref.read(timeCapsuleCreationNotifierProvider.notifier)
                .updateFriendSearchQuery(query);
          },
        ),
      ],
    );
  }

  Widget _buildFriendsSection(List<Friend> friends, Friend? selectedFriend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            const Text(
              '👥',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              'Your Friends',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.sageGreen.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${friends.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.sageGreen,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Friends list
        if (friends.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: friends.asMap().entries.map((entry) {
              final index = entry.key;
              final friend = entry.value;
              
              return FriendListItem(
                friend: friend,
                isSelected: selectedFriend?.id == friend.id,
                onTap: () {
                  if (selectedFriend?.id == friend.id) {
                    // Deselect if already selected
                    ref.read(timeCapsuleCreationNotifierProvider.notifier)
                        .clearFriendSelection();
                  } else {
                    // Select this friend
                    ref.read(timeCapsuleCreationNotifierProvider.notifier)
                        .selectFriend(friend);
                  }
                },
                animationDelay: Duration(milliseconds: 100 * index),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            '👋',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            'No friends found',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.softCharcoalLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or add some friends to continue',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalWithOpacity(0.38),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton({required bool canProceed}) {
    return Positioned(
      bottom: AppDimensions.spacingXL,
      left: AppDimensions.spacingL,
      right: AppDimensions.spacingL,
      child: SlideTransition(
        position: _continueButtonSlideAnimation,
        child: FadeTransition(
          opacity: _continueButtonFadeAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sageGreen.withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: canProceed ? _handleContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue to Time Selection',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    // Navigate to time selection screen
    context.pushNamed('create_capsule_delivery_time');
  }
}