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
  late TextEditingController _noteController;
  late AnimationController _stateController;
  late AnimationController _iconController;

  FindFriendsState _currentState = FindFriendsState.search;
  UserLookupResult? _foundUser;
  String _searchQuery = '';
  String? _lastSearchQuery; // Track last search to avoid duplicate searches
  String? _errorMessage;
  String _noteText = '';

  @override
  void initState() {
    super.initState();
    
    _searchController = TextEditingController();
    _noteController = TextEditingController();
    
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
    
    _noteController.addListener(() {
      setState(() {
        _noteText = _noteController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _noteController.dispose();
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
      _noteController.clear();
      _searchQuery = '';
      _noteText = '';
      _lastSearchQuery = null;
      _errorMessage = null;
    });
    
    // Restart icon animation
    _iconController.repeat(reverse: true);
  }

  void _showNoteInput() {
    HapticFeedback.selectionClick();
    
    setState(() {
      _currentState = FindFriendsState.noteInput;
      _noteController.clear();
      _noteText = '';
    });
  }

  void _backToUserProfile() {
    HapticFeedback.selectionClick();
    
    setState(() {
      _currentState = FindFriendsState.found;
    });
  }

  void _handleUserAction(FriendAction action) async {
    if (_foundUser == null) return;
    
    HapticFeedback.mediumImpact();
    
    // Handle different actions
    switch (action) {
      case FriendAction.addFriend:
        await _promptForNote();
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

  Future<void> _promptForNote() async {
    // Show option dialog
    final shouldAddNote = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              color: AppColors.pearlWhite,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.modalShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.message_rounded,
                  size: 32,
                  color: AppColors.sageGreen,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'Add a note?',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.softCharcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  'Would you like to include a personal message with your friend request?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingL),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.whisperGray.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Center(
                            child: Text(
                              'Send without note',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.softCharcoal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.sageGreen,
                                AppColors.sageGreen.withValues(alpha: 0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                          child: Center(
                            child: Text(
                              'Add note',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.pearlWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldAddNote == true) {
      _showNoteInput();
    } else if (shouldAddNote == false) {
      await _sendFriendRequest(message: null);
    }
  }

  Future<void> _sendFriendRequestWithNote() async {
    if (_noteText.trim().isEmpty) {
      await _sendFriendRequest(message: null);
    } else {
      await _sendFriendRequest(message: _noteText.trim());
    }
  }
  
  Future<void> _sendFriendRequest({String? message}) async {
    if (_foundUser == null) return;
    
    final success = await ref.read(friendSearchNotifierProvider.notifier)
        .sendFriendRequest(
          targetUsername: _foundUser!.username, 
          message: message,
        );
    
    if (success && mounted) {
      // Update the found user with new friendship status
      setState(() {
        _foundUser = _foundUser!.copyWith(friendshipStatus: FriendshipStatus.pending);
        _currentState = FindFriendsState.found; // Return to profile view
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
    // Listen to provider state changes
    ref.listen<FriendSearchState>(friendSearchNotifierProvider, (previous, next) {
      if (!mounted) return;
      
      debugPrint('🎧 [FindFriendsModal] Provider state changed - isLookingUpUser: ${next.isLookingUpUser}, error: ${next.lookupError}, user: ${next.lookedUpUser?.username}');
      
      // Handle lookup state changes
      if (previous?.isLookingUpUser == true && !next.isLookingUpUser) {
        debugPrint('🎧 [FindFriendsModal] Lookup operation completed');
        // Lookup operation completed
        if (next.lookupError != null) {
          // Handle lookup error
          debugPrint('🎧 [FindFriendsModal] Showing error: ${next.lookupError}');
          _showError(next.lookupError!);
          HapticFeedback.lightImpact();
        } else if (next.lookedUpUser != null) {
          // User found successfully
          debugPrint('🎧 [FindFriendsModal] User found: ${next.lookedUpUser!.displayName}');
          setState(() {
            _foundUser = next.lookedUpUser;
            _currentState = FindFriendsState.found;
          });
          HapticFeedback.mediumImpact();
        } else {
          // No user found
          debugPrint('🎧 [FindFriendsModal] No user found');
          setState(() {
            _currentState = FindFriendsState.notFound;
          });
          HapticFeedback.lightImpact();
        }
      }
    });
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 380,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildModalContent(),
              ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen.withValues(alpha: 0.05),
            AppColors.warmPeach.withValues(alpha: 0.03),
          ],
        ),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.whisperGray,
            width: 0.5,
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
      case FindFriendsState.noteInput:
        iconWidget = const Text('📝', style: TextStyle(fontSize: 24));
        backgroundColor = AppColors.warmPeach;
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
        subtitle = 'Search by username or email';
        break;
      case FindFriendsState.loading:
        title = 'Searching...';
        subtitle = 'Looking for your friend';
        break;
      case FindFriendsState.found:
        title = 'Found!';
        subtitle = _foundUser?.displayName ?? '';
        break;
      case FindFriendsState.notFound:
        title = 'Not Found';
        subtitle = 'Check spelling and try again';
        break;
      case FindFriendsState.error:
        title = 'Error';
        subtitle = 'Please try again';
        break;
      case FindFriendsState.noteInput:
        title = 'Add Note';
        subtitle = 'Send to ${_foundUser?.displayName ?? ''}';
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
      padding: const EdgeInsets.all(AppDimensions.spacingL),
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
      case FindFriendsState.noteInput:
        return _buildNoteInputContent();
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen.withValues(alpha: 0.05),
            AppColors.warmPeach.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.whisperGray.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            // Clear search button at top right
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: _clearSearch,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.softCharcoal.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.softCharcoal.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
            // Compact profile header
            Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.sageGreen.withValues(alpha: 0.15),
                        AppColors.sageGreen.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.sageGreen.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.sageGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                // Name and username
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.softCharcoal,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${user.username}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.softCharcoalLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            // Bio (if exists)
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spacingS),
                decoration: BoxDecoration(
                  color: AppColors.whisperGray.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Text(
                  user.bio!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softCharcoal,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
            ],
            // Compact status badges
            Row(
              children: [
                Expanded(child: _buildCompactSocialBattery(user)),
                const SizedBox(width: AppDimensions.spacingS),
                _buildCompactFriendshipBadge(user),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingL),
            // Streamlined action buttons
            _buildStreamlinedActions(user),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSocialBattery(UserLookupResult user) {
    Color batteryColor;
    IconData batteryIcon;
    String batteryLevel;
    
    if (user.socialBattery >= 80) {
      batteryColor = AppColors.sageGreen;
      batteryIcon = Icons.battery_full_rounded;
      batteryLevel = 'High';
    } else if (user.socialBattery >= 50) {
      batteryColor = AppColors.warmPeach;
      batteryIcon = Icons.battery_5_bar_rounded;
      batteryLevel = 'Medium';
    } else {
      batteryColor = AppColors.dustyRose;
      batteryIcon = Icons.battery_2_bar_rounded;
      batteryLevel = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: batteryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: batteryColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            batteryIcon,
            size: 14,
            color: batteryColor,
          ),
          const SizedBox(width: 4),
          Text(
            batteryLevel,
            style: AppTextStyles.labelSmall.copyWith(
              color: batteryColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFriendshipBadge(UserLookupResult user) {
    final status = user.friendshipStatus;
    Color badgeColor;
    IconData statusIcon;
    
    switch (status) {
      case FriendshipStatus.none:
        badgeColor = AppColors.cloudBlue;
        statusIcon = Icons.person_add_rounded;
        break;
      case FriendshipStatus.pending:
        badgeColor = AppColors.sageGreen;
        statusIcon = Icons.schedule_rounded;
        break;
      case FriendshipStatus.accepted:
        badgeColor = AppColors.sageGreen;
        statusIcon = Icons.check_circle_rounded;
        break;
      case FriendshipStatus.blocked:
        badgeColor = AppColors.dustyRose;
        statusIcon = Icons.block_rounded;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Icon(
        statusIcon,
        size: 14,
        color: badgeColor,
      ),
    );
  }

  Widget _buildStreamlinedActions(UserLookupResult user) {
    final status = user.friendshipStatus;
    final isRequestPending = ref.watch(friendSearchNotifierProvider).isSendingFriendRequest;
    
    return Column(
      children: [
        // Main action based on status
        if (status == FriendshipStatus.none) ...[
          _buildPrimaryActionButton(
            label: isRequestPending ? 'Sending...' : 'Add Friend',
            icon: Icons.person_add_rounded,
            onTap: isRequestPending ? null : () => _handleUserAction(FriendAction.addFriend),
            isLoading: isRequestPending,
          ),
        ] else if (status == FriendshipStatus.pending) ...[
          _buildStatusIndicator(
            label: 'Request Sent',
            icon: Icons.schedule_rounded,
            color: AppColors.sageGreen,
          ),
        ] else if (status == FriendshipStatus.blocked) ...[
          _buildStatusIndicator(
            label: 'Blocked',
            icon: Icons.block_rounded,
            color: AppColors.dustyRose,
          ),
        ],
        
        // Secondary actions row (available for all statuses except blocked)
        if (status != FriendshipStatus.blocked) ...[
          const SizedBox(height: AppDimensions.spacingS),
          Row(
            children: [
              Expanded(
                child: _buildSecondaryActionButton(
                  label: 'Message',
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => _handleUserAction(FriendAction.sendMessage),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: _buildSecondaryActionButton(
                  label: 'Capsule',
                  icon: Icons.access_time_rounded,
                  onTap: () => _handleUserAction(FriendAction.sendTimeCapsule),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPrimaryActionButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: onTap != null && !isLoading ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.sageGreen,
              AppColors.sageGreen.withValues(alpha: 0.85),
            ],
          ) : null,
          color: onTap == null || isLoading ? AppColors.whisperGray : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: onTap != null && !isLoading ? [
            BoxShadow(
              color: AppColors.sageGreen.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLoading) ...[
              Icon(
                icon,
                size: 16,
                color: onTap != null ? AppColors.pearlWhite : AppColors.softCharcoalLight,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: onTap != null ? AppColors.pearlWhite : AppColors.softCharcoalLight,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.whisperGray.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.stoneGray.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.softCharcoal,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.softCharcoal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
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

  Widget _buildNoteInputContent() {
    if (_foundUser == null) return const SizedBox.shrink();
    
    return Column(
      key: const ValueKey('noteInput'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Back button
        Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: _backToUserProfile,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.softCharcoal.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 16,
                    color: AppColors.softCharcoal.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Back',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.softCharcoal.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        
        // Note input field
        Container(
          decoration: BoxDecoration(
            color: AppColors.whisperGray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: AppColors.sageGreen.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _noteController,
            maxLines: 4,
            maxLength: 280,
            autofocus: true,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoal,
            ),
            decoration: InputDecoration(
              hintText: 'Write a personal message... (optional)',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppDimensions.spacingL),
              counterStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.softCharcoalLight,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        
        // Send button
        GestureDetector(
          onTap: _sendFriendRequestWithNote,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.sageGreen,
                  AppColors.sageGreen.withValues(alpha: 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sageGreen.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.send_rounded,
                  size: 16,
                  color: AppColors.pearlWhite,
                ),
                const SizedBox(width: 8),
                Text(
                  'Send Friend Request',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        
        // Character count and hint
        if (_noteText.isNotEmpty)
          Text(
            '${_noteText.length}/280 characters',
            style: AppTextStyles.labelSmall.copyWith(
              color: _noteText.length > 250 
                ? AppColors.dustyRose 
                : AppColors.softCharcoalLight,
              fontSize: 11,
            ),
          ),
      ]
          .animate(interval: 100.ms)
          .fadeIn(duration: AppDurations.medium)
          .slideY(begin: 0.2, duration: AppDurations.medium),
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
  noteInput,
}