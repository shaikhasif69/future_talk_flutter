import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/navigation_provider.dart';
import '../../../core/constants/app_colors.dart';

/// Premium scaffold wrapper for Future Talk screens
/// Provides consistent layout structure
class FTScaffold extends ConsumerWidget {
  /// The main body content
  final Widget body;
  
  /// Custom app bar
  final PreferredSizeWidget? appBar;
  
  /// Background color override
  final Color? backgroundColor;
  
  
  /// Custom floating action button
  final Widget? floatingActionButton;
  
  /// FAB location
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  
  /// Whether to resize to avoid bottom inset
  final bool resizeToAvoidBottomInset;
  
  /// Custom drawer
  final Widget? drawer;
  
  /// Custom end drawer
  final Widget? endDrawer;
  
  /// Whether to show app bar
  final bool showAppBar;
  
  /// Custom safe area configuration
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const FTScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.drawer,
    this.endDrawer,
    this.showAppBar = true,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.warmCream,
      appBar: showAppBar ? (appBar ?? _buildDefaultAppBar(context)) : null,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: false,
      body: SafeArea(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: body,
      ),
    );
  }

  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.warmCream,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.softCharcoal,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

}

/// Specialized scaffold for dashboard-style screens
class FTDashboardScaffold extends ConsumerWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const FTDashboardScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTScaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: title != null ? Text(
          title!,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ) : null,
        backgroundColor: backgroundColor ?? AppColors.warmCream,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.softCharcoal,
        leading: leading,
        actions: actions,
        centerTitle: false,
      ),
      body: body,
    );
  }
}

/// Specialized scaffold for full-screen content
class FTFullScreenScaffold extends ConsumerWidget {
  final Widget body;
  final Color? backgroundColor;

  const FTFullScreenScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTScaffold(
      showAppBar: false,
      backgroundColor: backgroundColor,
      body: body,
    );
  }
}

/// Navigation controller widget for handling system back button
class NavigationControllerWidget extends ConsumerWidget {
  final Widget child;

  const NavigationControllerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final navigationState = ref.read(navigationProvider);
        
        // Handle back navigation
        if (navigationState.navigationHistory.length > 1) {
          ref.read(navigationProvider.notifier).navigateBack(context: context);
        } else {
          // Allow system back
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}

/// Helper widget for navigation visibility control
class NavigationVisibilityController extends ConsumerStatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final bool hideOnScroll;

  const NavigationVisibilityController({
    super.key,
    required this.child,
    this.scrollController,
    this.hideOnScroll = false,
  });

  @override
  ConsumerState<NavigationVisibilityController> createState() => 
      _NavigationVisibilityControllerState();
}

class _NavigationVisibilityControllerState 
    extends ConsumerState<NavigationVisibilityController> {
  
  late ScrollController _scrollController;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    
    if (widget.hideOnScroll) {
      _scrollController.addListener(_handleScroll);
    }
  }

  void _handleScroll() {
    final isScrollingDown = _scrollController.position.userScrollDirection == 
        ScrollDirection.reverse;
    
    if (isScrollingDown && _isVisible) {
      setState(() {
        _isVisible = false;
      });
      ref.read(navigationProvider.notifier).setNavigationVisibility(false);
    } else if (!isScrollingDown && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      ref.read(navigationProvider.notifier).setNavigationVisibility(true);
    }
  }

  @override
  void dispose() {
    if (widget.hideOnScroll) {
      _scrollController.removeListener(_handleScroll);
    }
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}