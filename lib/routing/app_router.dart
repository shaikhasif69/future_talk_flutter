import 'package:flutter/material.dart';
import 'package:future_talk_frontend/features/auth/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/individual_chat_screen.dart';
import '../features/chat/models/chat_conversation.dart';

import '../features/books/screens/book_library_screen.dart';
import '../features/capsule_garden/screens/capsule_garden_dashboard.dart';
import '../features/capsule_creation/screens/create_capsule_page1_screen.dart';
import '../features/capsule_creation/screens/create_capsule_page2_screen.dart';
import '../features/capsule_creation/screens/create_capsule_page3_screen_simple.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/user_profile/screens/user_profile_screen.dart';
import '../features/user_profile/models/user_profile_model.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/notifications/screens/notification_screen.dart';

/// Future Talk's routing configuration using GoRouter
/// Handles navigation between authentication screens with smooth transitions
class AppRouter {
  AppRouter._();

  /// GoRouter configuration
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // ==================== SPLASH ROUTE (TESTING SHORTCUT) ====================
      // GoRoute(ƒchat
      // GoRoute(path: '/splash', name: 'splash', builder: (context, state) => const SplashScreen()),
      // ==================== ONBOARDING ROUTE ====================
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ==================== SIGN UP ROUTE =============ƒchat=======
      GoRoute(
        path: '/sign_up',
        name: 'sign_up',
        builder: (context, state) => const SignUpScreen(),
      ),

      // ==================== SIGN IN ROUTE ====================
      GoRoute(
        path: '/sign_in',
        name: 'sign_in',
        builder: (context, state) => const SignInScreen(),
      ),

      // ==================== MAIN APP ROUTES ====================
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // ==================== CHAT ROUTES ====================
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatListScreen(),
        routes: [
          // Individual Chat Route
          GoRoute(
            path: 'individual/:conversationId',
            name: 'individual_chat',
            builder: (context, state) {
              final conversationId = state.pathParameters['conversationId']!;
              final conversationJson = state.extra as Map<String, dynamic>?;
              
              if (conversationJson != null) {
                final conversation = ChatConversation.fromJson(conversationJson);
                return IndividualChatScreen(conversation: conversation);
              }
              
              // Fallback - shouldn't happen in normal flow
              return const Scaffold(
                body: Center(
                  child: Text('Conversation not found'),
                ),
              );
            },
          ),
        ],
      ),

      // ==================== INDIVIDUAL CHAT ROUTE (DIRECT ACCESS) ====================
      GoRoute(
        path: '/chat/individual/:conversationId',
        name: 'individual_chat_direct',
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          final conversationJson = state.extra as Map<String, dynamic>?;
          
          if (conversationJson != null) {
            final conversation = ChatConversation.fromJson(conversationJson);
            return IndividualChatScreen(conversation: conversation);
          }
          
          // Fallback - shouldn't happen in normal flow
          return const Scaffold(
            body: Center(
              child: Text('Conversation not found'),
            ),
          );
        },
      ),

      // ==================== BOOKS ROUTES ====================
      GoRoute(
        path: '/books',
        name: 'books',
        builder: (context, state) => const ResponsiveBookLibraryScreen(),
      ),

      // ==================== CAPSULE GARDEN ROUTES ====================
      GoRoute(
        path: '/capsule-garden',
        name: 'capsule_garden',
        builder: (context, state) => const CapsuleGardenDashboard(),
      ),

      // ==================== CAPSULE CREATION ROUTES ====================
      GoRoute(
        // path: '/capsule/create',
        path: '/splash',
        name: 'create_capsule',
        builder: (context, state) => const CreateCapsulePage1Screen(),
      ),
      GoRoute(
        path: '/capsule/create/delivery-time',
        name: 'create_capsule_delivery_time',
        builder: (context, state) => const CreateCapsulePage2Screen(),
      ),
      GoRoute(
        path: '/capsule/create/message',
        name: 'create_capsule_message',
        builder: (context, state) => const CreateCapsulePage3ScreenSimple(),
      ),

      // ==================== SPLASH ROUTE ====================
      // GoRoute(
      //   path: '/splash',
      //   name: 'splash',
      //   builder: (context, state) => const SplashScreen(),
      // ),

      // ==================== PROFILE ROUTES ====================
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // ==================== USER PROFILE ROUTES ====================
      GoRoute(
        path: '/user-profile/:userId',
        name: 'user_profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final userProfileJson = state.extra as Map<String, dynamic>?;
          
          UserProfileModel? userProfile;
          if (userProfileJson != null) {
            userProfile = UserProfileModel.fromJson(userProfileJson);
          }
          
          return UserProfileScreen(
            userId: userId,
            userProfile: userProfile,
          );
        },
      ),

      // ==================== NOTIFICATIONS ROUTES ====================
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationScreen(),
      ),

      // ==================== SETTINGS ROUTES ====================
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Custom transitions will be handled per route if needed

    // ==================== ERROR HANDLING ====================
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/splash'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Get the router instance
  static GoRouter get router => _router;

  // Transitions will be implemented per route when needed
}

