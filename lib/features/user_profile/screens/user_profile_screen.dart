import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/user_profile_model.dart';
import '../services/user_profile_service.dart';

/// Provider for UserProfileService instance
final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});

/// Provider for user profile data
final userProfileProvider = FutureProvider.family<UserProfileModel, String>((ref, userId) async {
  final service = ref.read(userProfileServiceProvider);
  final result = await service.getUserProfile(userId);
  
  return result.when(
    success: (profile) => profile,
    failure: (error) {
      // Create a special exception that includes the status code for better error handling
      throw UserProfileException(error.message, error.statusCode);
    },
  );
});

/// Custom exception for user profile errors
class UserProfileException implements Exception {
  final String message;
  final int? statusCode;
  
  const UserProfileException(this.message, this.statusCode);
  
  @override
  String toString() => message;
  
  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401 || statusCode == 403;
}

/// Stunning user profile screen with privacy-aware content
/// Features beautiful design, friend/non-friend states, and premium interactions
class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  double _scrollOffset = 0.0;
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
    _setupAnimations();
  }

  void _setupScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      _isHeaderCollapsed = _scrollOffset > 200;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider(widget.userId));

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: profileAsync.when(
        data: (profile) => _buildProfileContent(profile),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildProfileContent(UserProfileModel profile) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Stunning Profile Header
        _buildSliverProfileHeader(profile),
        
        // Profile Content
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.spacingL),
                
                // Bio Section (visible to friends)
                if (profile.isFriend && profile.bio != null)
                  _buildBioSection(profile),
                
                // Interests Section (visible to friends)
                if (profile.isFriend && profile.interests != null)
                  _buildInterestsSection(profile),
                
                // Profile Stats Section
                _buildProfileStatsSection(profile),
                
                // Action Buttons
                _buildActionButtonsSection(profile),
                
                // Privacy Notice for Non-Friends
                if (profile.isNotFriend)
                  _buildPrivacyNoticeSection(),
                
                const SizedBox(height: AppDimensions.spacingXXXL),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Profile Header - Stunning gradient with parallax effects
  Widget _buildSliverProfileHeader(UserProfileModel profile) {
    return SliverAppBar(
      expandedHeight: 300.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.sageGreen,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.pearlWhite),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.sageGreen,
                AppColors.lavenderMist,
                AppColors.warmPeach,
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Background patterns
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              
              // Profile content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60.h),
                    
                    // Profile Picture with elegant border
                    _buildProfilePicture(profile),
                    
                    SizedBox(height: AppDimensions.spacingL),
                    
                    // Display Name
                    Text(
                      profile.displayName,
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.pearlWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 28.sp,
                      ),
                    ).animate()
                     .fadeIn(duration: 600.ms, delay: 200.ms)
                     .slideY(begin: 0.3, end: 0),
                    
                    SizedBox(height: 4.h),
                    
                    // Username
                    Text(
                      '@${profile.username}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.pearlWhite.withOpacity(0.9),
                        fontSize: 16.sp,
                      ),
                    ).animate()
                     .fadeIn(duration: 600.ms, delay: 400.ms)
                     .slideY(begin: 0.3, end: 0),
                    
                    SizedBox(height: AppDimensions.spacingM),
                    
                    // Online Status & Social Battery (Friends only)
                    if (profile.isFriend)
                      _buildStatusIndicators(profile)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Profile Picture with beautiful border effects
  Widget _buildProfilePicture(UserProfileModel profile) {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.warmPeach, AppColors.dustyRose],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.pearlWhite,
          image: profile.profilePictureUrl != null
              ? DecorationImage(
                  image: NetworkImage(profile.profilePictureUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: profile.profilePictureUrl == null
            ? Center(
                child: Text(
                  profile.initials,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 36.sp,
                  ),
                ),
              )
            : null,
      ),
    ).animate()
     .scale(duration: 800.ms, curve: Curves.easeOutCubic)
     .fadeIn(duration: 600.ms);
  }
  
  // Status Indicators for friends
  Widget _buildStatusIndicators(UserProfileModel profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Online Status
        if (profile.isOnline == true) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.sageGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.sageGreen,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: AppColors.sageGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Online',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.pearlWhite,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
        ],
        
        // Social Battery
        if (profile.socialBatteryLevel != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.battery_charging_full,
                  size: 14.w,
                  color: AppColors.pearlWhite,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${profile.socialBatteryLevel}%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.pearlWhite,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  // Bio Section for friends
  Widget _buildBioSection(UserProfileModel profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      padding: EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            profile.bio!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoal,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms, delay: 200.ms)
     .slideY(begin: 0.3, end: 0);
  }
  
  // Interests Section for friends
  Widget _buildInterestsSection(UserProfileModel profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.spacingL),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
            child: Text(
              'Interests',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingM),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: profile.interests!.map((interest) => Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.sageGreen, AppColors.sageGreenLight],
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                interest,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.pearlWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms, delay: 400.ms)
     .slideY(begin: 0.3, end: 0);
  }
  
  // Profile Stats Section
  Widget _buildProfileStatsSection(UserProfileModel profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      padding: EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.whisperGray.withOpacity(0.3),
            AppColors.pearlWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.whisperGray.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: AppColors.softCharcoalLight,
                size: 20.w,
              ),
              SizedBox(width: AppDimensions.spacingS),
              Text(
                'Profile Stats',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.calendar_today,
                  label: 'Member since',
                  value: profile.memberSince,
                ),
              ),
              SizedBox(width: AppDimensions.spacingL),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people_outline,
                  label: 'Mutual friends',
                  value: profile.mutualFriendsCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms, delay: 600.ms)
     .slideY(begin: 0.3, end: 0);
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.sageGreen,
          size: 24.w,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  // Action Buttons Section based on friendship status
  Widget _buildActionButtonsSection(UserProfileModel profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Column(
        children: [
          SizedBox(height: AppDimensions.spacingL),
          
          if (profile.isFriend) ...[
            // Friend Actions
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.message,
                    label: 'Send Message',
                    color: AppColors.sageGreen,
                    onTap: () => _onSendMessage(profile),
                  ),
                ),
                SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.schedule,
                    label: 'Time Capsule',
                    color: AppColors.warmPeach,
                    onTap: () => _onSendTimeCapsule(profile),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.link,
                    label: 'Connection Stone',
                    color: AppColors.dustyRose,
                    onTap: () => _onShareConnectionStone(profile),
                  ),
                ),
                SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.menu_book,
                    label: 'Reading Invite',
                    color: AppColors.lavenderMist,
                    onTap: () => _onSendReadingInvite(profile),
                  ),
                ),
              ],
            ),
          ] else if (profile.isPending) ...[
            // Pending Request
            _buildActionButton(
              icon: Icons.hourglass_empty,
              label: 'Request Sent',
              color: AppColors.softCharcoalLight,
              onTap: null, // Disabled
            ),
          ] else ...[
            // Non-Friend Actions
            _buildActionButton(
              icon: Icons.person_add,
              label: 'Add Friend',
              color: AppColors.sageGreen,
              onTap: () => _onAddFriend(profile),
            ),
            SizedBox(height: AppDimensions.spacingM),
            _buildActionButton(
              icon: Icons.message,
              label: 'Send Message',
              color: AppColors.warmPeach,
              onTap: () => _onSendMessage(profile),
            ),
          ],
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms, delay: 800.ms)
     .slideY(begin: 0.3, end: 0);
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          decoration: BoxDecoration(
            gradient: isDisabled 
              ? null 
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.8)],
                ),
            color: isDisabled ? AppColors.whisperGray.withOpacity(0.5) : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: isDisabled ? null : [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isDisabled ? AppColors.softCharcoalLight : AppColors.pearlWhite,
                size: 20.w,
              ),
              SizedBox(width: AppDimensions.spacingS),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isDisabled ? AppColors.softCharcoalLight : AppColors.pearlWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Privacy Notice for Non-Friends
  Widget _buildPrivacyNoticeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      padding: EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.whisperGray.withOpacity(0.3),
            AppColors.stoneGray.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.whisperGray.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock_outline,
            color: AppColors.softCharcoalLight,
            size: 32.w,
          ),
          SizedBox(height: AppDimensions.spacingM),
          Text(
            'Privacy Protected',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            'This user keeps their personal information private. Become friends to see more details about their interests and activities.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCharcoalLight,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 600.ms, delay: 1000.ms)
     .slideY(begin: 0.3, end: 0);
  }
  
  // Loading State
  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
        ),
      ),
    );
  }
  
  // Error State
  Widget _buildErrorState(Object error) {
    // Handle different types of errors
    String title;
    String message;
    IconData icon;
    
    if (error is UserProfileException) {
      if (error.isNotFound) {
        title = 'Profile Not Found';
        message = 'This user profile could not be found or is no longer available.';
        icon = Icons.person_off_outlined;
      } else if (error.isUnauthorized) {
        title = 'Access Denied';
        message = 'You don\'t have permission to view this profile.';
        icon = Icons.lock_outline;
      } else {
        title = 'Unable to Load Profile';
        message = error.message;
        icon = Icons.error_outline;
      }
    } else {
      title = 'Unable to Load Profile';
      message = error.toString();
      icon = Icons.error_outline;
    }
    
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.softCharcoal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64.w,
                color: AppColors.dustyRose,
              ),
              SizedBox(height: AppDimensions.spacingL),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.softCharcoal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spacingS),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spacingXL),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Go back button
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.whisperGray,
                        foregroundColor: AppColors.softCharcoal,
                      ),
                      child: const Text('Go Back'),
                    ),
                  ),
                  
                  // Only show retry for non-404 errors
                  if (error is! UserProfileException || !error.isNotFound) ...[
                    SizedBox(width: AppDimensions.spacingM),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => ref.refresh(userProfileProvider(widget.userId)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sageGreen,
                          foregroundColor: AppColors.pearlWhite,
                        ),
                        child: const Text('Retry'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Action Handlers
  void _onSendMessage(UserProfileModel profile) {
    HapticFeedback.lightImpact();
    // Navigate to chat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${profile.displayName}...'),
        backgroundColor: AppColors.sageGreen,
      ),
    );
  }
  
  void _onSendTimeCapsule(UserProfileModel profile) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating time capsule for ${profile.displayName}...'),
        backgroundColor: AppColors.warmPeach,
      ),
    );
  }
  
  void _onShareConnectionStone(UserProfileModel profile) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing connection stone with ${profile.displayName}...'),
        backgroundColor: AppColors.dustyRose,
      ),
    );
  }
  
  void _onSendReadingInvite(UserProfileModel profile) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending reading invite to ${profile.displayName}...'),
        backgroundColor: AppColors.lavenderMist,
      ),
    );
  }
  
  void _onAddFriend(UserProfileModel profile) {
    HapticFeedback.mediumImpact();
    // Send friend request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request sent to ${profile.displayName}!'),
        backgroundColor: AppColors.sageGreen,
      ),
    );
  }
}