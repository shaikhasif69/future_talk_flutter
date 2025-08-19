import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/friend_search_models.dart';
import '../providers/friends_providers.dart';


/// Friends management screen with tabs for friends and friend requests
/// Features Instagram-like aesthetic with clean design and smooth animations
class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;
  
  // int _selectedIndex = 0; // TODO: Use for tab state if needed
  
  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 2, vsync: this);
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));
    
    _contentAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
    
    _startAnimations();
  }

  void _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _contentController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Premium Header
            _buildHeader(),
            
            // Tab Bar
            const SizedBox(height: AppDimensions.spacingM),
            _buildTabBar(),
            
            // Content Area
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _headerAnimation.value)),
          child: Opacity(
            opacity: _headerAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.sageGreen,
                    AppColors.sageGreenLight,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusXXL),
                  bottomRight: Radius.circular(AppDimensions.radiusXXL),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.pearlWhite.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Header content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.spacingM,
                      AppDimensions.screenPadding,
                      AppDimensions.spacingXL,
                    ),
                    child: Column(
                      children: [
                        // Top row
                        Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.pearlWhite.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.pearlWhite,
                                  size: 18,
                                ),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Title
                            Text(
                              'Friends',
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.pearlWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Search button
                            GestureDetector(
                              onTap: () => _handleSearch(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.pearlWhite.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                ),
                                child: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.pearlWhite,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Summary
                        Row(
                          children: [
                            Text(
                              'Manage your connections',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.pearlWhite.withValues(alpha: 0.9),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Friends count
                            Consumer(
                              builder: (context, ref, _) {
                                final friendsCount = ref.watch(friendsCountProvider);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.spacingM,
                                    vertical: AppDimensions.spacingXS,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.pearlWhite.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                  ),
                                  child: Text(
                                    '$friendsCount ${friendsCount == 1 ? 'friend' : 'friends'}',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.pearlWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoal.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
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
              color: AppColors.sageGreen.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.pearlWhite,
        unselectedLabelColor: AppColors.softCharcoalLight,
        labelStyle: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_rounded,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text('Friends'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_rounded,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text('Requests'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _contentAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _contentAnimation.value)),
          child: Opacity(
            opacity: _contentAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(top: AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusXXL),
                  topRight: Radius.circular(AppDimensions.radiusXXL),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softCharcoal.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _FriendsListTab(onFriendTap: _handleFriendTap),
                  _FriendRequestsTab(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSearch() {
    HapticFeedback.mediumImpact();
    // TODO: Implement search functionality
    debugPrint('Search friends');
  }

  void _handleFriendTap(UserSearchResult friend) {
    HapticFeedback.lightImpact();
    debugPrint('Friend tapped: ${friend.displayName}');
    
    // Navigate to user profile screen using GoRouter
    // Note: Profile screen now handles 404 errors gracefully with user-friendly messages
    context.push('/user-profile/${friend.id}');
  }
}

/// Friends list tab with Instagram-like UI
class _FriendsListTab extends ConsumerWidget {
  final Function(UserSearchResult) onFriendTap;

  const _FriendsListTab({required this.onFriendTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final friendsCount = ref.watch(friendsCountProvider);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.spacingXL,
        AppDimensions.screenPadding,
        AppDimensions.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'Your friends ($friendsCount)',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          
          // Friends list
          Expanded(
            child: friendsAsync.when(
              data: (friends) => _buildFriendsList(friends),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList(List<UserSearchResult> friends) {
    if (friends.isEmpty) {
      return _buildEmptyState('No friends yet', 'Connect with people to see them here');
    }
    
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return _FriendTile(
          friend: friend,
          onTap: () => onFriendTap(friend),
        ).animate(delay: Duration(milliseconds: 50 * index))
         .fadeIn(duration: 400.ms)
         .slideX(begin: 0.2);
      },
    );
  }
  
  Widget _buildLoadingState() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: AppColors.whisperGray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Row(
            children: [
              // Avatar shimmer
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.stoneGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(28),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity * 0.6,
                      decoration: BoxDecoration(
                        color: AppColors.stoneGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: double.infinity * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.stoneGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.dustyRose.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.dustyRose,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            'Unable to load friends',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            'Please check your connection and try again',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Retry button
          Consumer(
            builder: (context, ref, _) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.invalidate(friendsProvider);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Text(
                    'Try again',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.pearlWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.whisperGray.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 40,
              color: AppColors.softCharcoalLight,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Friend requests tab with sub-tabs for received and sent requests
class _FriendRequestsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FriendRequestsTab> createState() => _FriendRequestsTabState();
}

class _FriendRequestsTabState extends ConsumerState<_FriendRequestsTab>
    with TickerProviderStateMixin {
  late TabController _requestsTabController;
  
  @override
  void initState() {
    super.initState();
    _requestsTabController = TabController(length: 2, vsync: this);
    
    _requestsTabController.addListener(() {
      if (_requestsTabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
  }
  
  @override
  void dispose() {
    _requestsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for action errors and show snackbars
    ref.listen(friendRequestActionsProvider, (previous, next) {
      if (next.hasError && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
            ),
            backgroundColor: AppColors.dustyRose,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            margin: const EdgeInsets.all(AppDimensions.spacingM),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.spacingL,
        AppDimensions.screenPadding,
        AppDimensions.spacingL,
      ),
      child: Column(
        children: [
          // Sub-tabs for Received and Sent
          Container(
            decoration: BoxDecoration(
              color: AppColors.whisperGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: TabBar(
              controller: _requestsTabController,
              indicator: BoxDecoration(
                color: AppColors.sageGreen,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.pearlWhite,
              unselectedLabelColor: AppColors.softCharcoalLight,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Received'),
                Tab(text: 'Sent'),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Content area for sub-tabs
          Expanded(
            child: TabBarView(
              controller: _requestsTabController,
              children: [
                _ReceivedRequestsTab(),
                _SentRequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Received friend requests tab 
class _ReceivedRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(friendRequestsProvider);
    final requestsCount = ref.watch(friendRequestsCountProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'Received requests ($requestsCount)',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        
        // Requests list
        Expanded(
          child: requestsAsync.when(
            data: (requests) => _buildRequestsList(requests, ref),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(error.toString()),
          ),
        ),
      ],
    );
  }
  
  Widget _buildRequestsList(List<FriendRequest> requests, WidgetRef ref) {
    if (requests.isEmpty) {
      return _buildEmptyState('No pending requests', 'Friend requests will appear here');
    }
    
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _FriendRequestTile(
          request: request,
          onAccept: () => _handleAcceptRequest(request, context, ref),
          onReject: () => _handleRejectRequest(request, context, ref),
        ).animate(delay: Duration(milliseconds: 50 * index))
         .fadeIn(duration: 400.ms)
         .slideX(begin: 0.2);
      },
    );
  }
  
  void _handleAcceptRequest(FriendRequest request, BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final success = await ref.read(friendRequestActionsProvider.notifier).acceptFriendRequest(request.id);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Friend request accepted!',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
          ),
          backgroundColor: AppColors.sageGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          margin: const EdgeInsets.all(AppDimensions.spacingM),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleRejectRequest(FriendRequest request, BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final success = await ref.read(friendRequestActionsProvider.notifier).rejectFriendRequest(request.id);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Friend request declined',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
          ),
          backgroundColor: AppColors.dustyRose,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          margin: const EdgeInsets.all(AppDimensions.spacingM),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  Widget _buildLoadingState() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.sageGreen.withValues(alpha: 0.05),
                AppColors.warmPeach.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: AppColors.sageGreen.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              // User info shimmer
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.stoneGray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ).animate(onPlay: (controller) => controller.repeat())
                   .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                  
                  const SizedBox(width: AppDimensions.spacingM),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity * 0.6,
                          decoration: BoxDecoration(
                            color: AppColors.stoneGray.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat())
                         .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                        const SizedBox(height: 4),
                        Container(
                          height: 12,
                          width: double.infinity * 0.4,
                          decoration: BoxDecoration(
                            color: AppColors.stoneGray.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat())
                         .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Action buttons shimmer
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.stoneGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.stoneGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.dustyRose.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.dustyRose,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            'Unable to load requests',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            'Please check your connection and try again',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Retry button
          Consumer(
            builder: (context, ref, _) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.invalidate(friendRequestsProvider);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Text(
                    'Try again',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.pearlWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.whisperGray.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_outlined,
              size: 40,
              color: AppColors.softCharcoalLight,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Sent friend requests tab 
class _SentRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentRequestsAsync = ref.watch(sentFriendRequestsProvider);
    final sentRequestsCount = ref.watch(sentFriendRequestsCountProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'Sent requests ($sentRequestsCount)',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        
        // Sent requests list
        Expanded(
          child: sentRequestsAsync.when(
            data: (requests) => _buildSentRequestsList(requests),
            loading: () => _buildLoadingState(),
            error: (error, stack) => _buildErrorState(error.toString()),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSentRequestsList(List<FriendRequest> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState('No sent requests', 'Requests you send will appear here');
    }
    
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _SentRequestTile(
          request: request,
        ).animate(delay: Duration(milliseconds: 50 * index))
         .fadeIn(duration: 400.ms)
         .slideX(begin: 0.2);
      },
    );
  }
  
  Widget _buildLoadingState() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: AppColors.whisperGray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Row(
            children: [
              // Avatar shimmer
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.stoneGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(28),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
               .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // Content shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity * 0.6,
                      decoration: BoxDecoration(
                        color: AppColors.stoneGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: double.infinity * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.stoneGray.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 1200.ms, color: AppColors.pearlWhite.withValues(alpha: 0.3)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.dustyRose.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.dustyRose,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            'Unable to load sent requests',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            'Please check your connection and try again',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.whisperGray.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_outlined,
              size: 40,
              color: AppColors.softCharcoalLight,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Instagram-like friend tile
class _FriendTile extends StatelessWidget {
  final UserSearchResult friend;
  final VoidCallback onTap;

  const _FriendTile({
    required this.friend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: AppColors.whisperGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.stoneGray.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // Avatar with online status
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.sageGreen.withValues(alpha: 0.2),
                        AppColors.warmPeach.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.sageGreen.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      friend.initials,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.sageGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Online indicator
                if (friend.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.sageGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.pearlWhite,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.displayName,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.softCharcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '@${friend.username}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.softCharcoalLight,
                    ),
                  ),
                  if (friend.bio != null && friend.bio!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      friend.bio!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCharcoal,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Social battery indicator
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getBatteryColor(friend.socialBattery).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.battery_5_bar_rounded,
                    size: 12,
                    color: _getBatteryColor(friend.socialBattery),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${friend.socialBattery}%',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _getBatteryColor(friend.socialBattery),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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

  Color _getBatteryColor(int battery) {
    if (battery >= 80) return AppColors.sageGreen;
    if (battery >= 50) return AppColors.warmPeach;
    return AppColors.dustyRose;
  }
}

/// Friend request tile with accept/reject actions
class _FriendRequestTile extends ConsumerWidget {
  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _FriendRequestTile({
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(friendRequestActionsProvider);
    final isLoading = actionState.isLoading;
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen.withValues(alpha: 0.05),
            AppColors.warmPeach.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.sageGreen.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // User info row
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
                      AppColors.sageGreen.withValues(alpha: 0.2),
                      AppColors.warmPeach.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.sageGreen.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    request.sender?.initials ?? 'U',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.sageGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.sender?.displayName ?? 'Unknown User',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.softCharcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '@${request.sender?.username ?? 'unknown'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                    Text(
                      _formatTimeAgo(request.createdAt),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.softCharcoalLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Social battery
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _getBatteryColor(request.sender?.socialBattery ?? 75).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  '${request.sender?.socialBattery ?? 75}%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getBatteryColor(request.sender?.socialBattery ?? 75),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          // Message if present
          if (request.message != null) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: AppColors.whisperGray.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Text(
                request.message!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCharcoal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isLoading ? null : onReject,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isLoading 
                        ? AppColors.stoneGray.withValues(alpha: 0.1)
                        : AppColors.dustyRose.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(
                        color: isLoading
                          ? AppColors.stoneGray.withValues(alpha: 0.2)
                          : AppColors.dustyRose.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.softCharcoalLight,
                            ),
                          )
                        : Text(
                            'Decline',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.dustyRose,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingS),
              
              Expanded(
                child: GestureDetector(
                  onTap: isLoading ? null : onAccept,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isLoading
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.stoneGray.withValues(alpha: 0.3),
                              AppColors.stoneGray.withValues(alpha: 0.2),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.sageGreen,
                              AppColors.sageGreen.withValues(alpha: 0.9),
                            ],
                          ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      boxShadow: isLoading
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.sageGreen.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                    ),
                    child: Center(
                      child: isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.pearlWhite,
                            ),
                          )
                        : Text(
                            'Accept',
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
    );
  }

  Color _getBatteryColor(int battery) {
    if (battery >= 80) return AppColors.sageGreen;
    if (battery >= 50) return AppColors.warmPeach;
    return AppColors.dustyRose;
  }
  
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

/// Sent friend request tile - shows requests user has sent to others
class _SentRequestTile extends StatelessWidget {
  final FriendRequest request;

  const _SentRequestTile({
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmPeach.withValues(alpha: 0.05),
            AppColors.sageGreen.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.warmPeach.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // User info row
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
                      AppColors.warmPeach.withValues(alpha: 0.2),
                      AppColors.sageGreen.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.warmPeach.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    request.receiver?.initials ?? 'U',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.warmPeach,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.receiver?.displayName ?? 'Unknown User',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.softCharcoal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '@${request.receiver?.username ?? 'unknown'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                    Text(
                      _formatTimeAgo(request.createdAt),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.softCharcoalLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warmPeach.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: AppColors.warmPeach,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Pending',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.warmPeach,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Message if present
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: AppColors.whisperGray.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Text(
                '"${request.message!}"',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCharcoal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}