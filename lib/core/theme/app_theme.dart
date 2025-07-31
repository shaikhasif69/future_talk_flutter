import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

/// Future Talk's complete theme configuration
/// Designed for introverts with warm, calming aesthetics
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      // ==================== BASIC THEME SETUP ====================
      useMaterial3: true,
      brightness: Brightness.light,
      
      // ==================== COLOR SCHEME ====================
      colorScheme: const ColorScheme.light(
        primary: AppColors.sageGreen,
        onPrimary: AppColors.pearlWhite,
        primaryContainer: AppColors.sageGreenLight,
        onPrimaryContainer: AppColors.softCharcoal,
        
        secondary: AppColors.lavenderMist,
        onSecondary: AppColors.pearlWhite,
        secondaryContainer: AppColors.lavenderMistLight,
        onSecondaryContainer: AppColors.softCharcoal,
        
        tertiary: AppColors.warmPeach,
        onTertiary: AppColors.softCharcoal,
        tertiaryContainer: AppColors.warmPeachLight,
        onTertiaryContainer: AppColors.softCharcoal,
        
        error: AppColors.dustyRose,
        onError: AppColors.pearlWhite,
        errorContainer: AppColors.dustyRoseLight,
        onErrorContainer: AppColors.softCharcoal,
        
        surface: AppColors.warmCream,
        onSurface: AppColors.softCharcoal,
        surfaceContainerHighest: AppColors.warmCreamAlt,
        
        outline: AppColors.whisperGray,
        outlineVariant: AppColors.stoneGray,
        
        shadow: AppColors.softCharcoal,
        scrim: AppColors.softCharcoal,
        
        inverseSurface: AppColors.softCharcoal,
        onInverseSurface: AppColors.warmCream,
        inversePrimary: AppColors.sageGreenLight,
      ),
      
      // ==================== SCAFFOLD THEME ====================
      scaffoldBackgroundColor: AppColors.warmCream,
      
      // ==================== APP BAR THEME ====================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmCream,
        foregroundColor: AppColors.softCharcoal,
        elevation: AppDimensions.appBarElevation,
        shadowColor: AppColors.whisperGray,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.headlineMedium,
        centerTitle: false,
        toolbarHeight: AppDimensions.appBarHeight,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      
      // ==================== ELEVATED BUTTON THEME ====================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sageGreen,
          foregroundColor: AppColors.pearlWhite,
          elevation: AppDimensions.buttonElevation,
          shadowColor: AppColors.buttonShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeightMedium),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // ==================== OUTLINED BUTTON THEME ====================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.sageGreen,
          side: const BorderSide(color: AppColors.sageGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeightMedium),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.buttonPaddingVertical,
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.sageGreen),
        ),
      ),
      
      // ==================== TEXT BUTTON THEME ====================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.sageGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
          textStyle: AppTextStyles.link,
        ),
      ),
      
      // ==================== INPUT DECORATION THEME ====================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.warmCreamAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.whisperGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.whisperGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.sageGreen, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.dustyRose),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.dustyRose, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingHorizontal,
          vertical: AppDimensions.inputPaddingVertical,
        ),
        hintStyle: AppTextStyles.labelLarge,
        labelStyle: AppTextStyles.labelLarge,
        errorStyle: AppTextStyles.error,
        helperStyle: AppTextStyles.labelMedium,
      ),
      
      // ==================== CARD THEME ====================
      cardTheme: CardThemeData(
        color: AppColors.warmCreamAlt,
        shadowColor: AppColors.cardShadow,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: const EdgeInsets.all(AppDimensions.spacingS),
      ),
      
      // ==================== DIVIDER THEME ====================
      dividerTheme: const DividerThemeData(
        color: AppColors.whisperGray,
        thickness: AppDimensions.dividerHeight,
        space: AppDimensions.spacingL,
      ),
      
      // ==================== CHECKBOX THEME ====================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.sageGreen;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.pearlWhite),
        side: const BorderSide(color: AppColors.stoneGray, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
        ),
      ),
      
      // ==================== RADIO THEME ====================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.sageGreen;
          }
          return AppColors.stoneGray;
        }),
      ),
      
      // ==================== SWITCH THEME ====================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.pearlWhite;
          }
          return AppColors.stoneGray;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.sageGreen;
          }
          return AppColors.whisperGray;
        }),
      ),
      
      // ==================== PROGRESS INDICATOR THEME ====================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.sageGreen,
        linearTrackColor: AppColors.whisperGray,
        circularTrackColor: AppColors.whisperGray,
      ),
      
      // ==================== FLOATING ACTION BUTTON THEME ====================
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.sageGreen,
        foregroundColor: AppColors.pearlWhite,
        elevation: AppDimensions.fabElevation,
        shape: CircleBorder(),
      ),
      
      // ==================== BOTTOM NAVIGATION BAR THEME ====================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.warmCreamAlt,
        selectedItemColor: AppColors.sageGreen,
        unselectedItemColor: AppColors.softCharcoalLight,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.cardElevation,
        selectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
      ),
      
      // ==================== SNACKBAR THEME ====================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.softCharcoal,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.pearlWhite,
        ),
        actionTextColor: AppColors.sageGreenLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppDimensions.modalElevation,
      ),
      
      // ==================== DIALOG THEME ====================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.warmCreamAlt,
        surfaceTintColor: Colors.transparent,
        elevation: AppDimensions.modalElevation,
        shadowColor: AppColors.modalShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.modalRadius),
        ),
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
      
      // ==================== LIST TILE THEME ====================
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.listItemPadding,
        ),
        minVerticalPadding: AppDimensions.spacingM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.radiusM),
          ),
        ),
        titleTextStyle: AppTextStyles.titleMedium,
        subtitleTextStyle: AppTextStyles.bodySmall,
        leadingAndTrailingTextStyle: AppTextStyles.labelMedium,
      ),
      
      // ==================== TEXT THEME ====================
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      
      // ==================== ICON THEME ====================
      iconTheme: const IconThemeData(
        color: AppColors.softCharcoal,
        size: AppDimensions.iconM,
      ),
      
      primaryIconTheme: const IconThemeData(
        color: AppColors.pearlWhite,
        size: AppDimensions.iconM,
      ),
      
      // ==================== TYPOGRAPHY ====================
      typography: Typography.material2021(),
      
      // ==================== VISUAL DENSITY ====================
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // ==================== MATERIAL TAP TARGET SIZE ====================
      materialTapTargetSize: MaterialTapTargetSize.padded,
      
      // ==================== PAGE TRANSITIONS ====================
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // ==================== SPLASH COLOR ====================
      splashColor: AppColors.sageGreen.withAlpha(30),
      highlightColor: AppColors.sageGreen.withAlpha(20),
      
      // ==================== FOCUS COLOR ====================
      focusColor: AppColors.sageGreen.withAlpha(40),
      hoverColor: AppColors.sageGreen.withAlpha(20),
    );
  }

  /// Dark theme configuration (for future implementation)
  static ThemeData get darkTheme {
    // This would be implemented when dark mode is needed
    // For now, returning light theme as fallback
    return lightTheme;
  }

  /// Get theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }
  
  /// Common decoration for containers
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.warmCreamAlt,
    borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  /// Gradient decoration for special containers
  static BoxDecoration get gradientDecoration => BoxDecoration(
    gradient: AppColors.cardGradient,
    borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
}