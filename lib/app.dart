import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

/// Future Talk App Root
/// Configured with theme, routing, and state management
class FutureTalkApp extends ConsumerWidget {
  const FutureTalkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // ==================== APP METADATA ====================
      title: 'Future Talk',
      debugShowCheckedModeBanner: false,
      
      // ==================== THEME CONFIGURATION ====================
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Will be dynamic based on user preference later
      
      // ==================== ROUTING CONFIGURATION ====================
      routerConfig: AppRouter.router,
      
      // ==================== LOCALIZATION ====================
      // Will be configured when internationalization is added
      supportedLocales: const [
        Locale('en', 'US'), // English (US)
        // Future: Add more locales as needed
      ],
      
      // ==================== BUILDER FOR GLOBAL WIDGETS ====================
      builder: (context, child) {
        return MediaQuery(
          // Ensure text scaling doesn't break the UI
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              (MediaQuery.of(context).textScaler.scale(1.0)).clamp(0.8, 1.2),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}