import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/profile_data.dart';

/// Profile actions section with account management options
/// Features elegant action items with proper visual hierarchy
class ProfileActionsSection extends StatelessWidget {
  final List<ProfileAction> actions;
  final EdgeInsetsGeometry? margin;

  const ProfileActionsSection({
    super.key,
    required this.actions,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: AppDimensions.getResponsivePadding(screenWidth),
      ).copyWith(bottom: AppDimensions.spacingL),
      child: FTCard.elevated(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(),
            SizedBox(height: AppDimensions.spacingL),
            _buildActionsList(),
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Text(
          '👤',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(width: AppDimensions.spacingS),
        Text(
          'Account',
          style: AppTextStyles.headlineSmall.copyWith(
            fontFamily: AppTextStyles.headingFont,
            color: AppColors.softCharcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsList() {
    return Column(
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        final isLast = index == actions.length - 1;
        
        return Column(
          children: [
            ProfileActionItem(
              action: action,
              animationDelay: index * 100,
            ),
            if (!isLast)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.whisperGray,
                indent: 0,
                endIndent: 0,
              ),
          ],
        );
      }).toList(),
    );
  }
}

/// Individual profile action item with hover effects and animations
class ProfileActionItem extends StatefulWidget {
  final ProfileAction action;
  final int animationDelay;

  const ProfileActionItem({
    super.key,
    required this.action,
    this.animationDelay = 0,
  });

  @override
  State<ProfileActionItem> createState() => _ProfileActionItemState();
}

class _ProfileActionItemState extends State<ProfileActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    final hoverColor = widget.action.isDestructive
        ? AppColors.dustyRose.withValues(alpha: 0.05)
        : AppColors.sageGreen.withValues(alpha: 0.05);
    
    _backgroundColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: hoverColor,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _handleTapDown() {
    setState(() => _isPressed = true);
    HapticFeedback.selectionClick();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    widget.action.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      child: GestureDetector(
        onTapDown: (_) => _handleTapDown(),
        onTapUp: (_) => _handleTapUp(),
        onTapCancel: () => _handleTapCancel(),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.95 : _scaleAnimation.value,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingL,
                ),
                decoration: BoxDecoration(
                  color: _backgroundColorAnimation.value,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Row(
                  children: [
                    _buildActionIcon(),
                    SizedBox(width: AppDimensions.spacingM),
                    Expanded(child: _buildActionDetails()),
                    _buildActionArrow(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.animationDelay))
     .fadeIn(duration: 400.ms)
     .slideX(begin: 0.2);
  }

  Widget _buildActionIcon() {
    final iconColor = widget.action.isDestructive
        ? AppColors.dustyRose
        : AppColors.softCharcoal;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: widget.action.customColor?.withValues(alpha: 0.1) ??
            iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.action.icon,
          style: TextStyle(
            fontSize: 18,
            color: widget.action.customColor ?? iconColor,
          ),
        ),
      ),
    );
  }

  Widget _buildActionDetails() {
    final titleColor = widget.action.isDestructive
        ? AppColors.dustyRose
        : AppColors.softCharcoal;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.action.title,
          style: AppTextStyles.titleMedium.copyWith(
            color: widget.action.customColor ?? titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppDimensions.spacingXS),
        Text(
          widget.action.subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionArrow() {
    final arrowColor = widget.action.isDestructive
        ? AppColors.dustyRose
        : AppColors.softCharcoal;
    
    return AnimatedRotation(
      turns: _isHovered ? 0.05 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: arrowColor.withValues(alpha: 0.6),
      ),
    );
  }
}

/// Specialized logout action with confirmation dialog
class LogoutActionItem extends StatelessWidget {
  final VoidCallback onLogout;
  final int animationDelay;

  const LogoutActionItem({
    super.key,
    required this.onLogout,
    this.animationDelay = 0,
  });

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => LogoutConfirmationDialog(
        onConfirm: () {
          Navigator.of(context).pop(true);
          onLogout();
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );

    if (confirmed == true) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoutAction = ProfileAction(
      id: 'logout',
      title: 'Logout',
      subtitle: 'Sign out of your account',
      icon: '🚪',
      onTap: () => _showLogoutConfirmation(context),
      isDestructive: true,
    );

    return ProfileActionItem(
      action: logoutAction,
      animationDelay: animationDelay,
    );
  }
}

/// Custom logout confirmation dialog
class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FTCard.elevated(
        padding: const EdgeInsets.all(AppDimensions.spacingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.dustyRose.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '🚪',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingL),
            
            // Title
            Text(
              'Logout',
              style: AppTextStyles.headlineSmall.copyWith(
                fontFamily: AppTextStyles.headingFont,
                color: AppColors.softCharcoal,
              ),
            ),
            
            SizedBox(height: AppDimensions.spacingS),
            
            // Message
            Text(
              'Are you sure you want to logout? You\'ll need to sign in again to access your sanctuary.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: AppDimensions.spacingXXL),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingM,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.softCharcoal,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: AppDimensions.spacingM),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dustyRose,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingM,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
     .fadeIn(duration: 300.ms)
     .scale(begin: const Offset(0.8, 0.8));
  }
}

/// Quick actions grid for frequent actions
class QuickActionsGrid extends StatelessWidget {
  final List<ProfileAction> actions;
  final int maxRows;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.maxRows = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _QuickActionCard(
          action: action,
          animationDelay: index * 100,
        );
      },
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final ProfileAction action;
  final int animationDelay;

  const _QuickActionCard({
    required this.action,
    required this.animationDelay,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
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

  void _handleTapDown() {
    setState(() => _isPressed = true);
    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.action.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => _handleTapCancel(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FTCard.elevated(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.action.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  
                  SizedBox(height: AppDimensions.spacingS),
                  
                  Text(
                    widget.action.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: AppDimensions.spacingXS),
                  
                  Text(
                    widget.action.subtitle,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.softCharcoalLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate(delay: Duration(milliseconds: widget.animationDelay))
     .fadeIn(duration: 400.ms)
     .scale(begin: const Offset(0.8, 0.8));
  }
}