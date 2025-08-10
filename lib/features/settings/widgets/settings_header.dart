import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Premium settings header with gradient background and smooth animations
class SettingsHeader extends StatefulWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onSearchPressed;

  const SettingsHeader({
    super.key,
    required this.onBackPressed,
    required this.onSearchPressed,
  });

  @override
  State<SettingsHeader> createState() => _SettingsHeaderState();
}

class _SettingsHeaderState extends State<SettingsHeader>
    with TickerProviderStateMixin {
  late AnimationController _backButtonController;
  late AnimationController _searchButtonController;
  late Animation<double> _backScaleAnimation;
  late Animation<double> _searchScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _backButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _searchButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _backScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _backButtonController,
      curve: Curves.easeOut,
    ));
    
    _searchScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _searchButtonController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _backButtonController.dispose();
    _searchButtonController.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    HapticFeedback.mediumImpact();
    _backButtonController.forward().then((_) {
      _backButtonController.reverse();
    });
    widget.onBackPressed();
  }

  void _onSearchPressed() {
    HapticFeedback.selectionClick();
    _searchButtonController.forward().then((_) {
      _searchButtonController.reverse();
    });
    widget.onSearchPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.sageGreen, AppColors.sageGreenLight],
        ),
      ),
      child: Stack(
        children: [
          // Decorative background elements
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.pearlWhite.withAlpha(26),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Header content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spacingXL,
              AppDimensions.spacingL,
              AppDimensions.spacingXL,
              AppDimensions.spacingXL,
            ),
            child: Row(
              children: [
                // Back button
                AnimatedBuilder(
                  animation: _backScaleAnimation,
                  child: _buildActionButton(
                    icon: Icons.arrow_back_ios,
                    onPressed: _onBackPressed,
                  ),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _backScaleAnimation.value,
                      child: child,
                    );
                  },
                ),
                
                // Title
                Expanded(
                  child: Center(
                    child: Text(
                      'Settings',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.pearlWhite,
                        fontFamily: AppTextStyles.headingFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Search button
                AnimatedBuilder(
                  animation: _searchScaleAnimation,
                  child: _buildActionButton(
                    icon: Icons.search,
                    onPressed: _onSearchPressed,
                  ),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _searchScaleAnimation.value,
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withAlpha(51),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoal.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          onTap: onPressed,
          child: Icon(
            icon,
            color: AppColors.pearlWhite,
            size: AppDimensions.iconS,
          ),
        ),
      ),
    );
  }
}