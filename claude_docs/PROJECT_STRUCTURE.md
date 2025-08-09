# Future Talk Frontend - Project Structure Documentation

## Overview
Future Talk is a premium Flutter messaging and social connection app designed for meaningful relationships. It features an introvert-friendly design with advanced functionality including time capsules, connection stones, parallel reading, and comprehensive chat features.

## 🏗️ Project Architecture

### Core Architecture Pattern
- **State Management**: Riverpod with code generation
- **Routing**: GoRouter with authentication guards
- **API Client**: Dio with interceptors and error handling
- **Data Layer**: Repository pattern with services
- **UI Architecture**: Feature-based modular structure
- **Code Generation**: Freezed for models, Riverpod for providers

### Technology Stack
```
Flutter Framework: Latest stable
State Management: Riverpod + Riverpod Annotation
Routing: GoRouter
HTTP Client: Dio
Local Storage: Flutter Secure Storage
Code Generation: build_runner, freezed, json_annotation
UI Components: Custom design system
```

## 📁 Directory Structure

```
lib/
├── app.dart                          # Main app configuration
├── main.dart                         # App entry point
├── core/                            # Core utilities and services
│   ├── constants/                   # App-wide constants
│   │   ├── app_colors.dart         # Color palette
│   │   ├── app_text_styles.dart    # Typography system
│   │   ├── app_dimensions.dart     # Spacing and sizing
│   │   └── app_durations.dart      # Animation timings
│   ├── guards/                     # Route guards
│   │   └── auth_guard.dart        # Authentication protection
│   ├── network/                    # Networking layer
│   │   ├── api_client.dart        # HTTP client configuration
│   │   ├── api_endpoints.dart     # API endpoint definitions
│   │   ├── api_result.dart        # Result wrapper for API calls
│   │   └── interceptors/          # Request/Response interceptors
│   └── storage/                    # Local storage services
│       └── secure_storage_service.dart # Secure token storage
├── features/                       # Feature modules (see below)
├── routing/                        # Navigation configuration
│   └── app_router.dart            # GoRouter setup with auth logic
├── shared/                         # Shared UI components
│   └── widgets/                   # Reusable widgets
└── claude_docs/                    # Project documentation
```

## 🎯 Features Architecture

Each feature follows a consistent structure:

```
features/[feature_name]/
├── models/                         # Data models
│   ├── [feature]_models.dart      # Main models
│   ├── [feature]_models.freezed.dart # Generated freezed code
│   └── [feature]_models.g.dart    # Generated JSON serialization
├── providers/                      # State management
│   ├── [feature]_provider.dart    # Main provider
│   └── [feature]_provider.g.dart  # Generated Riverpod code
├── screens/                        # UI screens
│   └── [feature]_screen.dart      # Screen implementations
├── services/                       # Business logic
│   └── [feature]_service.dart     # API service layer
└── widgets/                        # Feature-specific widgets
    └── [component]/               # Organized by component
```

## 🔐 Authentication System

### Auth Flow Structure
```
Authentication Flow:
Splash → Check Tokens → 
├── Valid: Dashboard
└── Invalid: Onboarding → Sign Up/In → OTP → Dashboard
```

### Key Components

#### AuthProvider (`features/auth/providers/auth_provider.dart`)
```dart
@riverpod
class Auth extends _$Auth {
  // Core authentication state management
  // Handles login, registration, OTP verification
  // Token management and background validation
}

AuthState:
- AuthUser? user
- bool isLoading
- bool isLoggedIn  
- bool isInitialized
- String? errorMessage
```

#### AuthService (`features/auth/services/auth_service.dart`)
```dart
class AuthService {
  // API interactions for authentication
  Future<ApiResult<AuthResponse>> login(LoginRequest request)
  Future<ApiResult<RegisterResponse>> register(RegisterRequest request)
  Future<ApiResult<AuthResponse>> verifyOtp(OtpVerificationRequest request)
  Future<ApiResult<ResendOtpResponse>> resendOtp(ResendOtpRequest request)
  Future<ApiResult<AuthUser>> getCurrentUser()
  Future<ApiResult<void>> logout()
}
```

#### Auth Models (`features/auth/models/auth_models.dart`)
```dart
// Key Models:
@freezed class AuthUser          # User profile data
@freezed class AuthResponse      # Login/OTP response
@freezed class LoginRequest      # Login credentials
@freezed class RegisterRequest   # Registration data
@freezed class OtpVerificationRequest # OTP verification
@freezed class ResendOtpRequest  # Resend OTP request
```

## 🌐 API Client Architecture

### Base Configuration (`core/network/api_client.dart`)
```dart
class ApiClient {
  late final Dio _dio;
  
  // Features:
  - Base URL configuration
  - Request/Response interceptors
  - Authentication token handling
  - Error handling and logging
  - Timeout configuration
  - Retry logic
}
```

