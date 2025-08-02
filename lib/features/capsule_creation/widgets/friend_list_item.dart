import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../models/friend_model.dart';

/// Friend list item widget with premium animations and social battery indicator
/// Matches the HTML design exactly with Flutter implementation
class FriendListItem extends StatefulWidget {
  const FriendListItem({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  final Friend friend;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration animationDelay;

  @override
  State<FriendListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    
    // Selection feedback animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    widget.onTap();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTFadeIn(
      delay: widget.animationDelay,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Material(
                elevation: _elevationAnimation.value,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: _handleTap,
                  onHover: _handleHover,
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(AppDimensions.spacingL),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.isSelected
                            ? AppColors.sageGreen
                            : _isHovered
                                ? AppColors.sageGreen.withOpacity(0.5)
                                : AppColors.whisperGray,
                        width: 2,
                      ),
                      gradient: widget.isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.sageGreen.withOpacity(0.05),
                                Colors.white,
                              ],
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        // Top gradient indicator for selected state
                        if (widget.isSelected)
                          Container(
                            height: 3,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: const LinearGradient(
                                colors: [AppColors.sageGreen, AppColors.sageGreenLight],
                              ),
                            ),
                          ),
                        
                        // Main content row
                        Row(
                          children: [
                            // Friend avatar
                            _buildAvatar(),
                            
                            const SizedBox(width: 12),
                            
                            // Friend info
                            Expanded(
                              child: _buildFriendInfo(),
                            ),
                            
                            const SizedBox(width: 8),
                            
                            // Friend meta (last active + selection check)
                            _buildFriendMeta(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    final gradientColors = widget.friend.avatarGradientColors;
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(int.parse(gradientColors[0].replaceFirst('#', '0xFF'))),
            Color(int.parse(gradientColors[1].replaceFirst('#', '0xFF'))),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.friend.avatarInitials,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Friend name
        Text(
          widget.friend.name,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.softCharcoal,
          ),
        ),
        
        const SizedBox(height: 2),
        
        // Social battery status
        Row(
          children: [
            // Battery indicator dot
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(
                  widget.friend.socialBattery.colorHex.replaceFirst('#', '0xFF')
                )),
              ),
            ),
            
            const SizedBox(width: 4),
            
            // Battery text
            Text(
              widget.friend.socialBattery.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.softCharcoalWithOpacity(0.38),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFriendMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Last active time
        Text(
          widget.friend.lastActiveDisplay,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCharcoalWithOpacity(0.38),
            fontSize: 10,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Selection check
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.isSelected 
                  ? AppColors.sageGreen 
                  : AppColors.whisperGray,
              width: 2,
            ),
            color: widget.isSelected 
                ? AppColors.sageGreen 
                : Colors.transparent,
          ),
          child: widget.isSelected
              ? const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )
              : null,
        ),
      ],
    );
  }
}

/// Social battery indicator widget for friend items
class SocialBatteryIndicator extends StatelessWidget {
  const SocialBatteryIndicator({
    super.key,
    required this.batteryLevel,
    this.size = 8.0,
  });

  final SocialBatteryLevel batteryLevel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(int.parse(
          batteryLevel.colorHex.replaceFirst('#', '0xFF')
        )),
        boxShadow: [
          BoxShadow(
            color: Color(int.parse(
              batteryLevel.colorHex.replaceFirst('#', '0xFF')
            )).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

/// Friend search bar widget
class FriendSearchBar extends StatefulWidget {
  const FriendSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search friends by name or username...',
  });

  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  State<FriendSearchBar> createState() => _FriendSearchBarState();
}

class _FriendSearchBarState extends State<FriendSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focusNode.hasFocus 
              ? AppColors.sageGreen 
              : AppColors.whisperGray,
          width: 2,
        ),
        boxShadow: _focusNode.hasFocus
            ? [
                BoxShadow(
                  color: AppColors.sageGreen.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 0),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.softCharcoal,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalWithOpacity(0.38),
            fontStyle: FontStyle.italic,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _focusNode.hasFocus 
                ? AppColors.sageGreen 
                : AppColors.softCharcoalWithOpacity(0.38),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  color: AppColors.softCharcoalWithOpacity(0.38),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}