/// Route names for type-safe navigation
class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signUp = '/sign_up';
  static const String signIn = '/sign_in';
  static const String dashboard = '/dashboard';
  static const String chat = '/chat';
  static const String individualChat = '/chat/individual';
  static const String books = '/books';
  static const String capsuleGarden = '/capsule-garden';
  static const String createCapsule = '/capsule/create';
  static const String profile = '/profile';
  static const String userProfile = '/user-profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
}

/// Navigation extensions for easy routing
extension AppNavigation on BuildContext {
  /// Navigate to splash screen
  void goToSplash() => go(Routes.splash);

  /// Navigate to onboarding
  void goToOnboarding() => go(Routes.onboarding);

  /// Navigate to sign up
  void goToSignUp() => go(Routes.signUp);

  /// Navigate to sign in
  void goToSignIn() => go(Routes.signIn);

  /// Navigate to dashboard
  void goToDashboard() => go(Routes.dashboard);

  /// Navigate to chat list
  void goToChat() => go(Routes.chat);

  /// Navigate to book library
  void goToBooks() => go(Routes.books);

  /// Navigate to capsule garden
  void goToCapsuleGarden() => go(Routes.capsuleGarden);

  /// Navigate to create capsule screen
  void goToCreateCapsule() => go(Routes.createCapsule);

  /// Navigate to profile screen
  void goToProfile() => go(Routes.profile);

  /// Navigate to user profile screen
  void goToUserProfile(String userId, {UserProfileModel? userProfile}) {
    final path = '/user-profile/$userId';
    go(path, extra: userProfile?.toJson());
  }

  /// Navigate to notifications screen
  void goToNotifications() => go(Routes.notifications);

  /// Navigate to settings screen
  void goToSettings() => go(Routes.settings);

  /// Navigate to individual chat
  void goToIndividualChat(ChatConversation conversation) {
    final path = '/chat/individual/${conversation.id}';
    go(path, extra: conversation.toJson());
  }

  /// Push sign up screen
  void pushSignUp() => push(Routes.signUp);

  /// Push sign in screen
  void pushSignIn() => push(Routes.signIn);

  /// Pop and go to sign in (useful from sign up)
  void popAndGoToSignIn() {
    pop();
    goToSignIn();
  }

  /// Pop and go to sign up (useful from sign in)
  void popAndGoToSignUp() {
    pop();
    goToSignUp();
  }

  /// Check if can pop (custom implementation to avoid conflicts)
  bool get canPopRoute => GoRouter.of(this).canPop();

  /// Pop with result
  void popWithResult<T>(T result) => pop(result);
}

/// Custom page transition for more control
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final RouteTransitionsBuilder transitionsBuilder;

  const CustomTransitionPage({
    required this.child,
    required this.transitionsBuilder,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, _) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Route transition types
enum TransitionType {
  fade,
  slide,
  scale,
  rotation,
}

/// Route information class for analytics and debugging
class RouteInfo {
  final String name;
  final String path;
  final Map<String, dynamic>? params;
  final DateTime timestamp;

  const RouteInfo({
    required this.name,
    required this.path,
    this.params,
    required this.timestamp,
  });

  @override
  String toString() => 'RouteInfo(name: $name, path: $path, timestamp: $timestamp)';
}

/// Navigation helper methods
class NavigationHelper {
  NavigationHelper._();

  /// Clear stack and go to route
  static void clearAndGoTo(BuildContext context, String route) {
    while (context.canPopRoute) {
      context.pop();
    }
    context.go(route);
  }

  /// Show custom transition dialog
  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Show bottom sheet with custom transition
  static Future<T?> showCustomBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Navigator.of(context),
      ),
      builder: (context) => child,
    );
  }
}

/// Global navigation key for navigation without context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// App-wide navigation service
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Navigate to route
  Future<void> navigateTo(String route) async {
    navigatorKey.currentContext?.go(route);
  }

  /// Navigate back
  void goBack() {
    navigatorKey.currentContext?.pop();
  }

  /// Show snackbar globally
  void showSnackBar(String message, {bool isError = false}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}