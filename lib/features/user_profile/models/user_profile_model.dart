import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// Comprehensive user profile model for Future Talk premium features
@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String name,
    required String username,
    required String bio,
    required String avatarUrl,
    required DateTime friendsSince,
    required SocialBatteryStatus currentMoodStatus,
    required ConnectionStats connectionStats,
    required List<SharedExperience> sharedExperiences,
    required List<TimeCapsuleItem> timeCapsules,
    required List<ReadingSession> readingSessions,
    required List<ComfortStone> comfortStones,
    required FriendshipStats friendshipStats,
    @Default(true) bool isOnline,
    @Default(false) bool isTyping,
    DateTime? lastSeen,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

/// Social battery status for mood indication
@freezed
class SocialBatteryStatus with _$SocialBatteryStatus {
  const factory SocialBatteryStatus({
    required BatteryLevel level,
    required String description,
    required String colorName,
    @Default(false) bool isAvailableForChat,
    DateTime? lastUpdated,
  }) = _SocialBatteryStatus;

  factory SocialBatteryStatus.fromJson(Map<String, dynamic> json) =>
      _$SocialBatteryStatusFromJson(json);
}

/// Battery level enumeration
enum BatteryLevel {
  @JsonValue('green')
  green,
  @JsonValue('yellow')
  yellow,
  @JsonValue('orange')
  orange,
  @JsonValue('red')
  red,
}

/// Connection statistics between users
@freezed
class ConnectionStats with _$ConnectionStats {
  const factory ConnectionStats({
    required int daysOfFriendship,
    required int conversationsCount,
    required int comfortTouchesShared,
    required int hoursReadingTogether,
    required int gamesPlayed,
    required int timeCapsulesSent,
  }) = _ConnectionStats;

  factory ConnectionStats.fromJson(Map<String, dynamic> json) =>
      _$ConnectionStatsFromJson(json);
}

/// Shared experience between users
@freezed
class SharedExperience with _$SharedExperience {
  const factory SharedExperience({
    required String id,
    required ExperienceType type,
    required String title,
    required String subtitle,
    required String icon,
    required int count,
    DateTime? lastActivity,
  }) = _SharedExperience;

  factory SharedExperience.fromJson(Map<String, dynamic> json) =>
      _$SharedExperienceFromJson(json);
}

/// Types of shared experiences
enum ExperienceType {
  @JsonValue('books')
  books,
  @JsonValue('games')
  games,
  @JsonValue('timeCapsules')
  timeCapsules,
  @JsonValue('comfortTouches')
  comfortTouches,
}

/// Time capsule message item
@freezed
class TimeCapsuleItem with _$TimeCapsuleItem {
  const factory TimeCapsuleItem({
    required String id,
    required String senderId,
    required String recipientId,
    required String preview,
    required DateTime createdAt,
    required DateTime deliveryDate,
    required CapsuleStatus status,
    @Default(false) bool isFromCurrentUser,
  }) = _TimeCapsuleItem;

  factory TimeCapsuleItem.fromJson(Map<String, dynamic> json) =>
      _$TimeCapsuleItemFromJson(json);
}

/// Time capsule status
enum CapsuleStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('delivered')
  delivered,
  @JsonValue('opened')
  opened,
}

/// Reading session for parallel reading feature
@freezed
class ReadingSession with _$ReadingSession {
  const factory ReadingSession({
    required String id,
    required String bookTitle,
    required String author,
    required String bookCover,
    required int currentChapter,
    required int totalChapters,
    required double progressPercentage,
    required DateTime lastReadAt,
    required ReadingStatus status,
    List<String>? participantIds,
  }) = _ReadingSession;

  factory ReadingSession.fromJson(Map<String, dynamic> json) =>
      _$ReadingSessionFromJson(json);
}

/// Reading session status
enum ReadingStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('paused')
  paused,
}

/// Comfort stone for emotional connection
@freezed
class ComfortStone with _$ComfortStone {
  const factory ComfortStone({
    required String id,
    required String name,
    required String icon,
    required String creatorId,
    required DateTime createdAt,
    required int totalTouches,
    DateTime? lastTouchedAt,
    @Default(false) bool isActive,
    @Default(false) bool isSharedWithCurrentUser,
  }) = _ComfortStone;

  factory ComfortStone.fromJson(Map<String, dynamic> json) =>
      _$ComfortStoneFromJson(json);
}

/// Friendship statistics summary
@freezed
class FriendshipStats with _$FriendshipStats {
  const factory FriendshipStats({
    required int totalDays,
    required int meaningfulConversations,
    required int hoursReadingTogether,
    required int comfortTouchesShared,
  }) = _FriendshipStats;

  factory FriendshipStats.fromJson(Map<String, dynamic> json) =>
      _$FriendshipStatsFromJson(json);
}

