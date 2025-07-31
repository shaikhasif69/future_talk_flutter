/// Future Talk's spacing and dimension system
/// Based on 4px grid system for consistent, harmonious layouts
class AppDimensions {
  AppDimensions._();

  // ==================== BASE SPACING UNIT ====================
  static const double _baseUnit = 4.0;

  // ==================== SPACING SCALE ====================
  
  /// Extra small spacing (4px)
  static const double spacingXS = _baseUnit;
  
  /// Small spacing (8px)
  static const double spacingS = _baseUnit * 2;
  
  /// Medium spacing (12px)
  static const double spacingM = _baseUnit * 3;
  
  /// Large spacing (16px)
  static const double spacingL = _baseUnit * 4;
  
  /// Extra large spacing (20px)
  static const double spacingXL = _baseUnit * 5;
  
  /// Double extra large spacing (24px)
  static const double spacingXXL = _baseUnit * 6;
  
  /// Triple extra large spacing (32px)
  static const double spacingXXXL = _baseUnit * 8;
  
  /// Quadruple extra large spacing (40px)
  static const double spacingXXXXL = _baseUnit * 10;
  
  /// Massive spacing (48px)
  static const double spacingMassive = _baseUnit * 12;
  
  /// Huge spacing (64px)
  static const double spacingHuge = _baseUnit * 16;

  // ==================== PADDING PRESETS ====================
  
  /// Screen padding - horizontal margin for screens
  static const double screenPadding = spacingL; // 16px
  
  /// Card padding - internal padding for cards
  static const double cardPadding = spacingL; // 16px
  
  /// Card padding large - for important cards
  static const double cardPaddingLarge = spacingXXL; // 24px
  
  /// Button padding horizontal
  static const double buttonPaddingHorizontal = spacingXXL; // 24px
  
  /// Button padding vertical
  static const double buttonPaddingVertical = spacingM; // 12px
  
  /// Input padding horizontal
  static const double inputPaddingHorizontal = spacingL; // 16px
  
  /// Input padding vertical
  static const double inputPaddingVertical = spacingM; // 12px
  
  /// List item padding
  static const double listItemPadding = spacingL; // 16px
  
  /// Section padding - between major sections
  static const double sectionPadding = spacingXXXL; // 32px
  
  /// Medium padding
  static const double paddingM = spacingM; // 12px
  
  /// Large padding
  static const double paddingL = spacingL; // 16px
  
  /// Extra large padding
  static const double paddingXL = spacingXL; // 20px
  
  /// Double extra large padding
  static const double paddingXXL = spacingXXL; // 24px

  // ==================== COMPONENT HEIGHTS ====================
  
  /// Small button height
  static const double buttonHeightSmall = 36.0;
  
  /// Medium button height (default)
  static const double buttonHeightMedium = 48.0;
  
  /// Large button height
  static const double buttonHeightLarge = 56.0;
  
  /// Input field height
  static const double inputHeight = 48.0;
  
  /// Large input field height (for text areas)
  static const double inputHeightLarge = 96.0;
  
  /// App bar height
  static const double appBarHeight = 56.0;
  
  /// Bottom navigation height
  static const double bottomNavHeight = 72.0;
  
  /// Card minimum height
  static const double cardMinHeight = 120.0;
  
  /// List item height
  static const double listItemHeight = 64.0;
  
  /// Divider height
  static const double dividerHeight = 1.0;

  // ==================== BORDER RADIUS ====================
  
  /// Extra small radius (4px)
  static const double radiusXS = _baseUnit;
  
  /// Small radius (8px)
  static const double radiusS = _baseUnit * 2;
  
  /// Medium radius (12px)
  static const double radiusM = _baseUnit * 3;
  
  /// Large radius (16px)
  static const double radiusL = _baseUnit * 4;
  
  /// Extra large radius (20px)
  static const double radiusXL = _baseUnit * 5;
  
  /// Double extra large radius (24px)
  static const double radiusXXL = _baseUnit * 6;
  
  /// Circular radius (999px - effectively circular)
  static const double radiusCircular = 999.0;

  // ==================== COMPONENT SPECIFIC RADIUS ====================
  
  /// Button border radius
  static const double buttonRadius = radiusM; // 12px
  
