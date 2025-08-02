import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/profile_data.dart';

/// Premium profile header with gradient background and floating elements
/// Features avatar, name, username, bio, and decorative elements
class ProfileHeader extends StatefulWidget {
  final ProfileData profileData;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onAvatarTapped;
  final VoidCallback? onEditAvatarPressed;

  const ProfileHeader({
    super.key,
    required this.profileData,
    this.onBackPressed,
    this.onSettingsPressed,
    this.onAvatarTapped,
    this.onEditAvatarPressed,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader>
    with TickerProviderStateMixin {
  late AnimationController _decorationController;
  late AnimationController _avatarController;
  late Animation<double> _decorationAnimation;
  late Animation<double> _avatarScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _decorationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _decorationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _decorationController,
      curve: Curves.linear,
    ));
    
    _avatarScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.elasticOut,
    ));
    
    // Start continuous decoration animation
    _decorationController.repeat();
  }

  @override
  void dispose() {
    _decorationController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _handleAvatarTap() {
    HapticFeedback.mediumImpact();
    _avatarController.forward().then((_) => _avatarController.reverse());
    widget.onAvatarTapped?.call();
  }

  void _handleEditAvatarTap() {
    HapticFeedback.selectionClick();
    widget.onEditAvatarPressed?.call();
  }

  void _handleBackPressed() {
    HapticFeedback.lightImpact();
    widget.onBackPressed?.call();
  }

  void _handleSettingsPressed() {
    HapticFeedback.mediumImpact();
    widget.onSettingsPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: double.infinity,
      height: screenHeight * 0.35, // Fixed height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen,
            AppColors.sageGreenLight,
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Animated background decorations
          _buildBackgroundDecorations(),
          
          // Main header content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.getResponsivePadding(screenWidth),
                vertical: AppDimensions.spacingL,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderActions(),
                  SizedBox(height: AppDimensions.spacingXL),
                  _buildProfileInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return AnimatedBuilder(
      animation: _decorationAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Stack(
            children: [
            // Large floating circle
            Positioned(
              top: -50 + (_decorationAnimation.value * 20),
              right: -50 + (_decorationAnimation.value * 10),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            
            // Medium floating circle
            Positioned(
              bottom: -30 + (_decorationAnimation.value * -15),
              left: -30 + (_decorationAnimation.value * 8),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            
            // Small accent circle
            Positioned(
              top: 100 + (_decorationAnimation.value * 30),
              left: 50 + (_decorationAnimation.value * -20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
          ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        _HeaderActionButton(
          onPressed: _handleBackPressed,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        // Title
        Text(
          'Profile',
          style: AppTextStyles.headlineLarge.copyWith(
            color: Colors.white,
            fontFamily: AppTextStyles.headingFont,
          ),
        ),
        
        // Settings button
        _HeaderActionButton(
          onPressed: _handleSettingsPressed,
          child: const Icon(
            Icons.settings_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      children: [
        // Profile avatar with edit button
        _buildProfileAvatar(),
        
        SizedBox(width: AppDimensions.spacingXL),
        
        // Profile details
        Expanded(
          child: _buildProfileDetails(),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return AnimatedBuilder(
      animation: _avatarScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _avatarScaleAnimation.value,
          child: GestureDetector(
            onTap: _handleAvatarTap,
            child: Stack(
              children: [
                // Avatar container
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.profileData.avatarGradient,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.profileData.avatarInitials,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Edit button
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: GestureDetector(
                    onTap: _handleEditAvatarTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.sageGreen,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 12,
                        color: AppColors.sageGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display name
        Text(
          widget.profileData.displayName,
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            fontFamily: AppTextStyles.headingFont,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3),
        
        SizedBox(height: AppDimensions.spacingXS),
        
        // Username
        Text(
          widget.profileData.username,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 600.ms).slideX(begin: 0.3),
        
        SizedBox(height: AppDimensions.spacingS),
        
        // Bio
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            widget.profileData.bio,
            style: AppTextStyles.personalContent.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideX(begin: 0.3),
        ),
      ],
    );
  }
}

/// Custom header action button with backdrop blur effect
class _HeaderActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _HeaderActionButton({
    required this.onPressed,
    required this.child,
  });

  @override
  State<_HeaderActionButton> createState() => _HeaderActionButtonState();
}

class _HeaderActionButtonState extends State<_HeaderActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                color: Colors.white.withOpacity(_isPressed ? 0.3 : 0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  if (_isPressed)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Center(child: widget.child),
            ),
          );
        },
      ),
    );
  }
}