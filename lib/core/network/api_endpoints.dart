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
  
  // Social/Friends endpoints - matching actual backend paths
  static const String social = '/social';
  static const String friends = '$social/friends';
  static const String friendRequests = '$social/friend-requests';
  static const String acceptFriendRequest = '$social/friend-requests/accept';
  static const String rejectFriendRequest = '$social/friend-requests/reject';
  static const String cancelFriendRequest = '$social/friend-requests/cancel';
  static const String blockUser = '$social/block';
  static const String unblockUser = '$social/unblock';
  static const String friendsList = '$social/friends'; // This is the correct path!
  static const String friendRequestsList = '$social/friend-requests';
  
  static String userById(String userId) => '$users/$userId';
  static String userProfileById(String userId) => '$users/profile/$userId';
  static String acceptFriendRequestById(String requestId) => '$acceptFriendRequest/$requestId';
  static String rejectFriendRequestById(String requestId) => '$rejectFriendRequest/$requestId';
  static String cancelFriendRequestById(String requestId) => '$cancelFriendRequest/$requestId';
  static String blockUserById(String userId) => '$blockUser/$userId';
  static String unblockUserById(String userId) => '$unblockUser/$userId';
}