/// Mock data generator for user profile
class UserProfileMockData {
  static UserProfileModel get sarahProfile => UserProfileModel(
        id: 'user_sarah_001',
        name: 'Sarah Chen',
        username: '@sarah_mindful',
        bio: 'Book lover, comfort stone creator, and believer in the magic of slow conversations ✨',
        avatarUrl: '',
        friendsSince: DateTime.now().subtract(const Duration(days: 247)),
        currentMoodStatus: const SocialBatteryStatus(
          level: BatteryLevel.yellow,
          description: 'Sarah is in selective response mode today. She\'s available for meaningful conversations but taking her time with replies.',
          colorName: 'Yellow',
          isAvailableForChat: true,
        ),
        connectionStats: const ConnectionStats(
          daysOfFriendship: 247,
          conversationsCount: 89,
          comfortTouchesShared: 156,
          hoursReadingTogether: 23,
          gamesPlayed: 5,
          timeCapsulesSent: 12,
        ),
        sharedExperiences: [
          const SharedExperience(
            id: 'exp_books',
            type: ExperienceType.books,
            title: '3 Books Read',
            subtitle: 'Together in sync',
            icon: '📚',
            count: 3,
          ),
          const SharedExperience(
            id: 'exp_touches',
            type: ExperienceType.comfortTouches,
            title: '47 Comfort Touches',
            subtitle: 'Mutual support',
            icon: '🪨',
            count: 47,
          ),
          const SharedExperience(
            id: 'exp_capsules',
            type: ExperienceType.timeCapsules,
            title: '12 Time Capsules',
            subtitle: 'Future memories',
            icon: '⏰',
            count: 12,
          ),
          const SharedExperience(
            id: 'exp_games',
            type: ExperienceType.games,
            title: '5 Games Played',
            subtitle: 'Thoughtful fun',
            icon: '🎮',
            count: 5,
          ),
        ],
        timeCapsules: [
          TimeCapsuleItem(
            id: 'capsule_001',
            senderId: 'user_sarah_001',
            recipientId: 'current_user',
            preview: 'I hope by the time you read this, we\'ll have finished our book club challenge...',
            createdAt: DateTime.now().subtract(const Duration(days: 7)),
            deliveryDate: DateTime.now(),
            status: CapsuleStatus.delivered,
            isFromCurrentUser: false,
          ),
          TimeCapsuleItem(
            id: 'capsule_002',
            senderId: 'current_user',
            recipientId: 'user_sarah_001',
            preview: 'Thank you for always understanding my introvert energy. You make friendship feel safe...',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            deliveryDate: DateTime.now().subtract(const Duration(days: 2)),
            status: CapsuleStatus.delivered,
            isFromCurrentUser: true,
          ),
          TimeCapsuleItem(
            id: 'capsule_003',
            senderId: 'user_sarah_001',
            recipientId: 'current_user',
            preview: '🔒 Scheduled time capsule waiting to be delivered',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
            deliveryDate: DateTime.now().add(const Duration(days: 5)),
            status: CapsuleStatus.scheduled,
            isFromCurrentUser: false,
          ),
        ],
        readingSessions: [
          ReadingSession(
            id: 'reading_001',
            bookTitle: 'Pride and Prejudice',
            author: 'Jane Austen',
            bookCover: '📚',
            currentChapter: 8,
            totalChapters: 24,
            progressPercentage: 65.0,
            lastReadAt: DateTime.now().subtract(const Duration(hours: 2)),
            status: ReadingStatus.active,
            participantIds: ['current_user', 'user_sarah_001'],
          ),
          ReadingSession(
            id: 'reading_002',
            bookTitle: 'Little Women',
            author: 'Louisa May Alcott',
            bookCover: '🌸',
            currentChapter: 24,
            totalChapters: 24,
            progressPercentage: 100.0,
            lastReadAt: DateTime.now().subtract(const Duration(days: 14)),
            status: ReadingStatus.completed,
            participantIds: ['current_user', 'user_sarah_001'],
          ),
        ],
        comfortStones: [
          ComfortStone(
            id: 'stone_001',
            name: 'Evening Calm',
            icon: '🌙',
            creatorId: 'user_sarah_001',
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            totalTouches: 24,
            lastTouchedAt: DateTime.now().subtract(const Duration(hours: 2)),
            isActive: true,
            isSharedWithCurrentUser: true,
          ),
          ComfortStone(
            id: 'stone_002',
            name: 'Cherry Blossom',
            icon: '🌸',
            creatorId: 'user_sarah_001',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
            totalTouches: 12,
            lastTouchedAt: DateTime.now().subtract(const Duration(hours: 1)),
            isActive: false,
            isSharedWithCurrentUser: true,
          ),
          ComfortStone(
            id: 'stone_003',
            name: 'Clarity Crystal',
            icon: '💎',
            creatorId: 'user_sarah_001',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
            totalTouches: 8,
            lastTouchedAt: DateTime.now().subtract(const Duration(days: 1)),
            isActive: false,
            isSharedWithCurrentUser: true,
          ),
        ],
        friendshipStats: const FriendshipStats(
          totalDays: 247,
          meaningfulConversations: 89,
          hoursReadingTogether: 23,
          comfortTouchesShared: 156,
        ),
        isOnline: true,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      );
}