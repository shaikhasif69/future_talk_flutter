import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../providers/navigation_provider.dart';
import 'ft_bottom_nav_tab.dart';
import 'floating_particles_painter.dart';
import 'liquid_indicator_painter.dart';

/// Premium floating bottom navigation bar for Future Talk
/// Features stunning glassmorphism, liquid animations, and premium aesthetics
/// Fully responsive with adaptive layouts for different screen sizes
class FTBottomNavigationBar extends ConsumerStatefulWidget {
  /// Whether to show floating effect
  final bool isFloating;
  
  /// Custom height override
  final double? height;
  
  /// Whether to use compact layout
  final bool isCompact;
  
  /// Custom particle count override
  final int? particleCount;

  const FTBottomNavigationBar({
    super.key,
    this.isFloating = true,
    this.height,
    this.isCompact = false,
    this.particleCount,
  });

  @override
  ConsumerState<FTBottomNavigationBar> createState() => _FTBottomNavigationBarState();
}

class _FTBottomNavigationBarState extends ConsumerState<FTBottomNavigationBar>
    with TickerProviderStateMixin {
  
  late AnimationController _floatingController;
  late AnimationController _liquidController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _liquidAnimation;
  
  late List<AnimationController> _tabControllers;
  late List<AnimationController> _rippleControllers;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Floating animation for the entire bar
    _floatingController = AnimationController(
      duration: AppDurations.pulse,
      vsync: this,
    );
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Liquid indicator animation
    _liquidController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _liquidAnimation = CurvedAnimation(
      parent: _liquidController,
      curve: Curves.elasticOut,
    );

    // Individual tab animations
    final tabCount = NavigationConfig.mainNavigation.length;
    _tabControllers = List.generate(
      tabCount,
      (index) => AnimationController(
        duration: AppDurations.buttonTap,
        vsync: this,
      ),
    );

    _rippleControllers = List.generate(
      tabCount,
      (index) => AnimationController(
        duration: AppDurations.ripple,
        vsync: this,
      ),
    );

    // Start continuous floating animation
    if (widget.isFloating) {
      _floatingController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _liquidController.dispose();
    
    for (final controller in _tabControllers) {
      controller.dispose();
    }
    for (final controller in _rippleControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }

  void _onTabSelected(int index) {
    // Trigger liquid animation
    _liquidController.forward(from: 0.0);
    
    // Trigger ripple animation
    _rippleControllers[index].forward(from: 0.0);
    
    // Use navigation provider for state management
    NavigationHelpers.smartNavigate(
      ref, 
      index, 
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationProvider);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > AppDimensions.tabletBreakpoint;
    final navBarHeight = _getResponsiveHeight(screenSize);
    
    if (!navigationState.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return _buildResponsiveNavigationBar(
          screenSize: screenSize,
          navBarHeight: navBarHeight,
          isTablet: isTablet,
          navigationState: navigationState,
        );
      },
    );
  }

  Widget _buildResponsiveNavigationBar({
    required Size screenSize,
    required double navBarHeight,
    required bool isTablet,
    required NavigationState navigationState,
  }) {
    final horizontalPadding = _getResponsiveHorizontalPadding(screenSize);
    final floatingOffset = widget.isFloating 
      ? 2 * math.sin(_floatingAnimation.value * 2 * math.pi)
      : 0.0;

    return Positioned(
      left: widget.isFloating ? horizontalPadding : 0,
      right: widget.isFloating ? horizontalPadding : 0,
      bottom: (widget.isFloating ? AppDimensions.screenPadding : 0) + floatingOffset,
      child: Container(
        height: navBarHeight,
        constraints: BoxConstraints(
          maxWidth: isTablet ? AppDimensions.maxContentWidth : double.infinity,
        ),
        decoration: _buildContainerDecoration(screenSize),
        child: ClipRRect(
          borderRadius: widget.isFloating 
            ? BorderRadius.circular(_getResponsiveBorderRadius(screenSize))
            : BorderRadius.zero,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: _buildGlassmorphismDecoration(),
              child: Stack(
                children: [
                  // Floating particles background
                  _buildFloatingParticlesLayer(screenSize),
                  
                  // Liquid indicator
                  _buildLiquidIndicatorLayer(screenSize, navigationState),
                  
                  // Navigation tabs
                  _buildNavigationTabsLayer(screenSize, navigationState),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingParticlesLayer(Size screenSize) {
    final particleCount = widget.particleCount ?? _getResponsiveParticleCount(screenSize);
    
    return Positioned.fill(
      child: AnimatedFloatingParticles(
        width: screenSize.width,
        height: _getResponsiveHeight(screenSize),
        baseColor: AppColors.sageGreen,
        particleCount: particleCount,
        intensity: 0.6,
        showConnections: screenSize.width > AppDimensions.tabletBreakpoint,
      ),
    );
  }

  Widget _buildLiquidIndicatorLayer(Size screenSize, NavigationState navigationState) {
    return AnimatedBuilder(
      animation: _liquidAnimation,
      builder: (context, child) {
        return AnimatedLiquidIndicator(
          selectedIndex: navigationState.selectedIndex,
          tabCount: NavigationConfig.mainNavigation.length,
          width: screenSize.width - (_getResponsiveHorizontalPadding(screenSize) * 2),
          height: _getResponsiveIndicatorHeight(screenSize),
          intensity: _liquidAnimation.value,
        );
      },
    );
  }

  Widget _buildNavigationTabsLayer(Size screenSize, NavigationState navigationState) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsiveContentPadding(screenSize),
          vertical: _getResponsiveVerticalPadding(screenSize),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            NavigationConfig.mainNavigation.length,
            (index) => _buildResponsiveNavigationTab(
              index, 
              screenSize, 
              navigationState,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveNavigationTab(
    int index, 
    Size screenSize, 
    NavigationState navigationState,
  ) {
    final item = NavigationConfig.mainNavigation[index];
    final isSelected = navigationState.selectedIndex == index;
    final scaleFactor = _getResponsiveTabScale(screenSize);

    return Expanded(
      child: FTBottomNavTab(
        isSelected: isSelected,
        icon: item.icon,
        activeIcon: item.activeIcon,
        label: widget.isCompact ? _getCompactLabel(item.label) : item.label,
        onTap: () => _onTabSelected(index),
        scaleFactor: scaleFactor,
        showBadge: _shouldShowBadge(index),
        badgeCount: _getBadgeCount(index),
      ),
    );
  }

  // Responsive helper methods
  double _getResponsiveHeight(Size screenSize) {
    if (widget.height != null) return widget.height!;
    
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return AppDimensions.bottomNavHeight - 8; // Smaller on small phones
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return AppDimensions.bottomNavHeight;
    } else {
      return AppDimensions.bottomNavHeight + 8; // Larger on tablets
    }
  }

  double _getResponsiveHorizontalPadding(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return AppDimensions.spacingM;
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return AppDimensions.screenPadding;
    } else {
      return AppDimensions.spacingXXL;
    }
  }

  double _getResponsiveContentPadding(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return AppDimensions.spacingXS;
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return AppDimensions.spacingS;
    } else {
      return AppDimensions.spacingM;
    }
  }

  double _getResponsiveVerticalPadding(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return AppDimensions.spacingS;
    } else {
      return AppDimensions.spacingM;
    }
  }

  double _getResponsiveBorderRadius(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return AppDimensions.radiusL;
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return AppDimensions.radiusXL;
    } else {
      return AppDimensions.radiusXXL;
    }
  }

  double _getResponsiveTabScale(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return 0.9;
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return 1.0;
    } else {
      return 1.1;
    }
  }

  int _getResponsiveParticleCount(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return 8;
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return 12;
    } else {
      return 16;
    }
  }

  double _getResponsiveIndicatorHeight(Size screenSize) {
    if (screenSize.width < AppDimensions.mobileBreakpoint) {
      return 4;
    } else if (screenSize.width < AppDimensions.tabletBreakpoint) {
      return 5;
    } else {
      return 6;
    }
  }

  String _getCompactLabel(String fullLabel) {
    // Compact labels for small screens
    switch (fullLabel) {
      case 'Time Capsules': return 'Capsules';
      case 'Connection Stones': return 'Stones';
      case 'Parallel Reading': return 'Reading';
      default: return fullLabel;
    }
  }

  bool _shouldShowBadge(int index) {
    // Add badge logic here based on app state
    // For now, return false
    return false;
  }

  int _getBadgeCount(int index) {
    // Add badge count logic here
    return 0;
  }

  BoxDecoration _buildContainerDecoration(Size screenSize) {
    final shadowIntensity = screenSize.width > AppDimensions.tabletBreakpoint ? 1.2 : 1.0;
    
    return BoxDecoration(
      borderRadius: widget.isFloating 
        ? BorderRadius.circular(_getResponsiveBorderRadius(screenSize))
        : BorderRadius.zero,
      boxShadow: [
        if (widget.isFloating) ...[
          // Primary floating shadow
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20 * shadowIntensity,
            spreadRadius: 0,
            offset: Offset(0, 8 + (2 * math.sin(_floatingAnimation.value * 2 * math.pi))),
          ),
          // Secondary glow shadow
          BoxShadow(
            color: AppColors.sageGreen.withOpacity(0.1),
            blurRadius: 30 * shadowIntensity,
            spreadRadius: -5,
            offset: Offset(0, 12 + (1 * math.sin(_floatingAnimation.value * 2 * math.pi))),
          ),
        ],
      ],
    );
  }

  BoxDecoration _buildGlassmorphismDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.pearlWhite.withOpacity(0.95),
          AppColors.warmCream.withOpacity(0.85),
          AppColors.sageGreenLight.withOpacity(0.1),
        ],
        stops: const [0.0, 0.6, 1.0],
      ),
      border: widget.isFloating ? Border.all(
        color: AppColors.whisperGray.withOpacity(0.2),
        width: 0.5,
      ) : null,
    );
  }
}