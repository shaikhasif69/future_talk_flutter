import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/menu_item.dart';
import 'side_menu_tile.dart';
import 'side_menu_info_card.dart';
import '../../auth/providers/auth_provider.dart';

class SideMenu extends ConsumerStatefulWidget {
  final VoidCallback? onSignOut;
  final VoidCallback? onMenuClose;

  const SideMenu({
    super.key,
    this.onSignOut,
    this.onMenuClose,
  });

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  MenuItem? selectedMenu;

  void _handleMenuTap(MenuItem menuItem) {
    HapticFeedback.selectionClick();
    setState(() {
      selectedMenu = menuItem;
    });
    
    // Close side menu before navigating
    if (widget.onMenuClose != null) {
      widget.onMenuClose!();
    }
    
    // Add a small delay to let the close animation start
    Future.delayed(const Duration(milliseconds: 100), () {
      // Handle navigation logic here
      if (mounted && menuItem.onTap != null) {
        menuItem.onTap!();
      }
    });
  }

  void _handleProfileTap() {
    HapticFeedback.selectionClick();
    
    // Close side menu before navigating
    if (widget.onMenuClose != null) {
      widget.onMenuClose!();
    }
    
    // Add a small delay to let the close animation start
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.push('/profile');
      }
    });
  }

  String _getUserDisplayName(dynamic user) {
    if (user == null) return 'Loading...';
    
    // Try display_name first, then username, then fallback
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    if (user.username != null && user.username!.isNotEmpty) {
      return user.username!;
    }
    return 'Future Talk User';
  }

  String _getUserSubtitle(dynamic user) {
    if (user == null) return 'Signing you in...';
    
    if (user.isPremium == true) {
      return 'Premium Member';
    }
    return 'Future Talk Member';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width / 1.35,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.softCharcoal,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.spacingM),
              
              // User info card - make it tappable to navigate to profile
              GestureDetector(
                onTap: _handleProfileTap,
                child: SideMenuInfoCard(
                  name: _getUserDisplayName(authState.user),
                  subtitle: _getUserSubtitle(authState.user),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Browse section
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.screenPadding,
                  top: AppDimensions.spacingM,
                  bottom: AppDimensions.spacingS,
                ),
                child: Text(
                  "Browse",
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.pearlWhite.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Main menu items
              ...getMainMenuItems(context).map((menu) => SideMenuTile(
                menuItem: menu,
                onTap: () => _handleMenuTap(menu),
                isActive: selectedMenu == menu,
              )),
              
              const SizedBox(height: AppDimensions.spacingXL),
              
              // Activity section
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.screenPadding,
                  top: AppDimensions.spacingM,
                  bottom: AppDimensions.spacingS,
                ),
                child: Text(
                  "Activity",
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.pearlWhite.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // History menu items
              ...getHistoryMenuItems(context).map((menu) => SideMenuTile(
                menuItem: menu,
                onTap: () => _handleMenuTap(menu),
                isActive: selectedMenu == menu,
              )),
              
              const Spacer(),
              
              // Settings/Logout section
              Container(
                margin: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.settings_rounded,
                        color: AppColors.pearlWhite.withValues(alpha: 0.8),
                      ),
                      title: Text(
                        'Settings',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.pearlWhite.withValues(alpha: 0.9),
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        // Handle settings navigation
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.logout_rounded,
                        color: AppColors.dustyRose,
                      ),
                      title: Text(
                        'Sign Out',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.dustyRose,
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.onSignOut?.call();
                      },
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
}