### API Result Pattern (`core/network/api_result.dart`)
```dart
@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiError error) = Failure<T>;
}

@freezed
class ApiError with _$ApiError {
  // Structured error handling with:
  - String message
  - int statusCode  
  - Map<String, List<String>>? details
  - bool isUnauthorized
  - bool isNetworkError
}
```

### API Endpoints (`core/network/api_endpoints.dart`)
```dart
class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String userProfile = '/auth/profile';
  static const String passwordReset = '/auth/password-reset';
  static const String passwordResetConfirm = '/auth/password-reset/confirm';
}
```

## 🧭 Navigation System

### Router Configuration (`routing/app_router.dart`)
```dart
final routerProvider = Provider<GoRouter>((ref) {
  // Smart authentication-aware routing
  // Watches auth state changes
  // Handles redirects based on authentication status
  
  Redirect Logic:
  - Unauthenticated: /splash → /onboarding → /sign_up → /verify-otp → /dashboard
  - Authenticated: Direct to /dashboard
  - Protected routes: Require authentication
});
```

### Route Structure
```
Authentication Routes:
/splash                 # App initialization
/onboarding            # First-time user intro
/sign_up               # User registration
/sign_in               # User login  
/verify-otp            # OTP verification

Main App Routes:
/dashboard             # Main dashboard
/chat                  # Chat system
/time-capsules         # Time capsule management
/connection-stones     # Connection stones feature
/parallel-reading      # Shared reading experience
/profile               # User profile
/settings             # App settings
```

### Navigation Extensions
```dart
extension AppNavigation on BuildContext {
  void goToSignUp()
  void goToSignIn()  
  void goToVerifyOtp(String email, {String? message, int? expiresInMinutes})
  void goToDashboard()
  void goToProfile()
  // ... and more navigation methods
}
```

## 🎨 Design System

### Color Palette (`core/constants/app_colors.dart`)
```dart
class AppColors {
  // Primary colors for brand identity
  static const Color sageGreen = Color(0xFF9CAF7A);
  static const Color lavenderMist = Color(0xFFB4A7D6);
  static const Color dustyRose = Color(0xFFD4A5A5);
  static const Color warmCream = Color(0xFFF5F1E8);
  
  // Neutral colors for text and backgrounds
  static const Color softCharcoal = Color(0xFF2C2C2C);
  static const Color whisperGray = Color(0xFFE5E5E5);
  static const Color pearlWhite = Color(0xFFFAFAFA);
}
```

### Typography (`core/constants/app_text_styles.dart`)
```dart
class AppTextStyles {
  // Hierarchical text styles
  static const TextStyle displayLarge = TextStyle(...);
  static const TextStyle headlineLarge = TextStyle(...);
  static const TextStyle titleLarge = TextStyle(...);
  static const TextStyle bodyLarge = TextStyle(...);
  static const TextStyle labelLarge = TextStyle(...);
}
```

### Dimensions (`core/constants/app_dimensions.dart`)
```dart
class AppDimensions {
  // Consistent spacing system
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Border radius system
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
}
```

## 🔒 Security & Storage

### Secure Storage (`core/storage/secure_storage_service.dart`)
```dart
class SecureStorageService {
  // Secure token management
  static Future<void> saveTokens({required String accessToken, required String refreshToken})
  static Future<String?> getAccessToken()
  static Future<String?> getRefreshToken()
  static Future<bool> isLoggedIn()
  static Future<void> clearTokens()
  static Future<void> saveUserId(String userId)
}
```

### Authentication Guards (`core/guards/auth_guard.dart`)
```dart
class AuthGuard extends ConsumerWidget {
  // Protects routes requiring authentication
  // Redirects to sign-in if not authenticated
  // Shows loading states during auth checks
}
```

## 🎯 Current Features Implementation

### ✅ Completed Features

#### 1. Authentication System
- **Registration Flow**: Email/password → OTP verification → Dashboard
- **Login System**: Email/username + password authentication  
- **OTP Verification**: 6-digit code with auto-submit and resend functionality
- **Form Persistence**: Maintains form data when navigating between screens
- **Token Management**: Secure storage with automatic refresh

#### 2. Navigation System
- **Smart Routing**: Authentication-aware navigation
- **Splash Screen**: App initialization with auth state checking
- **Onboarding**: First-time user experience
- **Back Navigation**: Proper back button handling without crashes

#### 3. UI/UX Components
- **Design System**: Consistent colors, typography, and spacing
- **Form Components**: Validated input fields with real-time feedback
- **Loading States**: Proper loading indicators and states
- **Error Handling**: User-friendly error messages and snackbars
- **Animations**: Smooth transitions and micro-interactions

### 🚧 Features Ready for Implementation

