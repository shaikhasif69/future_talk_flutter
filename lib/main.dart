import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

/// Future Talk - Premium Authentication Flow Entry Point
/// 
/// This is the most beautiful introvert-focused messaging app that creates
/// stunning, seamless user experiences with premium animations and warm aesthetics.
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI overlay (status bar, navigation bar)
  await _configureSystemUI();
  
  // Run the app with Riverpod for state management
  runApp(
    const ProviderScope(
      child: FutureTalkApp(),
    ),
  );
}

/// Configure system UI for premium look and feel
Future<void> _configureSystemUI() async {
  // Set preferred orientations (portrait only for now)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configure status bar and navigation bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Status bar
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      
      // Navigation bar (Android)
      systemNavigationBarColor: Color(0xFFF7F5F3), // Warm Cream
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  
  // Enable edge-to-edge experience
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
}
