import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_talk_frontend/features/auth/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../core/guards/auth_guard.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/individual_chat_screen.dart';
import '../features/chat/models/chat_conversation.dart';

import '../features/books/screens/book_library_screen.dart';
import '../features/capsule_garden/screens/capsule_garden_dashboard.dart';
import '../features/capsule_creation/screens/create_capsule_page1_screen.dart';
import '../features/capsule_creation/screens/friend_selection_screen.dart';
import '../features/capsule_creation/screens/anonymous_user_search_screen.dart';
import '../features/capsule_creation/screens/create_capsule_page2_screen.dart';
import '../features/capsule_creation/screens/create_capsule_page3_screen_simple.dart';
import '../features/capsule_creation/screens/create_capsule_final_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/dynamic_profile_screen.dart';
import '../features/user_profile/screens/user_profile_screen.dart';
import '../features/user_profile/models/user_profile_model.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/notifications/screens/notification_screen.dart';
import '../features/connection_stones/screens/connection_stones_dashboard_screen.dart';
import '../features/navigation/screens/time_capsules_screen.dart';
import '../features/navigation/screens/connection_stones_screen.dart';
import '../features/navigation/screens/parallel_reading_screen.dart';
import '../features/navigation/screens/chat_tab_screen.dart';
import '../features/navigation/screens/capsule_tab_screen.dart';
import '../features/navigation/screens/read_tab_screen.dart';

