import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/notification_tab_overlay.dart';
import '../widgets/notification_card.dart';
import '../models/notification_model.dart';

/// Premium notification screen with tab overlay design and smooth animations
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;
  
  NotificationType? _selectedTab;
  List<FTNotification> _notifications = [];
  List<FTNotification> _filteredNotifications = [];
  Map<NotificationType?, int> _notificationCounts = {};
  
  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));
    
    _contentAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadNotifications();
    _startAnimations();
  }

  void _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _contentController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    _notifications = NotificationMockData.getMockNotifications();
    _calculateNotificationCounts();
    _filterNotifications();
  }

  void _calculateNotificationCounts() {
    _notificationCounts.clear();
    
    for (final notification in _notifications) {
      _notificationCounts[notification.type] = 
          (_notificationCounts[notification.type] ?? 0) + 1;
    }
  }

  void _filterNotifications() {
    if (_selectedTab == null) {
      _filteredNotifications = List.from(_notifications);
    } else {
      _filteredNotifications = _notifications
          .where((notification) => notification.type == _selectedTab)
          .toList();
    }
    
    // Sort by timestamp (newest first)
    _filteredNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void _onTabSelected(NotificationType? tab) {
    if (_selectedTab == tab) return;
    
    setState(() {
      _selectedTab = tab;
    });
    
    _filterNotifications();
    
    // Restart content animation for smooth transition
    _contentController.reset();
    _contentController.forward();
    
    HapticFeedback.selectionClick();
  }

  void _onNotificationTap(FTNotification notification) {
    HapticFeedback.lightImpact();
    
    // Mark as read
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        // Note: In a real app, you'd update the model properly
        // For now, we'll just update the local state
      }
    });
  }

  void _onActionTap(NotificationAction action) {
    HapticFeedback.mediumImpact();
    // Handle action tap - in real app, this would trigger actual functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: ${action.label}'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.sageGreen,
      ),
    );
  }

  void _clearAllNotifications() {
    HapticFeedback.heavyImpact();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear All Notifications',
          style: AppTextStyles.headlineSmall,
        ),
        content: Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(color: AppColors.softCharcoal),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notifications.clear();
                _filteredNotifications.clear();
                _notificationCounts.clear();
              });
            },
            child: Text(
              'Clear All',
              style: AppTextStyles.button.copyWith(color: AppColors.dustyRose),
            ),
          ),
        ],
      ),
    );
  }

  int get _unreadCount {
    return _notifications.where((n) => !n.isRead).length;
  }

  List<NotificationType?> get _availableTabs {
    return [
      NotificationType.timeCapsule,
      NotificationType.connectionStone,
      NotificationType.reading,
      NotificationType.social,
      NotificationType.friend,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Premium Header
            _buildHeader(),
            
            // Tab Overlay
            const SizedBox(height: AppDimensions.spacingM),
            NotificationTabOverlay(
              availableTabs: _availableTabs,
              selectedTab: _selectedTab,
              onTabSelected: _onTabSelected,
              notificationCounts: _notificationCounts,
              totalCount: _notifications.length,
            ),
            
            // Content Area
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _headerAnimation.value)),
          child: Opacity(
            opacity: _headerAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.sageGreen,
                    AppColors.sageGreenLight,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusXXL),
                  bottomRight: Radius.circular(AppDimensions.radiusXXL),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.pearlWhite.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Header content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.spacingM,
                      AppDimensions.screenPadding,
                      AppDimensions.spacingXL,
                    ),
                    child: Column(
                      children: [
                        // Top row
                        Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.pearlWhite.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.pearlWhite,
                                  size: 18,
                                ),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Title
                            Text(
                              'Notifications',
                              style: AppTextStyles.headlineLarge.copyWith(
                                color: AppColors.pearlWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Clear all button
                            GestureDetector(
                              onTap: _clearAllNotifications,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spacingM,
                                  vertical: AppDimensions.spacingXS,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.pearlWhite.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                ),
                                child: Text(
                                  'Clear All',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.pearlWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingL),
                        
                        // Summary
                        Row(
                          children: [
                            Text(
                              'Your thoughtful updates',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.pearlWhite.withValues(alpha: 0.9),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Unread count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingM,
                                vertical: AppDimensions.spacingXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.pearlWhite.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              ),
                              child: Text(
                                '$_unreadCount unread',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.pearlWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _contentAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _contentAnimation.value)),
          child: Opacity(
            opacity: _contentAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(top: AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.pearlWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusXXL),
                  topRight: Radius.circular(AppDimensions.radiusXXL),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softCharcoal.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: _buildNotificationList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationList() {
    if (_filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.spacingXXL,
        AppDimensions.screenPadding,
        AppDimensions.spacingXXL,
      ),
      child: Column(
        children: [
          // Time sections
          Expanded(
            child: ListView(
              children: _buildTimeSections(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimeSections() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));
    
    final todayNotifications = <FTNotification>[];
    final yesterdayNotifications = <FTNotification>[];
    final thisWeekNotifications = <FTNotification>[];
    final olderNotifications = <FTNotification>[];
    
    for (final notification in _filteredNotifications) {
      final notificationDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );
      
      if (notificationDate.isAtSameMomentAs(today)) {
        todayNotifications.add(notification);
      } else if (notificationDate.isAtSameMomentAs(yesterday)) {
        yesterdayNotifications.add(notification);
      } else if (notification.timestamp.isAfter(thisWeek)) {
        thisWeekNotifications.add(notification);
      } else {
        olderNotifications.add(notification);
      }
    }
    
    final sections = <Widget>[];
    
    if (todayNotifications.isNotEmpty) {
      sections.add(_buildTimeSection('Today', '🌅', todayNotifications));
    }
    
    if (yesterdayNotifications.isNotEmpty) {
      sections.add(_buildTimeSection('Yesterday', '🌙', yesterdayNotifications));
    }
    
    if (thisWeekNotifications.isNotEmpty) {
      sections.add(_buildTimeSection('This Week', '📅', thisWeekNotifications));
    }
    
    if (olderNotifications.isNotEmpty) {
      sections.add(_buildTimeSection('Older', '📂', olderNotifications));
    }
    
    return sections;
  }

  Widget _buildTimeSection(String title, String icon, List<FTNotification> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          child: Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        // Notifications
        ...notifications.map((notification) => NotificationCard(
          notification: notification,
          onTap: () => _onNotificationTap(notification),
          onActionTap: _onActionTap,
        )),
        
        const SizedBox(height: AppDimensions.spacingXL),
      ],
    );
  }

  Widget _buildEmptyState() {
    final selectedTypeDisplay = _selectedTab?.displayName ?? 'notifications';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.whisperGray.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 40,
                color: AppColors.softCharcoalLight,
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Empty title
            Text(
              'No ${selectedTypeDisplay.toLowerCase()}',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.softCharcoal,
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingS),
            
            // Empty description
            Text(
              'When you receive $selectedTypeDisplay, they\'ll appear here for your mindful review.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}