import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/user_profile_model.dart';

/// Premium collapsible header with parallax effects and smooth animations
/// Expands/collapses based on scroll position for optimal space utilization
class CollapsibleProfileHeader extends StatefulWidget {
  final UserProfileModel userProfile;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMessagePressed;
  final VoidCallback? onMorePressed;
  final ScrollController scrollController;

  const CollapsibleProfileHeader({
    super.key,
    required this.userProfile,
    required this.scrollController,
    this.onBackPressed,
    this.onMessagePressed,
    this.onMorePressed,
  });

  @override
  State<CollapsibleProfileHeader> createState() => _CollapsibleProfileHeaderState();
}

class _CollapsibleProfileHeaderState extends State<CollapsibleProfileHeader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _batteryPulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _batteryPulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Main animation controller for header transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Battery pulse animation controller
    _batteryPulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade animation for text elements
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Scale animation for avatar
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    // Slide animation for details
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    // Battery pulse animation
    _batteryPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _batteryPulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _animationController.forward();
    _batteryPulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _batteryPulseController.dispose();
    super.dispose();
  }

  Color get _batteryColor {
    switch (widget.userProfile.currentMoodStatus.level) {
      case BatteryLevel.green:
        return AppColors.success;
      case BatteryLevel.yellow:
        return AppColors.warning;
      case BatteryLevel.orange:
        return AppColors.warmPeach;
      case BatteryLevel.red:
        return AppColors.error;
    }
  }

  String get _batteryIcon {
    switch (widget.userProfile.currentMoodStatus.level) {
      case BatteryLevel.green:
        return '🟢';
      case BatteryLevel.yellow:
        return '🟡';
      case BatteryLevel.orange:
        return '🟠';
      case BatteryLevel.red:
        return '🔴';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _batteryPulseController]),
      builder: (context, child) {
        return SliverAppBar(
          expandedHeight: 320.0,
          pinned: true,
          stretch: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: _buildBackButton(),
          actions: _buildActions(),
          flexibleSpace: _buildFlexibleSpace(),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      child: Material(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onBackPressed?.call();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: AppDimensions.iconS,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      _buildActionButton(
        icon: Icons.message_rounded,
        onTap: widget.onMessagePressed,
      ),
      _buildActionButton(
        icon: Icons.more_horiz_rounded,
        onTap: widget.onMorePressed,
      ),
      const SizedBox(width: AppDimensions.spacingS),
    ];
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.spacingS),
      child: Material(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: AppDimensions.iconS,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      stretchModes: const [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
      ],
      background: Stack(
        fit: StackFit.expand,
        children: [
          _buildGradientBackground(),
          _buildParallaxElements(),
          _buildProfileContent(),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lavenderMist,
            AppColors.dustyRose,
            AppColors.warmPeach,
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
    );
  }

  Widget _buildParallaxElements() {
    return Stack(
      children: [
        // Large decorative circle - top right
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        // Medium decorative circle - bottom left
        Positioned(
          bottom: -30,
          left: -30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        // Small floating elements
        Positioned(
          top: 100,
          right: 60,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 80,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent() {
    return Positioned(
      left: AppDimensions.screenPadding,
      right: AppDimensions.screenPadding,
      bottom: AppDimensions.spacingXXL,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileAvatar(),
              const SizedBox(width: AppDimensions.spacingL),
              Expanded(child: _buildProfileDetails()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.sageGreen, AppColors.warmPeach],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Avatar content
            Center(
              child: Text(
                widget.userProfile.name.isNotEmpty 
                    ? widget.userProfile.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            // Battery indicator
            Positioned(
              bottom: -2,
              right: -2,
              child: AnimatedBuilder(
                animation: _batteryPulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _batteryPulseAnimation.value,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _batteryColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _batteryColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    final friendshipDuration = DateTime.now().difference(widget.userProfile.friendsSince);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name
        Text(
          widget.userProfile.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Playfair Display',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        
        // Username
        Text(
          widget.userProfile.username,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        
        // Friends since
        Text(
          'Friends since ${_formatDate(widget.userProfile.friendsSince)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        
        // Bio
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            widget.userProfile.bio,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
              height: 1.4,
              fontFamily: 'Crimson Pro',
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

/// Animated background decoration for profile header
class ProfileHeaderBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  ProfileHeaderBackgroundPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, secondaryColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw animated background shapes
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * (0.9 + 0.1 * animation.value),
      0,
      size.height * 0.8,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}