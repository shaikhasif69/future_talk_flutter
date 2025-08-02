import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_button.dart';
import '../models/anonymous_user_model.dart';
import '../models/anonymous_message_settings.dart';
import '../providers/time_capsule_creation_provider.dart';
import '../widgets/time_capsule_header.dart';
import '../widgets/anonymous_user_search_bar.dart';
import '../widgets/anonymous_user_list_item.dart';
import '../widgets/anonymous_settings_section.dart';

/// Anonymous User Search Screen for Future Talk's time capsule creation
/// Privacy-focused interface for finding and selecting anonymous message recipients
class AnonymousUserSearchScreen extends ConsumerStatefulWidget {
  const AnonymousUserSearchScreen({super.key});

  @override
  ConsumerState<AnonymousUserSearchScreen> createState() => _AnonymousUserSearchScreenState();
}

class _AnonymousUserSearchScreenState extends ConsumerState<AnonymousUserSearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _continueButtonController;
  late AnimationController _searchResultsController;
  late AnimationController _noResultsController;
  
  late Animation<double> _continueButtonAnimation;
  late Animation<Offset> _continueButtonSlide;
  late Animation<double> _searchResultsAnimation;
  late Animation<Offset> _searchResultsSlide;
  late Animation<double> _noResultsAnimation;
  
  List<AnonymousUser> _searchResults = [];
  bool _hasSearched = false;
  bool _showNoResults = false;

  @override
  void initState() {
    super.initState();
    
    _continueButtonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _searchResultsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _noResultsController = AnimationController(
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
    
    _searchResultsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _searchResultsController,
      curve: Curves.easeOut,
    ));
    
    _searchResultsSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _searchResultsController,
      curve: Curves.easeOut,
    ));
    
    _noResultsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _noResultsController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _continueButtonController.dispose();
    _searchResultsController.dispose();
    _noResultsController.dispose();
    super.dispose();
  }

  Future<void> _handleSearchConfirmed(String query) async {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    
    // Update search query in state
    notifier.updateAnonymousSearchQuery(query);
    
    // Perform search
    final results = await notifier.searchAnonymousUsers(query);
    
    setState(() {
      _searchResults = results;
      _hasSearched = true;
      _showNoResults = results.isEmpty;
    });
    
    // Animate results or no results
    if (results.isNotEmpty) {
      _noResultsController.reset();
      _searchResultsController.forward();
    } else {
      _searchResultsController.reset();
      _noResultsController.forward();
    }
  }

  void _handleSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _showNoResults = false;
      });
      _searchResultsController.reset();
      _noResultsController.reset();
    }
  }

  void _handleSearchCleared() {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.clearAnonymousSearch();
    
    setState(() {
      _searchResults = [];
      _hasSearched = false;
      _showNoResults = false;
    });
    
    _searchResultsController.reset();
    _noResultsController.reset();
  }

  void _handleUserSelected(AnonymousUser user) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.selectAnonymousUser(user);
    
    // Show continue button with animation
    _continueButtonController.forward();
  }

  void _handleSettingsChanged(AnonymousMessageSettings settings) {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    notifier.updateAnonymousMessageSettings(settings);
  }

  Future<void> _handleContinue() async {
    final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    await notifier.continueToNextStep();
    
    // Navigate to time selection screen
    if (mounted) {
      context.pushNamed('create_capsule_delivery_time');
    }
  }

  void _handleBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final creationState = ref.watch(timeCapsuleCreationNotifierProvider);
    final selectedUser = ref.watch(selectedAnonymousUserProvider);
    final anonymousSettings = ref.watch(anonymousMessageSettingsProvider) ?? 
        const AnonymousMessageSettings();
    final isSearchLoading = ref.watch(isAnonymousSearchLoadingProvider);
    final isLoading = ref.watch(isCreationLoadingProvider);
    final showContinueButton = selectedUser != null;
    
    // Monitor continue button visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showContinueButton && !_continueButtonController.isCompleted) {
        _continueButtonController.forward();
      } else if (!showContinueButton && _continueButtonController.isCompleted) {
        _continueButtonController.reverse();
      }
    });

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
            // Main content
            Column(
              children: [
                // Header
                TimeCapsuleHeader(
                  currentStep: creationState.currentStep,
                  title: 'Send Anonymous Message',
                  subtitle: 'Find someone to send a mystery time capsule',
                  onBackPressed: _handleBackPressed,
                ),
                
                // Context bar
                Container(
                  margin: const EdgeInsets.fromLTRB(
                    AppDimensions.screenPadding,
                    AppDimensions.spacingM,
                    AppDimensions.screenPadding,
                    0,
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: AppColors.sageGreen.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎭', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: AppDimensions.spacingS),
                      Text(
                        'Creating: ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.softCharcoalLight,
                        ),
                      ),
                      Text(
                        'Anonymous Gift',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.softCharcoal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingXS),
                      Text(
                        'time capsule',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.softCharcoalLight,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.spacingL,
                      AppDimensions.screenPadding,
                      120, // Space for continue button
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Privacy notice
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingL),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.lavenderMist.withOpacity(0.05),
                                AppColors.pearlWhite,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            border: Border.all(
                              color: AppColors.lavenderMist.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.lavenderMist.withOpacity(0.1),
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
                                    'Complete Privacy',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.softCharcoal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.spacingS),
                              Text(
                                'Your identity will remain hidden until you choose to reveal it. The recipient won\'t know who sent the message.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.softCharcoalLight,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingXL),
                        
                        // Search section
                        AnonymousUserSearchBar(
                          onSearchConfirmed: _handleSearchConfirmed,
                          onSearchChanged: _handleSearchChanged,
                          onSearchCleared: _handleSearchCleared,
                          isLoading: isSearchLoading,
                          initialText: creationState.anonymousSearchQuery,
                        ),
                        
                        // Search results
                        if (_hasSearched) ...[
                          const SizedBox(height: AppDimensions.spacingXL),
                          
                          if (_searchResults.isNotEmpty) ...[
                            // Results title
                            SlideTransition(
                              position: _searchResultsSlide,
                              child: FadeTransition(
                                opacity: _searchResultsAnimation,
                                child: Text(
                                  'Search Results',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.softCharcoalLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: AppDimensions.spacingM),
                            
                            // User results
                            SlideTransition(
                              position: _searchResultsSlide,
                              child: FadeTransition(
                                opacity: _searchResultsAnimation,
                                child: Column(
                                  children: _searchResults.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final user = entry.value;
                                    
                                    return AnonymousUserListItem(
                                      user: user,
                                      isSelected: selectedUser?.id == user.id,
                                      onTap: () => _handleUserSelected(user),
                                      animationDelay: Duration(milliseconds: index * 100),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ] else if (_showNoResults) ...[
                            // No results
                            FadeTransition(
                              opacity: _noResultsAnimation,
                              child: Container(
                                padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: AppColors.softCharcoalLight.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: AppDimensions.spacingL),
                                    Text(
                                      'No users found',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.softCharcoalLight,
                                      ),
                                    ),
                                    const SizedBox(height: AppDimensions.spacingS),
                                    Text(
                                      'Double-check the username or email address. Remember, we only show exact matches for privacy.',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.softCharcoalLight.withOpacity(0.8),
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                        
                        // Anonymous settings (only show when user is selected)
                        if (selectedUser != null) ...[
                          AnonymousSettingsSection(
                            settings: anonymousSettings,
                            onSettingsChanged: _handleSettingsChanged,
                            isVisible: selectedUser != null,
                            animationDelay: const Duration(milliseconds: 300),
                          ),
                        ],
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
              bottom: AppDimensions.spacingXXXL,
              child: FadeTransition(
                opacity: _continueButtonAnimation,
                child: SlideTransition(
                  position: _continueButtonSlide,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lavenderMist.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FTButton.primary(
                      text: isLoading ? 'Preparing...' : 'Continue to Time Selection',
                      onPressed: showContinueButton && !isLoading 
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