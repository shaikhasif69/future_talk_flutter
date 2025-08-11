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
  static const String userLookup = '$users/lookup';
  static const String userSuggestions = '$users/search/suggestions';
  
  // Social/Friends endpoints
  static const String social = '/social';
  static const String friends = '$social/friends';
  static const String friendRequests = '$friends/request';
  static const String acceptFriendRequest = '$friends/accept';
  static const String rejectFriendRequest = '$friends/reject';
  static const String cancelFriendRequest = '$friends/cancel';
  static const String blockUser = '$friends/block';
  static const String unblockUser = '$friends/unblock';
  static const String friendsList = '$friends/list';
  static const String friendRequestsList = '$friends/requests';
  
  static String userById(String userId) => '$users/$userId';
  static String acceptFriendRequestById(String requestId) => '$friends/accept/$requestId';
  static String rejectFriendRequestById(String requestId) => '$friends/reject/$requestId';
  static String cancelFriendRequestById(String requestId) => '$friends/cancel/$requestId';
  static String blockUserById(String userId) => '$friends/block/$userId';
  static String unblockUserById(String userId) => '$friends/unblock/$userId';
}