import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_capsule.freezed.dart';
part 'time_capsule.g.dart';

/// Represents a time capsule in the garden with growth stages
@freezed
class TimeCapsule with _$TimeCapsule {
  const factory TimeCapsule({
    required String id,
    required String title,
    required String content,
    required String recipientId,
    required String recipientName,
    required String recipientInitial,
    required DateTime plantedAt,
    required DateTime deliveryAt,
    required CapsuleGrowthStage growthStage,
    required String emoji,
    required CapsuleType type,
    @Default(false) bool isReady,
    @Default(0.0) double progress,
    String? theme,
    Map<String, dynamic>? metadata,
  }) = _TimeCapsule;

  factory TimeCapsule.fromJson(Map<String, dynamic> json) =>
      _$TimeCapsuleFromJson(json);
}

/// Growth stages of a time capsule
enum CapsuleGrowthStage {
  @JsonValue('seed')
  seed('🌰', 'Seed'),
  @JsonValue('sprout')
  sprout('🌱', 'Sprout'),
  @JsonValue('sapling')
  sapling('🌿', 'Sapling'),
  @JsonValue('tree')
  tree('🌳', 'Tree'),
  @JsonValue('flowering')
  flowering('🌸', 'Flowering'),
  @JsonValue('crystal')
  crystal('💎', 'Crystal'),
  @JsonValue('ready')
  ready('🎁', 'Ready');

  const CapsuleGrowthStage(this.emoji, this.displayName);
  final String emoji;
  final String displayName;
}

/// Types of time capsules
enum CapsuleType {
  @JsonValue('personal')
  personal('Personal', '💭'),
  @JsonValue('birthday')
  birthday('Birthday', '🎂'),
  @JsonValue('anniversary')
  anniversary('Anniversary', '💕'),
  @JsonValue('encouragement')
  encouragement('Encouragement', '🌟'),
  @JsonValue('gratitude')
  gratitude('Gratitude', '🙏'),
  @JsonValue('future_self')
  futureSelf('Future Self', '🔮'),
  @JsonValue('celebration')
  celebration('Celebration', '🎉');

  const CapsuleType(this.displayName, this.emoji);
  final String displayName;
  final String emoji;
}

/// Garden statistics
@freezed
class GardenStats with _$GardenStats {
  const factory GardenStats({
    @Default(0) int totalPlanted,
    @Default(0) int growing,
    @Default(0) int ready,
    @Default(0) int delivered,
    @Default(0) int recentlyPlanted,
    @Default(0.0) double averageGrowthProgress,
  }) = _GardenStats;

  factory GardenStats.fromJson(Map<String, dynamic> json) =>
      _$GardenStatsFromJson(json);
}

/// Garden section for organizing capsules
@freezed
class GardenSection with _$GardenSection {
  const factory GardenSection({
    required String title,
    required String emoji,
    required List<TimeCapsule> capsules,
    required GardenSectionType type,
  }) = _GardenSection;

  factory GardenSection.fromJson(Map<String, dynamic> json) =>
      _$GardenSectionFromJson(json);
}

/// Types of garden sections
enum GardenSectionType {
  @JsonValue('ready')
  ready,
  @JsonValue('growing')
  growing,
  @JsonValue('recently_planted')
  recentlyPlanted,
}