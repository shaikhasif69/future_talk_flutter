import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/menu_item.dart';
import 'side_menu_tile.dart';
import 'side_menu_info_card.dart';

class SideMenu extends ConsumerStatefulWidget {
  final String userName;
  final String userSubtitle;
  final VoidCallback? onSignOut;

  const SideMenu({
    super.key,
    required this.userName,
    required this.userSubtitle,
    this.onSignOut,
  });

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  MenuItem selectedMenu = mainMenuItems.first;

  void _handleMenuTap(MenuItem menuItem) {
    HapticFeedback.selectionClick();
    setState(() {
      selectedMenu = menuItem;
    });
    
    // Handle navigation logic here
    if (menuItem.onTap != null) {
      menuItem.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              
              // User info card
              SideMenuInfoCard(
                name: widget.userName,
                subtitle: widget.userSubtitle,
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
              ...mainMenuItems.map((menu) => SideMenuTile(
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
              ...historyMenuItems.map((menu) => SideMenuTile(
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