#### 1. Chat System
**Structure**: `features/chat/`
- **Models**: Message, Conversation, ChatUser models
- **Providers**: ChatProvider for real-time messaging state
- **Services**: ChatService for API interactions  
- **Screens**: ChatListScreen, IndividualChatScreen
- **Widgets**: MessageBubble, ChatInput, TypingIndicator

**API Integration Points**:
```dart
// Required API endpoints for chat
/chat/conversations          # Get user conversations
/chat/conversations/:id      # Get conversation details
/chat/messages              # Send/receive messages
/chat/messages/:id/read     # Mark messages as read
/websocket/chat             # Real-time messaging
```

#### 2. Time Capsules
**Structure**: `features/capsule_creation/` & `features/capsule_garden/`
- **Models**: TimeCapsule, CapsuleMessage, DeliverySchedule
- **Providers**: CapsuleProvider for capsule management
- **Services**: CapsuleService for creation/management
- **Screens**: Creation flow, Garden dashboard, Capsule viewer

#### 3. Connection Stones  
**Structure**: `features/connection_stones/`
- **Models**: ConnectionStone, TouchEvent, StoneConnection
- **Providers**: ConnectionStonesProvider for real-time touch events
- **Services**: WebSocket integration for real-time touch feedback
- **Screens**: Stone dashboard, Touch interface

#### 4. Profile Management
**Structure**: `features/profile/` & `features/user_profile/`
- **Current**: Basic profile structure exists
- **Expansion**: Social battery, privacy settings, profile customization

## 🔧 Development Guidelines

### Code Generation Commands
```bash
# Generate all code (run after model/provider changes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development
dart run build_runner watch --delete-conflicting-outputs
```

### State Management Patterns
```dart
// Provider pattern example
@riverpod
class FeatureName extends _$FeatureName {
  @override
  FeatureState build() => FeatureState.initial();
  
  Future<void> performAction() async {
    state = state.copyWith(isLoading: true);
    
    final result = await _service.apiCall();
    
    result.when(
      success: (data) => state = state.copyWith(data: data, isLoading: false),
      failure: (error) => state = state.copyWith(error: error.message, isLoading: false),
    );
  }
}
```

### API Service Patterns
```dart
// Service pattern example
class FeatureService {
  final ApiClient _apiClient = ApiClient();
  
  Future<ApiResult<FeatureModel>> getData() async {
    try {
      final response = await _apiClient.get('/endpoint');
      if (response.statusCode == 200) {
        return ApiResult.success(FeatureModel.fromJson(response.data));
      }
      return ApiResult.failure(_parseError(response));
    } on DioException catch (e) {
      return ApiResult.failure(_handleDioError(e));
    }
  }
}
```

### Model Definition Patterns
```dart
// Model pattern example
@freezed
class FeatureModel with _$FeatureModel {
  const factory FeatureModel({
    required String id,
    required String name,
    @Default(false) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FeatureModel;
  
  factory FeatureModel.fromJson(Map<String, dynamic> json) => 
    _$FeatureModelFromJson(json);
}
```

## 🚀 Integration Guidelines for New Features

### 1. Feature Setup
1. Create feature directory structure
2. Define models with Freezed
3. Create service class for API integration
4. Implement Riverpod provider for state management
5. Build UI screens and widgets
6. Add routes to `app_router.dart`
7. Generate code with build_runner

### 2. API Integration
1. Add endpoints to `ApiEndpoints` class
2. Implement service methods using `ApiResult` pattern
3. Handle errors consistently
4. Add authentication headers where needed

### 3. State Management
1. Use Riverpod providers for all state
2. Follow the loading/success/error pattern
3. Implement proper error handling
4. Use code generation for type safety

### 4. UI/UX
1. Follow the established design system
2. Use consistent spacing and colors
3. Implement loading states and error handling
4. Add proper navigation and routing

### 5. Testing Strategy
1. Unit tests for services and providers
2. Widget tests for UI components
3. Integration tests for complete flows
4. Mock API responses for testing

## 📋 Current Status Summary

### ✅ Production Ready
- Authentication system (login/register/OTP)
- Navigation and routing
- Core UI components and design system
- API client and error handling
- Secure storage and token management

### 🔧 Ready for Extension
- Chat system (models and structure exist)
- Profile management (basic implementation)
- Time capsules (creation flow partially implemented)
- Connection stones (basic structure)
- Settings and notifications (structure exists)

### 🎯 Integration Priority
1. **Chat System**: Real-time messaging with WebSocket
2. **Profile Enhancement**: Social battery, privacy settings
3. **Time Capsules**: Complete creation and delivery system  
4. **Connection Stones**: Real-time touch interface
5. **Parallel Reading**: Synchronized reading experience

This documentation provides a comprehensive foundation for implementing new features while maintaining consistency with the existing architecture and patterns.