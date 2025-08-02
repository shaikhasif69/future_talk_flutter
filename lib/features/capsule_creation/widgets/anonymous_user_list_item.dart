import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/anonymous_user_model.dart';

/// List item widget for displaying anonymous users in search results
/// Implements privacy-focused design with selection capabilities
class AnonymousUserListItem extends StatefulWidget {
  /// The anonymous user to display
  final AnonymousUser user;
  
  /// Whether this user is currently selected
  final bool isSelected;
  
  /// Callback when user is tapped for selection
  final VoidCallback onTap;
  
  /// Animation delay for staggered list animations
  final Duration animationDelay;

  const AnonymousUserListItem({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  @override
  State<AnonymousUserListItem> createState() => _AnonymousUserListItemState();
}

class _AnonymousUserListItemState extends State<AnonymousUserListItem>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _selectionController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    
    // Slide in animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    
    // Selection animation
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _selectionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeOut,
    ));

    // Start slide animation with delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(AnonymousUserListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle selection animation
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _selectionController.forward();
      } else {
        _selectionController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Haptic feedback for selection
    HapticFeedback.selectionClick();
    
    // Bounce animation
    _selectionController.forward().then((_) {
      if (mounted) {
        _selectionController.reverse();
      }
    });
    
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _selectionAnimation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleTap,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? AppColors.lavenderMist.withOpacity(0.05)
                          : AppColors.pearlWhite,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(
                        color: widget.isSelected
                            ? AppColors.lavenderMist
                            : AppColors.whisperGray.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.lavenderMist.withOpacity(0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    transform: Matrix4.identity()
                      ..scale(
                        1.0 + (_selectionAnimation.value * 0.02),
                        1.0 + (_selectionAnimation.value * 0.02),
                      ),
                    child: Stack(
                      children: [
                        // Selection highlight bar (top)
                        if (widget.isSelected)
                          Positioned(
                            top: -AppDimensions.paddingL,
                            left: -AppDimensions.paddingL,
                            right: -AppDimensions.paddingL,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.lavenderMist, AppColors.lavenderMist],
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusL,
                                ).copyWith(
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                ),
                              ),
                            ),
                          ),
                        
                        // Main content
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: widget.user.avatarGradientColors
                                      .map((color) => Color(
                                            int.parse(color.substring(1), radix: 16) + 0xFF000000,
                                          ))
                                      .toList(),
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.softCharcoalWithOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  widget.user.avatarInitials,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    color: AppColors.pearlWhite,
                                    fontWeight: FontWeight.w500,
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
                                  // Name
                                  Text(
                                    widget.user.name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.softCharcoal,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 2),
                                  
                                  // Username
                                  Text(
                                    '@${widget.user.username}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.softCharcoalLight,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: AppDimensions.spacingXS),
                                  
                                  // Privacy badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.spacingS,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lavenderMist.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.security,
                                          size: 10,
                                          color: AppColors.lavenderMist,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.user.privacyBadgeText,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.lavenderMist,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Selection indicator
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: widget.isSelected
                                    ? AppColors.lavenderMist
                                    : Colors.transparent,
                                border: Border.all(
                                  color: widget.isSelected
                                      ? AppColors.lavenderMist
                                      : AppColors.whisperGray,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: widget.isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: AppColors.pearlWhite,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}