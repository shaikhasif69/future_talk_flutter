import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../providers/chat_list_provider.dart';

/// Premium filter tabs with smooth transitions and count badges
/// Features gentle animations and introvert-friendly interactions
class ChatFilterTabs extends StatefulWidget {
  const ChatFilterTabs({
    super.key,
    required this.activeFilter,
    required this.filterCounts,
    required this.onFilterChanged,
  });

  final ChatFilter activeFilter;
  final Map<ChatFilter, int> filterCounts;
  final Function(ChatFilter) onFilterChanged;

  @override
  State<ChatFilterTabs> createState() => _ChatFilterTabsState();
}

class _ChatFilterTabsState extends State<ChatFilterTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<ChatFilter> _filters = [
    ChatFilter.all,
    ChatFilter.groups,
    ChatFilter.unread,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _filters.length,
      vsync: this,
      initialIndex: _filters.indexOf(widget.activeFilter),
    );
    
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatFilterTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.activeFilter != widget.activeFilter) {
      final newIndex = _filters.indexOf(widget.activeFilter);
      if (newIndex != _tabController.index) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final selectedFilter = _filters[_tabController.index];
      widget.onFilterChanged(selectedFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        color: AppColors.sageGreen.withOpacity(0.05),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          color: AppColors.sageGreen,
          boxShadow: [
            BoxShadow(
              color: AppColors.sageGreen.withOpacity( 0.2),
              blurRadius: 4.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        indicatorPadding: const EdgeInsets.all(2.0),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.pearlWhite,
        unselectedLabelColor: AppColors.softCharcoalLight,
        labelStyle: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
        ),
        tabs: _filters.map((filter) {
          final isActive = filter == widget.activeFilter;
          final count = widget.filterCounts[filter] ?? 0;
          
          return Tab(
            child: _buildFilterTab(
              filter: filter,
              count: count,
              isActive: isActive,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterTab({
    required ChatFilter filter,
    required int count,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: AppDurations.mediumFast,
      curve: Curves.easeOut,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Filter icon (optional)
          if (_getFilterIcon(filter) != null) ...[
            Icon(
              _getFilterIcon(filter),
              size: 14.0,
              color: isActive 
                  ? AppColors.pearlWhite 
                  : AppColors.softCharcoalLight,
            ),
            const SizedBox(width: 4.0),
          ],
          
          // Filter label
          Flexible(
            child: Text(
              _getFilterLabel(filter),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Count badge
          if (count > 0 && filter != ChatFilter.all) ...[
            const SizedBox(width: 4.0),
            AnimatedContainer(
              duration: AppDurations.mediumFast,
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 1.0,
              ),
              decoration: BoxDecoration(
                color: isActive 
                    ? AppColors.pearlWhite.withOpacity( 0.2)
                    : AppColors.sageGreen.withOpacity( 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _formatCount(count),
                style: TextStyle(
                  color: isActive 
                      ? AppColors.pearlWhite 
                      : AppColors.sageGreen,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate()
                .fadeIn(duration: AppDurations.fast)
                .scaleXY(
                  begin: 0.0,
                  curve: Curves.easeOutBack,
                  duration: AppDurations.fast,
                ),
          ],
        ],
      ),
    );
  }

  String _getFilterLabel(ChatFilter filter) {
    switch (filter) {
      case ChatFilter.all:
        return 'All';
      case ChatFilter.friends:
        return 'Friends';
      case ChatFilter.groups:
        return 'Groups';
      case ChatFilter.unread:
        return 'Unread';
    }
  }

  IconData? _getFilterIcon(ChatFilter filter) {
    switch (filter) {
      case ChatFilter.all:
        return null; // No icon for "All"
      case ChatFilter.friends:
        return Icons.person_outline;
      case ChatFilter.groups:
        return Icons.group_outlined;
      case ChatFilter.unread:
        return Icons.circle;
    }
  }

  String _formatCount(int count) {
    if (count > 99) return '99+';
    return count.toString();
  }
}

/// Alternative filter tabs using individual buttons (for more customization)
class ChatFilterButtonTabs extends StatelessWidget {
  const ChatFilterButtonTabs({
    super.key,
    required this.activeFilter,
    required this.filterCounts,
    required this.onFilterChanged,
  });

  final ChatFilter activeFilter;
  final Map<ChatFilter, int> filterCounts;
  final Function(ChatFilter) onFilterChanged;

  static const List<ChatFilter> _filters = [
    ChatFilter.all,
    ChatFilter.friends,
    ChatFilter.groups,
    ChatFilter.unread,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isActive = filter == activeFilter;
          final count = filterCounts[filter] ?? 0;
          
          return Padding(
            padding: EdgeInsets.only(
              right: index < _filters.length - 1 ? AppDimensions.spacingS : 0,
            ),
            child: _buildFilterButton(
              filter: filter,
              count: count,
              isActive: isActive,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterButton({
    required ChatFilter filter,
    required int count,
    required bool isActive,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        onTap: () => onFilterChanged(filter),
        child: AnimatedContainer(
          duration: AppDurations.mediumFast,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: isActive 
                ? AppColors.sageGreen 
                : AppColors.sageGreen.withOpacity( 0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            border: Border.all(
              color: isActive 
                  ? AppColors.sageGreen 
                  : AppColors.sageGreen.withOpacity( 0.1),
              width: 1.0,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.sageGreen.withOpacity( 0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 1),
              ),
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getFilterLabel(filter),
                style: TextStyle(
                  color: isActive 
                      ? AppColors.pearlWhite 
                      : AppColors.softCharcoalLight,
                  fontSize: 13.0,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              
              if (count > 0 && filter != ChatFilter.all) ...[
                const SizedBox(width: AppDimensions.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 1.0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? AppColors.pearlWhite.withOpacity( 0.2)
                        : AppColors.sageGreen,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: isActive 
                          ? AppColors.pearlWhite 
                          : AppColors.pearlWhite,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterLabel(ChatFilter filter) {
    switch (filter) {
      case ChatFilter.all:
        return 'All';
      case ChatFilter.friends:
        return 'Friends';
      case ChatFilter.groups:
        return 'Groups';
      case ChatFilter.unread:
        return 'Unread';
    }
  }
}