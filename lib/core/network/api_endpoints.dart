class ApiEndpoints {
  static const String auth = '/auth';
  static const String users = '/users';

  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String verifyOtp = '$auth/verify-otp';
  static const String resendOtp = '$auth/resend-otp';
  static const String refresh = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String passwordReset = '$auth/password-reset';
  static const String passwordResetConfirm = '$auth/password-reset/confirm';

  static const String userProfile = '$users/me';
  static const String updateProfile = '$users/me';
  static const String uploadProfileImage = '$users/me/profile-image';
  static const String changePassword = '$users/me/change-password';
  static const String updatePrivacySettings = '$users/me/privacy';
  static const String deactivateAccount = '$users/me/deactivate';
  static const String deleteAccount = '$users/me';
  
  static const String searchUsers = '$users/search';
  static const String userSuggestions = '$users/suggestions';
  
  static String userById(String userId) => '$users/$userId';
}