  /// Input field border radius
  static const double inputRadius = radiusM; // 12px
  
  /// Card border radius
  static const double cardRadius = radiusL; // 16px
  
  /// Modal border radius
  static const double modalRadius = radiusXL; // 20px
  
  /// Avatar border radius (for rounded avatars)
  static const double avatarRadius = radiusL; // 16px
  
  /// Logo container radius
  static const double logoRadius = radiusXXL; // 24px

  // ==================== ELEVATION & SHADOWS ====================
  
  /// Card elevation
  static const double cardElevation = 2.0;
  
  /// Button elevation
  static const double buttonElevation = 4.0;
  
  /// Modal elevation
  static const double modalElevation = 8.0;
  
  /// Floating action button elevation
  static const double fabElevation = 6.0;
  
  /// App bar elevation
  static const double appBarElevation = 1.0;

  // ==================== ICON SIZES ====================
  
  /// Extra small icon (16px)
  static const double iconXS = 16.0;
  
  /// Small icon (20px)
  static const double iconS = 20.0;
  
  /// Medium icon (24px)
  static const double iconM = 24.0;
  
  /// Large icon (32px)
  static const double iconL = 32.0;
  
  /// Extra large icon (40px)
  static const double iconXL = 40.0;
  
  /// Double extra large icon (48px)
  static const double iconXXL = 48.0;
  
  /// Logo icon size
  static const double iconLogo = 120.0;

  // ==================== LOGO & BRAND SIZES ====================
  
  /// Small logo size
  static const double logoSmall = 48.0;
  
  /// Medium logo size
  static const double logoMedium = 80.0;
  
  /// Large logo size (for splash)
  static const double logoLarge = 120.0;
  
  /// Brand mark size
  static const double brandMark = 32.0;

  // ==================== FORM SPECIFIC ====================
  
  /// Form field spacing
  static const double formFieldSpacing = spacingL; // 16px
  
  /// Form section spacing
  static const double formSectionSpacing = spacingXXL; // 24px
  
  /// Form action spacing (between form and buttons)
  static const double formActionSpacing = spacingXXXL; // 32px
  
  /// Checkbox size
  static const double checkboxSize = 20.0;
  
  /// Radio button size
  static const double radioSize = 20.0;

  // ==================== ANIMATION & INTERACTION ====================
  
  /// Minimum touch target size (for accessibility)
  static const double minTouchTarget = 44.0;
  
  /// Ripple radius
  static const double rippleRadius = 24.0;
  
  /// Loading indicator size
  static const double loadingIndicatorSize = 24.0;
  
  /// Progress bar height
  static const double progressBarHeight = 4.0;
  
  /// Progress bar radius
  static const double progressBarRadius = 2.0;

  // ==================== BREAKPOINTS ====================
  
  /// Mobile breakpoint
  static const double mobileBreakpoint = 375.0;
  
  /// Tablet breakpoint
  static const double tabletBreakpoint = 768.0;
  
  /// Desktop breakpoint
  static const double desktopBreakpoint = 1024.0;

  // ==================== LAYOUT CONSTRAINTS ====================
  
  /// Maximum content width
  static const double maxContentWidth = 480.0;
  
  /// Maximum card width
  static const double maxCardWidth = 400.0;
  
  /// Maximum modal width
  static const double maxModalWidth = 420.0;
  
  /// Minimum screen padding
  static const double minScreenPadding = spacingS; // 8px

  // ==================== HELPER METHODS ====================
  
  /// Get responsive padding based on screen width
  static double getResponsivePadding(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return minScreenPadding;
    } else if (screenWidth < tabletBreakpoint) {
      return screenPadding;
    } else {
      return spacingXXL; // Larger padding for tablets
    }
  }
  
  /// Get responsive spacing based on context
  static double getResponsiveSpacing(double screenWidth, {bool isLarge = false}) {
    final basePadding = getResponsivePadding(screenWidth);
    return isLarge ? basePadding * 1.5 : basePadding;
  }
  
  /// Calculate grid spacing for responsive layouts
  static double getGridSpacing(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return spacingS; // 8px
    } else if (screenWidth < tabletBreakpoint) {
      return spacingM; // 12px
    } else {
      return spacingL; // 16px
    }
  }
}