/// Router provider that handles authentication-aware routing  
final routerProvider = Provider<GoRouter>((ref) {
  // Watch for changes in login and initialization state
  ref.watch(authProvider.select((state) => (state.isLoggedIn, state.isInitialized)));
  
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final currentPath = state.fullPath ?? state.matchedLocation;
      
      print('🔀 [Router] Redirect check: location=$currentPath, isLoggedIn=${authState.isLoggedIn}, isInitialized=${authState.isInitialized}, isLoading=${authState.isLoading}');
      
      // Wait for auth to initialize
      if (!authState.isInitialized) {
        if (currentPath != '/splash') {
          print('🔀 [Router] Auth not initialized, staying on splash');
          return '/splash';
        }
        return null; // Stay on splash while initializing
      }
      
      // Auth is initialized, handle based on login state
      if (authState.isLoggedIn) {
        // Logged in users go to dashboard (skip all auth screens)
        if (['/splash', '/onboarding', '/sign_in', '/sign_up', '/verify-otp'].contains(currentPath)) {
          print('🔀 [Router] Logged in user, redirecting to dashboard');
          return '/dashboard';
        }
      } else {
        // Not logged in - handle the auth flow properly
        
        // From splash, go to onboarding (first time users)
        if (currentPath == '/splash') {
          print('🔀 [Router] Not logged in, redirecting from splash to onboarding');
          return '/onboarding';
        }
        
        // Allow auth screens (onboarding, sign_in, sign_up, verify-otp) without redirect
        if (['/onboarding', '/sign_in', '/sign_up', '/verify-otp'].contains(currentPath)) {
          print('🔀 [Router] Allowing access to auth screen: $currentPath');
          return null;
        }
        
        // Protected routes require authentication
        print('🔀 [Router] Protected route, redirecting to sign in');
        return '/sign_in';
      }
      
      return null;
    },
    routes: [
      // ==================== SPLASH ROUTE (TESTING SHORTCUT) ====================
      // GoRoute(ƒchat
      GoRoute(path: '/splash', name: 'splash', builder: (context, state) => const SplashScreen()),
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

      // ==================== OTP VERIFICATION ROUTE ====================
      GoRoute(
        path: '/verify-otp',
        name: 'verify_otp',
        builder: (context, state) {
          print('🔄 [Router] Building OTP verification screen');
          final extra = state.extra as Map<String, dynamic>?;
          print('🔄 [Router] Extra data: $extra');
          
          if (extra != null) {
            print('🔄 [Router] Creating OtpVerificationScreen with email: ${extra['email']}');
            return OtpVerificationScreen(
              email: extra['email'] as String,
              message: extra['message'] as String?,
              expiresInMinutes: extra['expiresInMinutes'] as int?,
            );
          }
          
          print('🔄 [Router] No extra data, returning to SignUpScreen');
          return const SignUpScreen();
        },
      ),

      // ==================== MAIN APP ROUTES ====================
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // ==================== NAVIGATION TAB ROUTES ====================
      GoRoute(
        path: '/time-capsules',
        name: 'time_capsules',
        builder: (context, state) => const TimeCapsulsScreen(),
      ),
      
      GoRoute(
        path: '/connection-stones-tab',
        name: 'connection_stones_tab',
        builder: (context, state) => const ConnectionStonesScreen(),
      ),
      
      GoRoute(
        path: '/parallel-reading',
        name: 'parallel_reading',
        builder: (context, state) => const ParallelReadingScreen(),
      ),

      // ==================== BOTTOM NAV TAB ROUTES ====================
      GoRoute(
        path: '/chat-tab',
        name: 'chat_tab',
        builder: (context, state) => const ChatTabScreen(),
      ),
      
      GoRoute(
        path: '/capsule-tab',
        name: 'capsule_tab',
        builder: (context, state) => const CapsuleTabScreen(),
      ),
      
      GoRoute(
        path: '/read-tab',
        name: 'read_tab',
        builder: (context, state) => const ReadTabScreen(),
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
        builder: (context, state) => AuthGuard(
          child: const ResponsiveBookLibraryScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),

      // ==================== CONNECTION STONES ROUTES ====================
      GoRoute(
        path: '/connection-stones',
        name: 'connection_stones',
        builder: (context, state) => AuthGuard(
          child: const ConnectionStonesDashboardScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),

      // ==================== CAPSULE GARDEN ROUTES ====================
      GoRoute(
        path: '/capsule-garden',
        name: 'capsule_garden',
        builder: (context, state) => AuthGuard(
          child: const CapsuleGardenDashboard(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),

      // ==================== CAPSULE CREATION ROUTES ====================
      GoRoute(
        // path: '/capsule/create',
        path: '/create_capsule',
        name: 'create_capsule',
        builder: (context, state) => AuthGuard(
          child: const CreateCapsulePage1Screen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/capsule/create/friend-selection',
        name: 'create_capsule_friend_selection',
        builder: (context, state) => AuthGuard(
          child: const FriendSelectionScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/capsule/create/anonymous-search',
        name: 'create_capsule_anonymous_search',
        builder: (context, state) => AuthGuard(
          child: const AnonymousUserSearchScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/capsule/create/delivery-time',
        name: 'create_capsule_delivery_time',
        builder: (context, state) => AuthGuard(
          child: const CreateCapsulePage2Screen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/capsule/create/message',
        name: 'create_capsule_message',
        builder: (context, state) => AuthGuard(
          child: const CreateCapsulePage3ScreenSimple(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/capsule/create/review',
        name: 'create_capsule_review',
        builder: (context, state) => AuthGuard(
          child: const CreateCapsuleFinalScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
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
        builder: (context, state) => AuthGuard(
          child: const DynamicProfileScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
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
          
          return AuthGuard(
            child: UserProfileScreen(
              userId: userId,
              userProfile: userProfile,
            ),
            unauthorizedBuilder: () => const SignInScreen(),
          );
        },
      ),

      // ==================== NOTIFICATIONS ROUTES ====================
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => AuthGuard(
          child: const NotificationScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
      ),

      // ==================== SETTINGS ROUTES ====================
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => AuthGuard(
          child: const SettingsScreen(),
          unauthorizedBuilder: () => const SignInScreen(),
        ),
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
});

/// Future Talk's routing configuration using GoRouter
/// Handles navigation between authentication screens with smooth transitions
class AppRouter {
  AppRouter._();

  // Transitions will be implemented per route when needed
}

/// Route names for type-safe navigation
class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signUp = '/sign_up';
  static const String signIn = '/sign_in';
  static const String verifyOtp = '/verify-otp';
  static const String dashboard = '/dashboard';
  static const String timeCapsules = '/time-capsules';
  static const String connectionStonesTab = '/connection-stones-tab';
  static const String parallelReading = '/parallel-reading';
  static const String chatTab = '/chat-tab';
  static const String capsuleTab = '/capsule-tab';
  static const String readTab = '/read-tab';
  static const String chat = '/chat';
  static const String individualChat = '/chat/individual';
  static const String books = '/books';
  static const String connectionStones = '/connection-stones';
  static const String capsuleGarden = '/capsule-garden';
  static const String createCapsule = '/capsule/create';
  static const String createCapsuleFriendSelection = '/capsule/create/friend-selection';
  static const String createCapsuleAnonymousSearch = '/capsule/create/anonymous-search';
  static const String createCapsuleReview = '/capsule/create/review';
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

  /// Navigate to OTP verification
  void goToVerifyOtp(String email, {String? message, int? expiresInMinutes}) {
    print('🚀 [Navigation] goToVerifyOtp called with email: $email');
    print('🚀 [Navigation] message: $message, expires: $expiresInMinutes');
    
    final extraData = {
      'email': email,
      'message': message,
      'expiresInMinutes': expiresInMinutes,
    };
    print('🚀 [Navigation] Extra data: $extraData');
    print('🚀 [Navigation] Calling go(${Routes.verifyOtp})');
    
    go(Routes.verifyOtp, extra: extraData);
    print('🚀 [Navigation] go() method completed');
  }

  /// Navigate to dashboard
  void goToDashboard() => go(Routes.dashboard);

  /// Navigate to chat list
  void goToChat() => go(Routes.chat);

  /// Navigate to book library
  void goToBooks() => go(Routes.books);

  /// Navigate to connection stones
  void goToConnectionStones() => go(Routes.connectionStones);

  /// Navigate to capsule garden
  void goToCapsuleGarden() => go(Routes.capsuleGarden);

  /// Navigate to create capsule screen
  void goToCreateCapsule() => go(Routes.createCapsule);

  /// Navigate to friend selection screen
  void goToFriendSelection() => go(Routes.createCapsuleFriendSelection);
  
  /// Navigate to anonymous user search screen
  void goToAnonymousSearch() => go(Routes.createCapsuleAnonymousSearch);

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