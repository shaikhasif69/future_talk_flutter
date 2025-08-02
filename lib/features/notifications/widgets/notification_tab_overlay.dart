import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/notification_model.dart';

/// Premium tab overlay widget that appears to float above content
/// Implements smooth animations and haptic feedback
class NotificationTabOverlay extends StatefulWidget {
  /// Available notification types for tabs
  final List<NotificationType?> availableTabs;
  
  /// Currently selected tab
  final NotificationType? selectedTab;
  
  /// Callback when tab is selected
  final ValueChanged<NotificationType?> onTabSelected;
  
  /// Notification counts per type
  final Map<NotificationType?, int> notificationCounts;
  
  /// Total notification count for "All" tab
  final int totalCount;

  const NotificationTabOverlay({
    super.key,
    required this.availableTabs,
    required this.selectedTab,
    required this.onTabSelected,
    required this.notificationCounts,
    required this.totalCount,
  });

  @override
  State<NotificationTabOverlay> createState() => _NotificationTabOverlayState();
}

class _NotificationTabOverlayState extends State<NotificationTabOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  int? _hoveredIndex;
  int? _pressedIndex;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
    
    // Start entrance animation
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTabTap(int index) async {
    if (_pressedIndex == index) return;
    
    // Haptic feedback
    HapticFeedback.selectionClick();
    
    setState(() => _pressedIndex = index);
    _scaleController.forward();
    
    // Small delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 150));
    
    _scaleController.reverse();
    setState(() => _pressedIndex = null);
    
    // Determine selected tab
    final NotificationType? selectedTab = index == 0 ? null : widget.availableTabs[index - 1];
    widget.onTabSelected(selectedTab);
  }

  void _handleHover(int index, bool isHovered) {
    setState(() {
      _hoveredIndex = isHovered ? index : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.softCharcoal.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.softCharcoal.withOpacity(0.05),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.pearlWhite,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: _buildTabs(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    final tabs = <Widget>[];
    
    // "All" tab
    tabs.add(_buildTab(
      index: 0,
      label: 'All',
      count: widget.totalCount,
      isSelected: widget.selectedTab == null,
    ));
    
    // Individual type tabs
    for (int i = 0; i < widget.availableTabs.length; i++) {
      final type = widget.availableTabs[i];
      if (type == null) continue;
      
      final count = widget.notificationCounts[type] ?? 0;
      if (count == 0) continue; // Hide tabs with no notifications
      
      tabs.add(_buildTab(
        index: i + 1,
        label: type.tabName,
        count: count,
        isSelected: widget.selectedTab == type,
      ));
    }
    
    return tabs;
  }

  Widget _buildTab({
    required int index,
    required String label,
    required int count,
    required bool isSelected,
  }) {
    final isHovered = _hoveredIndex == index;
    final isPressed = _pressedIndex == index;
    
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => _handleHover(index, true),
        onExit: (_) => _handleHover(index, false),
        child: GestureDetector(
          onTap: () => _handleTabTap(index),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              final scale = isPressed ? _scaleAnimation.value : 1.0;
              
              return Transform.scale(
                scale: scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    color: isSelected
                        ? AppColors.sageGreen
                        : isHovered
                            ? AppColors.whisperGray
                            : Colors.transparent,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.sageGreen.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: AppTextStyles.titleSmall.copyWith(
                          color: isSelected
                              ? AppColors.pearlWhite
                              : isHovered
                                  ? AppColors.softCharcoal
                                  : AppColors.softCharcoalLight,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.pearlWhite.withOpacity(0.2)
                              : AppColors.sageGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected
                                ? AppColors.pearlWhite.withOpacity(0.9)
                                : AppColors.softCharcoalLight,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(
                            count.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

