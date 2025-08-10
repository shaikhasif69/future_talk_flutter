import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/user_profile_model.dart';
import '../widgets/collapsible_profile_header.dart';
import '../widgets/connection_status_card.dart';

/// Premium user profile screen with advanced scrolling behavior
/// Features unified scrolling, collapsible header, and rich content sections
class UserProfileScreen extends StatefulWidget {
  final String userId;
  final UserProfileModel? userProfile;

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.userProfile,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _contentAnimationController;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  
  // Mock user profile data - in real app, this would come from a provider
  late UserProfileModel userProfile;
  
  double _scrollOffset = 0.0;
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollController();
    _setupAnimations();
  }

  void _initializeData() {
    // Use provided profile or load mock data
    userProfile = widget.userProfile ?? UserProfileMockData.sarahProfile;
  }

  void _setupScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _setupAnimations() {
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Start content animation after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentAnimationController.forward();
      }
    });
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      _isHeaderCollapsed = _scrollOffset > 150;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Collapsible Header with Parallax Effects
          CollapsibleProfileHeader(
            userProfile: userProfile,
            scrollController: _scrollController,
            onBackPressed: () => Navigator.of(context).pop(),
            onMessagePressed: _onMessagePressed,
            onMorePressed: _onMorePressed,
          ),
          
          // Connection Status Card (Overlaps header)
          SliverToBoxAdapter(
            child: ConnectionStatusCard(
              userProfile: userProfile,
              onTouchStone: _onTouchStone,
              onSendMessage: _onMessagePressed,
            ),
          ),
          
          // Main Content Sections
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _contentFadeAnimation,
                  child: SlideTransition(
                    position: _contentSlideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppDimensions.spacingXL),
                          _buildSharedExperiencesSection(),
                          const SizedBox(height: AppDimensions.spacingXL),
                          _buildTimeCapsuleSection(),
                          const SizedBox(height: AppDimensions.spacingXL),
                          _buildReadingTogetherSection(),
                          const SizedBox(height: AppDimensions.spacingXL),
                          _buildComfortStonesSection(),
                          const SizedBox(height: AppDimensions.spacingXL),
                          _buildFriendshipStatsSection(),
                          const SizedBox(height: AppDimensions.spacingXXXL),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharedExperiencesSection() {
    return _buildContentSection(
      title: 'Shared Experiences',
      subtitle: '${userProfile.sharedExperiences.length} together',
      icon: '🤝',
      child: _buildExperiencesGrid(),
    );
  }

  Widget _buildExperiencesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
      ),
      itemCount: userProfile.sharedExperiences.length,
      itemBuilder: (context, index) {
        final experience = userProfile.sharedExperiences[index];
        return _buildExperienceCard(experience);
      },
    );
  }

  Widget _buildExperienceCard(SharedExperience experience) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: () {
          HapticFeedback.lightImpact();
          _onExperienceTapped(experience);
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.warmCream, AppColors.pearlWhite],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: AppColors.sageGreen.withAlpha(26),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                experience.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.softCharcoal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                experience.subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCapsuleSection() {
    return _buildContentSection(
      title: 'Time Capsule History',
      subtitle: '${userProfile.timeCapsules.length} messages',
      icon: '⏰',
      child: Column(
        children: userProfile.timeCapsules.map((capsule) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: _buildTimeCapsuleCard(capsule),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeCapsuleCard(TimeCapsuleItem capsule) {
    final isDelivered = capsule.status == CapsuleStatus.delivered;
    final borderColor = capsule.isFromCurrentUser 
        ? AppColors.sageGreen 
        : AppColors.lavenderMist;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: () {
          HapticFeedback.lightImpact();
          _onTimeCapsuleTapped(capsule);
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                borderColor.withAlpha(13),
                AppColors.pearlWhite,
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border(
              left: BorderSide(
                color: borderColor,
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    capsule.isFromCurrentUser ? 'To ${userProfile.name}' : 'From ${userProfile.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: borderColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatCapsuleDate(capsule),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.softCharcoalLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                capsule.preview,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.softCharcoal,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Crimson Pro',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingTogetherSection() {
    return _buildContentSection(
      title: 'Reading Together',
      subtitle: 'Currently: ${userProfile.readingSessions.where((s) => s.status == ReadingStatus.active).length} active',
      icon: '📖',
      child: Column(
        children: userProfile.readingSessions.map((session) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: _buildReadingSessionCard(session),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReadingSessionCard(ReadingSession session) {
    final isActive = session.status == ReadingStatus.active;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: () {
          HapticFeedback.lightImpact();
          _onReadingSessionTapped(session);
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.warmPeach.withAlpha(13),
                AppColors.pearlWhite,
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border(
              left: BorderSide(
                color: AppColors.warmPeach,
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Book cover
              Container(
                width: 48,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.warmPeach, AppColors.dustyRose],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Center(
                  child: Text(
                    session.bookCover,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingL),
              
              // Book info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.bookTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.softCharcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${session.author} • Chapter ${session.currentChapter} of ${session.totalChapters}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive 
                          ? 'Last read: ${_formatLastRead(session.lastReadAt)}'
                          : 'Finished: ${_formatLastRead(session.lastReadAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.softCharcoalLight,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    
                    // Progress bar
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.whisperGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: session.progressPercentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.warmPeach, AppColors.dustyRose],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComfortStonesSection() {
    return _buildContentSection(
      title: '${userProfile.name}\'s Comfort Stones',
      subtitle: '${userProfile.comfortStones.length} shared with you',
      icon: '🪨',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: AppDimensions.spacingM,
          mainAxisSpacing: AppDimensions.spacingM,
        ),
        itemCount: userProfile.comfortStones.length,
        itemBuilder: (context, index) {
          final stone = userProfile.comfortStones[index];
          return _buildComfortStoneCard(stone);
        },
      ),
    );
  }

  Widget _buildComfortStoneCard(ComfortStone stone) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        onTap: () {
          HapticFeedback.mediumImpact();
          _onComfortStoneTapped(stone);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.dustyRose.withAlpha(26),
                AppColors.warmPeach.withAlpha(26),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: stone.isActive 
                ? [
                    BoxShadow(
                      color: AppColors.dustyRose.withAlpha(77),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: stone.isActive 
                    ? (Matrix4.identity()..scale(1.1))
                    : Matrix4.identity(),
                child: Text(
                  stone.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                stone.name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.softCharcoal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                stone.isActive 
                    ? 'Touched ${_formatLastTouched(stone.lastTouchedAt!)}'
                    : '${stone.totalTouches} touches today',
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.softCharcoalLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendshipStatsSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.sageGreen, AppColors.sageGreenLight],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withAlpha(77),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Your Friendship Journey',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Playfair Display',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Text(
                  '✨',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          _buildStatsGrid(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      ('${userProfile.friendshipStats.totalDays}', 'Days of friendship'),
      ('${userProfile.friendshipStats.meaningfulConversations}', 'Thoughtful conversations'),
      ('${userProfile.friendshipStats.hoursReadingTogether}h', 'Reading together'),
      ('${userProfile.friendshipStats.comfortTouchesShared}', 'Comfort touches shared'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: AppDimensions.spacingL,
        mainAxisSpacing: AppDimensions.spacingL,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final (number, label) = stats[index];
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(26),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Playfair Display',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withAlpha(230),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection({
    required String title,
    required String subtitle,
    required String icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.softCharcoal,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: AppDimensions.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.sageGreen.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.softCharcoalLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          child,
        ],
      ),
    );
  }

  // Event handlers
  void _onMessagePressed() {
    HapticFeedback.lightImpact();
    // Navigate to chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening chat...')),
    );
  }

  void _onMorePressed() {
    HapticFeedback.lightImpact();
    // Show more options
    _showMoreOptionsBottomSheet();
  }

  void _onTouchStone() {
    HapticFeedback.mediumImpact();
    // Trigger stone touch animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You touched ${userProfile.name}\'s comfort stone ✨'),
        backgroundColor: AppColors.sageGreen,
      ),
    );
  }

  void _onExperienceTapped(SharedExperience experience) {
    // Navigate to experience details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${experience.title}')),
    );
  }

  void _onTimeCapsuleTapped(TimeCapsuleItem capsule) {
    // Open time capsule
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening time capsule from ${_formatCapsuleDate(capsule)}')),
    );
  }

  void _onReadingSessionTapped(ReadingSession session) {
    // Navigate to reading session
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${session.bookTitle}')),
    );
  }

  void _onComfortStoneTapped(ComfortStone stone) {
    // Touch comfort stone
    setState(() {
      // In real app, this would update via provider
      final updatedStone = stone.copyWith(
        isActive: true,
        lastTouchedAt: DateTime.now(),
        totalTouches: stone.totalTouches + 1,
      );
      final stoneIndex = userProfile.comfortStones.indexOf(stone);
      userProfile = userProfile.copyWith(
        comfortStones: [
          ...userProfile.comfortStones.sublist(0, stoneIndex),
          updatedStone,
          ...userProfile.comfortStones.sublist(stoneIndex + 1),
        ],
      );
    });

    // Reset stone active state after animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          final stoneIndex = userProfile.comfortStones.indexWhere((s) => s.id == stone.id);
          if (stoneIndex != -1) {
            final updatedStone = userProfile.comfortStones[stoneIndex].copyWith(isActive: false);
            userProfile = userProfile.copyWith(
              comfortStones: [
                ...userProfile.comfortStones.sublist(0, stoneIndex),
                updatedStone,
                ...userProfile.comfortStones.sublist(stoneIndex + 1),
              ],
            );
          }
        });
      }
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You touched the ${stone.name} stone 🪨'),
        backgroundColor: AppColors.dustyRose,
      ),
    );
  }

  void _showMoreOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
        decoration: const BoxDecoration(
          color: AppColors.pearlWhite,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXXL),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.whisperGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            const Text(
              'Profile Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.softCharcoal,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            _buildOptionTile('Block User', Icons.block, AppColors.error),
            _buildOptionTile('Report Profile', Icons.report, AppColors.error),
            _buildOptionTile('Share Profile', Icons.share, AppColors.sageGreen),
            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String title, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title selected')),
        );
      },
    );
  }

  // Utility methods
  String _formatCapsuleDate(TimeCapsuleItem capsule) {
    final now = DateTime.now();
    final difference = now.difference(capsule.deliveryDate);
    
    if (capsule.status == CapsuleStatus.scheduled) {
      final daysUntil = capsule.deliveryDate.difference(now).inDays;
      return 'Opens in $daysUntil days';
    } else if (difference.inDays == 0) {
      return 'Delivered today';
    } else {
      return 'Delivered ${difference.inDays} days ago';
    }
  }

  String _formatLastRead(DateTime lastRead) {
    final now = DateTime.now();
    final difference = now.difference(lastRead);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  String _formatLastTouched(DateTime lastTouched) {
    final now = DateTime.now();
    final difference = now.difference(lastTouched);
    
    if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}