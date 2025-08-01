import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

/// Book model for the library system
@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    required String author,
    required String coverEmoji,
    required double rating,
    required int durationHours,
    required List<String> tags,
    required bool isPremium,
    required BookComfortLevel comfortLevel,
    @Default('') String description,
    @Default(0) int totalPages,
    @Default(0) int currentPage,
    @Default(false) bool isAvailableForParallel,
    @Default(null) String? partnerReadingWith,
    @Default([]) List<String> genres,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

/// Reading progress for current books
@freezed
class ReadingProgress with _$ReadingProgress {
  const factory ReadingProgress({
    required String bookId,
    required String bookTitle,
    required String bookAuthor,
    required String coverEmoji,
    required int currentPage,
    required int totalPages,
    required int currentChapter,
    required int totalChapters,
    required ReadingMood mood,
    required int minutesLeft,
    required int readingStreak,
    @Default(null) ReadingPartner? partner,
    @Default(true) bool isSynced,
    @Default('') String lastReadAt,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) => 
      _$ReadingProgressFromJson(json);
}

/// Partner reading information
@freezed
class ReadingPartner with _$ReadingPartner {
  const factory ReadingPartner({
    required String id,
    required String name,
    required String avatarInitial,
    required int currentPage,
    required bool isOnline,
    @Default('') String lastActiveAt,
  }) = _ReadingPartner;

  factory ReadingPartner.fromJson(Map<String, dynamic> json) => 
      _$ReadingPartnerFromJson(json);
}

/// Friend's reading activity
@freezed
class FriendReading with _$FriendReading {
  const factory FriendReading({
    required String friendId,
    required String friendName,
    required String avatarInitial,
    required String bookTitle,
    required String bookAuthor,
    required String currentChapter,
    required FriendActivityStatus status,
    required String timeAgo,
    required bool isOpenForPartners,
    @Default(false) bool canJoin,
  }) = _FriendReading;

  factory FriendReading.fromJson(Map<String, dynamic> json) => 
      _$FriendReadingFromJson(json);
}

/// AI book recommendation
@freezed
class BookRecommendation with _$BookRecommendation {
  const factory BookRecommendation({
    required String bookId,
    required String title,
    required String author,
    required String reason,
    required double confidenceScore,
    required String basedOn,
    @Default('') String coverEmoji,
  }) = _BookRecommendation;

  factory BookRecommendation.fromJson(Map<String, dynamic> json) => 
      _$BookRecommendationFromJson(json);
}

/// Reading statistics
@freezed
class ReadingStats with _$ReadingStats {
  const factory ReadingStats({
    required int booksRead,
    required int currentStreak,
    required int friendsReading,
    required int hoursThisMonth,
    @Default(0) int totalHours,
    @Default(0) int longestStreak,
    @Default(0) int favoriteGenreCount,
  }) = _ReadingStats;

  factory ReadingStats.fromJson(Map<String, dynamic> json) => 
      _$ReadingStatsFromJson(json);
}

/// Enums for book properties
enum BookComfortLevel {
  comforting,
  emotional,
  gentle,
  mindful,
  energizing,
  challenging,
  inspiring,
}

enum ReadingMood {
  peaceful,
  inspired,
  curious,
  romantic,
  growing,
  focused,
  adventurous,
  reflective,
}

enum FriendActivityStatus {
  reading,
  recentlyActive,
  recharging,
  offline,
}

/// Extensions for display values
extension BookComfortLevelExtension on BookComfortLevel {
  String get displayName {
    switch (this) {
      case BookComfortLevel.comforting:
        return 'Comforting';
      case BookComfortLevel.emotional:
        return 'Emotional';
      case BookComfortLevel.gentle:
        return 'Gentle';
      case BookComfortLevel.mindful:
        return 'Mindful';
      case BookComfortLevel.energizing:
        return 'Energizing';
      case BookComfortLevel.challenging:
        return 'Challenging';
      case BookComfortLevel.inspiring:
        return 'Inspiring';
    }
  }
}

extension ReadingMoodExtension on ReadingMood {
  String get emoji {
    switch (this) {
      case ReadingMood.peaceful:
        return '😌';
      case ReadingMood.inspired:
        return '✨';
      case ReadingMood.curious:
        return '🤔';
      case ReadingMood.romantic:
        return '💝';
      case ReadingMood.growing:
        return '🌱';
      case ReadingMood.focused:
        return '🎯';
      case ReadingMood.adventurous:
        return '🌟';
      case ReadingMood.reflective:
        return '🤲';
    }
  }

  String get displayName {
    switch (this) {
      case ReadingMood.peaceful:
        return 'Peaceful';
      case ReadingMood.inspired:
        return 'Inspired';
      case ReadingMood.curious:
        return 'Curious';
      case ReadingMood.romantic:
        return 'Romantic';
      case ReadingMood.growing:
        return 'Growing';
      case ReadingMood.focused:
        return 'Focused';
      case ReadingMood.adventurous:
        return 'Adventurous';
      case ReadingMood.reflective:
        return 'Reflective';
    }
  }
}

extension FriendActivityStatusExtension on FriendActivityStatus {
  String get emoji {
    switch (this) {
      case FriendActivityStatus.reading:
        return '🟢';
      case FriendActivityStatus.recentlyActive:
        return '🟡';
      case FriendActivityStatus.recharging:
        return '🔴';
      case FriendActivityStatus.offline:
        return '⚫';
    }
  }

  String get displayName {
    switch (this) {
      case FriendActivityStatus.reading:
        return 'Reading now';
      case FriendActivityStatus.recentlyActive:
        return 'Recently active';
      case FriendActivityStatus.recharging:
        return 'Recharging';
      case FriendActivityStatus.offline:
        return 'Offline';
    }
  }
}