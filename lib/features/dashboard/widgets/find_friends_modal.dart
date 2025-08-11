import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/ft_button.dart';
import '../../../shared/widgets/ft_input.dart';
import '../../friends/models/friend_search_models.dart';
import '../../friends/providers/friend_search_provider.dart';
import '../types/friend_action.dart';

/// Future Talk's Find Friends Modal
/// A beautiful, introvert-friendly search modal for finding and connecting with friends
/// Includes multiple states: search, loading, user found, and not found
class FindFriendsModal extends ConsumerStatefulWidget {
  /// Callback when a user is found and actions are taken
  final void Function(UserLookupResult user, FriendAction action)? onUserAction;
  
  /// Callback when modal is closed
  final VoidCallback? onClose;

  const FindFriendsModal({
    super.key,
    this.onUserAction,
    this.onClose,
  });

  @override
  ConsumerState<FindFriendsModal> createState() => _FindFriendsModalState();
}

class _FindFriendsModalState extends ConsumerState<FindFriendsModal>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _stateController;
  late AnimationController _iconController;

  FindFriendsState _currentState = FindFriendsState.search;
  UserLookupResult? _foundUser;
  String _searchQuery = '';
  String? _lastSearchQuery; // Track last search to avoid duplicate searches
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    
    _searchController = TextEditingController();
    
    _stateController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );
    
    _iconController = AnimationController(
      duration: AppDurations.ultraSlow,
      vsync: this,
    );
    
    // Start icon breathing animation
    _iconController.repeat(reverse: true);
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _stateController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _performSearch() async {
    if (_searchQuery.isEmpty || _searchQuery.trim().length < 2) {
      _showError('Search query must be at least 2 characters');
      return;
    }

    // Avoid duplicate searches
    if (_lastSearchQuery == _searchQuery.trim() && _currentState != FindFriendsState.error) {
      return;
    }

    // Haptic feedback for search
    HapticFeedback.selectionClick();

    setState(() {
      _currentState = FindFriendsState.loading;
      _errorMessage = null;
    });

    _lastSearchQuery = _searchQuery.trim();

    try {
      // Use the Riverpod provider to perform user lookup
      ref.read(friendSearchNotifierProvider.notifier).lookupUser(_searchQuery.trim());
    } catch (e) {
      if (mounted) {
        _showError('An unexpected error occurred. Please try again.');
        HapticFeedback.lightImpact();
      }
    }
  }
  
  void _showError(String message) {
    setState(() {
      _currentState = FindFriendsState.error;
      _errorMessage = message;
    });
  }

  void _clearSearch() {
    HapticFeedback.selectionClick();
    
    // Clear provider state
    ref.read(friendSearchNotifierProvider.notifier).clearErrors();
    
    setState(() {
      _currentState = FindFriendsState.search;
      _foundUser = null;
      _searchController.clear();
      _searchQuery = '';
      _lastSearchQuery = null;
      _errorMessage = null;
    });
    
    // Restart icon animation
    _iconController.repeat(reverse: true);
  }

  void _handleUserAction(FriendAction action) async {
    if (_foundUser == null) return;
    
    HapticFeedback.mediumImpact();
    
    // Handle different actions
    switch (action) {
      case FriendAction.addFriend:
        await _sendFriendRequest();
        break;
      case FriendAction.sendMessage:
        _navigateToChat();
        break;
      case FriendAction.sendTimeCapsule:
        _navigateToTimeCapsule();
        break;
    }
    
    // Notify parent widget
    widget.onUserAction?.call(_foundUser!, action);
  }
  
  Future<void> _sendFriendRequest() async {
    if (_foundUser == null) return;
    
    final success = await ref.read(friendSearchNotifierProvider.notifier)
        .sendFriendRequest(targetUsername: _foundUser!.username);
    
    if (success && mounted) {
      // Update the found user with new friendship status
      setState(() {
        _foundUser = _foundUser!.copyWith(friendshipStatus: FriendshipStatus.pending);
      });
      
      // Show success feedback
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Friend request sent to ${_foundUser!.displayName}'),
          backgroundColor: AppColors.sageGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      // Show error feedback
      final errorMessage = ref.read(friendSearchNotifierProvider).friendRequestError ?? 
                          'Failed to send friend request';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.dustyRose,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  void _navigateToChat() {
    if (_foundUser == null) return;
    
    // Close modal first
    Navigator.of(context).pop();
    
    // Navigate to chat screen with the user
    context.push('/chat/individual/${_foundUser!.id}');
  }
  
  void _navigateToTimeCapsule() {
    if (_foundUser == null) return;
    
    // Close modal first
    Navigator.of(context).pop();
    
    // Navigate to time capsule creation with pre-selected recipient
    context.push('/capsules/create?recipientId=${_foundUser!.id}');
  }

  void _closeModal() {
    HapticFeedback.selectionClick();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(
          maxWidth: 320,
          minHeight: 500,
          maxHeight: 600,
        ),
        decoration: BoxDecoration(
          color: AppColors.pearlWhite,
          borderRadius: BorderRadius.circular(AppDimensions.modalRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.modalShadow,
              blurRadius: 32,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModalHeader(),
            Flexible(
              child: _buildModalContent(),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.modalShow)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: AppDurations.modalShow,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildModalHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingXXL),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.whisperGray,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32), // Balance the close button
              Expanded(
                child: Column(
                  children: [
                    _buildAnimatedIcon(),
                    const SizedBox(height: AppDimensions.spacingL),
                    _buildHeaderText(),
                  ],
                ),
              ),
              // Close button
              GestureDetector(
                onTap: _closeModal,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: AppDurations.medium)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: AppDurations.medium,
                    curve: Curves.elasticOut,
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    Widget iconWidget;
    Color backgroundColor;
    
    switch (_currentState) {
      case FindFriendsState.search:
        iconWidget = const Text('🔍', style: TextStyle(fontSize: 24));
        backgroundColor = AppColors.sageGreen;
        break;
      case FindFriendsState.loading:
        iconWidget = const Text('🔄', style: TextStyle(fontSize: 24));
        backgroundColor = AppColors.sageGreen;
        break;
      case FindFriendsState.found:
        iconWidget = const Text('✅', style: TextStyle(fontSize: 24));
        backgroundColor = AppColors.warmPeach;
        break;
      case FindFriendsState.notFound:
        iconWidget = const Text('❌', style: TextStyle(fontSize: 24));
        backgroundColor = AppColors.dustyRose;
        break;
      case FindFriendsState.error:
        iconWidget = const Text('⚠️', style: TextStyle(fontSize: 24));
        backgroundColor = AppColors.dustyRose;
        break;
    }

    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                backgroundColor,
                backgroundColor.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Transform.scale(
            scale: _currentState == FindFriendsState.search 
                ? 1.0 + (_iconController.value * 0.05)
                : 1.0,
            child: AnimatedSwitcher(
              duration: AppDurations.medium,
              child: Container(
                key: ValueKey(_currentState),
                child: Center(child: iconWidget),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderText() {
    String title;
    String subtitle;
    
    switch (_currentState) {
      case FindFriendsState.search:
        title = 'Find Friend';
        subtitle = 'Enter their complete username or email';
        break;
      case FindFriendsState.loading:
        title = 'Searching...';
        subtitle = 'Looking for your friend';
        break;
      case FindFriendsState.found:
        title = 'User Found!';
        subtitle = 'Connect with ${_foundUser?.displayName ?? 'them'}';
        break;
      case FindFriendsState.notFound:
        title = 'No User Found';
        subtitle = 'Please check spelling and try again';
        break;
      case FindFriendsState.error:
        title = 'Search Error';
        subtitle = _errorMessage ?? 'Something went wrong';
        break;
    }

    return Column(
      children: [
        AnimatedSwitcher(
          duration: AppDurations.medium,
          child: Text(
            title,
            key: ValueKey('title_$_currentState'),
            style: AppTextStyles.headlineSmall.copyWith(
              color: (_currentState == FindFriendsState.notFound || _currentState == FindFriendsState.error) 
                  ? AppColors.dustyRose 
                  : AppColors.softCharcoal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        AnimatedSwitcher(
          duration: AppDurations.medium,
          child: Text(
            subtitle,
            key: ValueKey('subtitle_$_currentState'),
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildModalContent() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingXXL),
      child: AnimatedSwitcher(
        duration: AppDurations.mediumSlow,
        child: _buildStateContent(),
      ),
    );
  }

  Widget _buildStateContent() {
    switch (_currentState) {
      case FindFriendsState.search:
        return _buildSearchContent();
      case FindFriendsState.loading:
        return _buildLoadingContent();
      case FindFriendsState.found:
        return _buildFoundContent();
      case FindFriendsState.notFound:
        return _buildNotFoundContent();
      case FindFriendsState.error:
        return _buildErrorContent();
    }
  }

  Widget _buildSearchContent() {
    return Column(
      key: const ValueKey('search'),
      mainAxisSize: MainAxisSize.min,
      children: [
        FTInput(
          controller: _searchController,
          hint: 'username or email...',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
          prefixIcon: Icons.search,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        FTButton.primary(
          text: 'Search',
          onPressed: _searchQuery.isNotEmpty ? _performSearch : null,
          isDisabled: _searchQuery.isEmpty,
          width: double.infinity,
        ),
        const SizedBox(height: AppDimensions.spacingXXL),
        _buildSearchPlaceholder(),
      ]
          .animate(interval: 100.ms)
          .fadeIn(duration: AppDurations.medium)
          .slideY(begin: 0.2, duration: AppDurations.medium),
    );
  }

  Widget _buildSearchPlaceholder() {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return SizedBox(
          height: 120,
          child: Center(
            child: Transform.translate(
              offset: Offset(0, -4 * _iconController.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.warmCream,
                      AppColors.whisperGray,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.stoneGray.withValues(alpha: 0.5),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '🔍',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppDimensions.spacingXXL),
        _buildLoadingDots(),
        const SizedBox(height: AppDimensions.spacingL),
        Text(
          'Finding your friend...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXXL),
      ]
          .animate()
          .fadeIn(duration: AppDurations.medium),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(
            color: AppColors.sageGreen,
            shape: BoxShape.circle,
          ),
        )
            .animate(delay: Duration(milliseconds: 150 * index))
            .then()
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.2, 1.2),
              duration: const Duration(milliseconds: 600),
            )
            .then()
            .scale(
              begin: const Offset(1.2, 1.2),
              end: const Offset(0.8, 0.8),
              duration: const Duration(milliseconds: 600),
            );
      }),
    );
  }

  Widget _buildFoundContent() {
    if (_foundUser == null) return const SizedBox.shrink();

    return Column(
      key: const ValueKey('found'),
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUserProfile(_foundUser!),
      ]
          .animate()
          .fadeIn(duration: AppDurations.slow)
          .slideY(begin: 0.3, duration: AppDurations.slow),
    );
  }

  Widget _buildUserProfile(UserLookupResult user) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spacingL, 
              AppDimensions.spacingXL, 
              AppDimensions.spacingL, 
              AppDimensions.spacingXXL + 8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.sageGreen, AppColors.sageGreenLight],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusL),
                topRight: Radius.circular(AppDimensions.radiusL),
              ),
            ),
            child: Column(
              children: [
                // Clear search button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: _clearSearch,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.pearlWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: AppColors.pearlWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                // Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.pearlWhite.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(
                      color: AppColors.pearlWhite.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.sageGreen,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTextStyles.headingFont,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                // Name
                Text(
                  user.displayName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                // Username
                Text(
                  '@${user.username}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pearlWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          // Profile Content
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingXL),
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: const BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusL)),
              ),
              child: Column(
                children: [
                  // Bio
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    Text(
                      user.bio!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.softCharcoal,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingL),
                  ] else ...[
                    Text(
                      'No bio available',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.softCharcoalLight,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacingL),
                  ],
                  // Social Battery Status
                  _buildSocialBatteryStatus(user),
                  const SizedBox(height: AppDimensions.spacingL),
                  // Friendship Status
                  _buildFriendshipStatusBadge(user),
                  const SizedBox(height: AppDimensions.spacingXL),
                  // Action Buttons
                  _buildActionButtons(user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialBatteryStatus(UserLookupResult user) {
    Color batteryColor;
    String batteryText;
    
    if (user.socialBattery >= 80) {
      batteryColor = AppColors.sageGreen;
      batteryText = 'Social Battery: High';
    } else if (user.socialBattery >= 50) {
      batteryColor = AppColors.warmPeach;
      batteryText = 'Social Battery: Medium';
    } else {
      batteryColor = AppColors.dustyRose;
      batteryText = 'Social Battery: Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS + 2,
      ),
      decoration: BoxDecoration(
        color: batteryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: batteryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: batteryColor,
              shape: BoxShape.circle,
            ),
          )
              .animate(delay: 500.ms)
              .then()
              .scale(duration: const Duration(seconds: 2))
              .then()
              .fadeIn(duration: const Duration(seconds: 1)),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            batteryText,
            style: AppTextStyles.labelLarge.copyWith(
              color: batteryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFriendshipStatusBadge(UserLookupResult user) {
    final status = user.friendshipStatus;
    Color badgeColor;
    String statusText;
    IconData statusIcon;
    
    switch (status) {
      case FriendshipStatus.none:
        badgeColor = AppColors.cloudBlue;
        statusText = 'Not Connected';
        statusIcon = Icons.person_outline;
        break;
      case FriendshipStatus.pending:
        badgeColor = AppColors.warmPeach;
        statusText = 'Request Pending';
        statusIcon = Icons.schedule;
        break;
      case FriendshipStatus.accepted:
        badgeColor = AppColors.sageGreen;
        statusText = 'Friends';
        statusIcon = Icons.people;
        break;
      case FriendshipStatus.blocked:
        badgeColor = AppColors.dustyRose;
        statusText = 'Blocked';
        statusIcon = Icons.block;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16,
            color: badgeColor,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            statusText,
            style: AppTextStyles.labelLarge.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(UserLookupResult user) {
    final status = user.friendshipStatus;
    final isRequestPending = ref.watch(friendSearchNotifierProvider).isSendingFriendRequest;
    
    return Column(
      children: [
        // Primary action based on friendship status
        if (status == FriendshipStatus.none) ...[
          Row(
            children: [
              Expanded(
                child: FTButton.primary(
                  text: isRequestPending ? 'Sending...' : 'Add Friend',
                  icon: isRequestPending ? null : Icons.person_add_outlined,
                  onPressed: isRequestPending ? null : () => _handleUserAction(FriendAction.addFriend),
                  isDisabled: isRequestPending,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
        ] else if (status == FriendshipStatus.pending) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.warmPeach.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.warmPeach.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppColors.warmPeach,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Friend request sent',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.warmPeach,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
        ] else if (status == FriendshipStatus.blocked) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.dustyRose.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.dustyRose.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.block,
                  size: 16,
                  color: AppColors.dustyRose,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'This user is blocked',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.dustyRose,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
        ],
        
        // Secondary actions (available for friends or accepted status)
        if (status == FriendshipStatus.accepted || status == FriendshipStatus.none) ...[
          Row(
            children: [
              Expanded(
                child: FTButton.secondary(
                  text: 'Message',
                  icon: Icons.chat_bubble_outline,
                  onPressed: () => _handleUserAction(FriendAction.sendMessage),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: FTButton(
                  text: 'Capsule',
                  icon: Icons.schedule_outlined,
                  style: FTButtonStyle.outlined,
                  onPressed: () => _handleUserAction(FriendAction.sendTimeCapsule),
                ),
              ),
            ],
          ),
        ],
      ]
          .animate(interval: 100.ms)
          .fadeIn(delay: 300.ms, duration: AppDurations.medium)
          .slideY(begin: 0.3, duration: AppDurations.medium),
    );
  }

  Widget _buildNotFoundContent() {
    return Column(
      key: const ValueKey('notFound'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppDimensions.spacingXXL),
        const Text(
          '🔍',
          style: TextStyle(fontSize: 48),
        ).animate().scale(
          duration: AppDurations.medium,
          curve: Curves.elasticOut,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        Text(
          'No user found',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          'Please check the spelling and try the complete username or email address.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        FTButton.secondary(
          text: 'Try Again',
          onPressed: _clearSearch,
        ),
        const SizedBox(height: AppDimensions.spacingXXL),
      ]
          .animate(interval: 100.ms)
          .fadeIn(duration: AppDurations.medium)
          .slideY(begin: 0.3, duration: AppDurations.medium),
    );
  }
  
  Widget _buildErrorContent() {
    return Column(
      key: const ValueKey('error'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppDimensions.spacingXXL),
        const Text(
          '⚠️',
          style: TextStyle(fontSize: 48),
        ).animate().scale(
          duration: AppDurations.medium,
          curve: Curves.elasticOut,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        Text(
          'Search Error',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.dustyRose,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          _errorMessage ?? 'Something went wrong. Please try again.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        Row(
          children: [
            Expanded(
              child: FTButton.secondary(
                text: 'Try Again',
                onPressed: _clearSearch,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Expanded(
              child: FTButton.primary(
                text: 'Retry Search',
                onPressed: () {
                  _clearSearch();
                  if (_searchQuery.isNotEmpty) {
                    _performSearch();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXXL),
      ]
          .animate(interval: 100.ms)
          .fadeIn(duration: AppDurations.medium)
          .slideY(begin: 0.3, duration: AppDurations.medium),
    );
  }

  /// Static method to show the modal with proper Riverpod context
  static Future<void> show(
    BuildContext context, {
    void Function(UserLookupResult user, FriendAction action)? onUserAction,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.softCharcoal.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return FindFriendsModal(
          onUserAction: onUserAction,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}

/// States of the find friends modal
enum FindFriendsState {
  search,
  loading,
  found,
  notFound,
  error,
}