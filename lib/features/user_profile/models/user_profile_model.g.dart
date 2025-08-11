// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatarUrl'] as String,
      friendsSince: DateTime.parse(json['friendsSince'] as String),
      currentMoodStatus: SocialBatteryStatus.fromJson(
          json['currentMoodStatus'] as Map<String, dynamic>),
      connectionStats: ConnectionStats.fromJson(
          json['connectionStats'] as Map<String, dynamic>),
      sharedExperiences: (json['sharedExperiences'] as List<dynamic>)
          .map((e) => SharedExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeCapsules: (json['timeCapsules'] as List<dynamic>)
          .map((e) => TimeCapsuleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      readingSessions: (json['readingSessions'] as List<dynamic>)
          .map((e) => ReadingSession.fromJson(e as Map<String, dynamic>))
          .toList(),
      comfortStones: (json['comfortStones'] as List<dynamic>)
          .map((e) => ComfortStone.fromJson(e as Map<String, dynamic>))
          .toList(),
      friendshipStats: FriendshipStats.fromJson(
          json['friendshipStats'] as Map<String, dynamic>),
      isOnline: json['isOnline'] as bool? ?? true,
      isTyping: json['isTyping'] as bool? ?? false,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'bio': instance.bio,
      'avatarUrl': instance.avatarUrl,
      'friendsSince': instance.friendsSince.toIso8601String(),
      'currentMoodStatus': instance.currentMoodStatus,
      'connectionStats': instance.connectionStats,
      'sharedExperiences': instance.sharedExperiences,
      'timeCapsules': instance.timeCapsules,
      'readingSessions': instance.readingSessions,
      'comfortStones': instance.comfortStones,
      'friendshipStats': instance.friendshipStats,
      'isOnline': instance.isOnline,
      'isTyping': instance.isTyping,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };

_$SocialBatteryStatusImpl _$$SocialBatteryStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialBatteryStatusImpl(
      level: $enumDecode(_$BatteryLevelEnumMap, json['level']),
      description: json['description'] as String,
      colorName: json['colorName'] as String,
      isAvailableForChat: json['isAvailableForChat'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$SocialBatteryStatusImplToJson(
        _$SocialBatteryStatusImpl instance) =>
    <String, dynamic>{
      'level': _$BatteryLevelEnumMap[instance.level]!,
      'description': instance.description,
      'colorName': instance.colorName,
      'isAvailableForChat': instance.isAvailableForChat,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

const _$BatteryLevelEnumMap = {
  BatteryLevel.green: 'green',
  BatteryLevel.yellow: 'yellow',
  BatteryLevel.orange: 'orange',
  BatteryLevel.red: 'red',
};

_$ConnectionStatsImpl _$$ConnectionStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionStatsImpl(
      daysOfFriendship: (json['daysOfFriendship'] as num).toInt(),
      conversationsCount: (json['conversationsCount'] as num).toInt(),
      comfortTouchesShared: (json['comfortTouchesShared'] as num).toInt(),
      hoursReadingTogether: (json['hoursReadingTogether'] as num).toInt(),
      gamesPlayed: (json['gamesPlayed'] as num).toInt(),
      timeCapsulesSent: (json['timeCapsulesSent'] as num).toInt(),
    );

Map<String, dynamic> _$$ConnectionStatsImplToJson(
        _$ConnectionStatsImpl instance) =>
    <String, dynamic>{
      'daysOfFriendship': instance.daysOfFriendship,
      'conversationsCount': instance.conversationsCount,
      'comfortTouchesShared': instance.comfortTouchesShared,
      'hoursReadingTogether': instance.hoursReadingTogether,
      'gamesPlayed': instance.gamesPlayed,
      'timeCapsulesSent': instance.timeCapsulesSent,
    };

_$SharedExperienceImpl _$$SharedExperienceImplFromJson(
        Map<String, dynamic> json) =>
    _$SharedExperienceImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ExperienceTypeEnumMap, json['type']),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
      count: (json['count'] as num).toInt(),
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
    );

Map<String, dynamic> _$$SharedExperienceImplToJson(
        _$SharedExperienceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ExperienceTypeEnumMap[instance.type]!,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'icon': instance.icon,
      'count': instance.count,
      'lastActivity': instance.lastActivity?.toIso8601String(),
    };

const _$ExperienceTypeEnumMap = {
  ExperienceType.books: 'books',
  ExperienceType.games: 'games',
  ExperienceType.timeCapsules: 'timeCapsules',
  ExperienceType.comfortTouches: 'comfortTouches',
};

_$TimeCapsuleItemImpl _$$TimeCapsuleItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TimeCapsuleItemImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      preview: json['preview'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      status: $enumDecode(_$CapsuleStatusEnumMap, json['status']),
      isFromCurrentUser: json['isFromCurrentUser'] as bool? ?? false,
    );

Map<String, dynamic> _$$TimeCapsuleItemImplToJson(
        _$TimeCapsuleItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'preview': instance.preview,
      'createdAt': instance.createdAt.toIso8601String(),
      'deliveryDate': instance.deliveryDate.toIso8601String(),
      'status': _$CapsuleStatusEnumMap[instance.status]!,
      'isFromCurrentUser': instance.isFromCurrentUser,
    };

const _$CapsuleStatusEnumMap = {
  CapsuleStatus.scheduled: 'scheduled',
  CapsuleStatus.delivered: 'delivered',
  CapsuleStatus.opened: 'opened',
};

_$ReadingSessionImpl _$$ReadingSessionImplFromJson(Map<String, dynamic> json) =>
    _$ReadingSessionImpl(
      id: json['id'] as String,
      bookTitle: json['bookTitle'] as String,
      author: json['author'] as String,
      bookCover: json['bookCover'] as String,
      currentChapter: (json['currentChapter'] as num).toInt(),
      totalChapters: (json['totalChapters'] as num).toInt(),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
      status: $enumDecode(_$ReadingStatusEnumMap, json['status']),
      participantIds: (json['participantIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ReadingSessionImplToJson(
        _$ReadingSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookTitle': instance.bookTitle,
      'author': instance.author,
      'bookCover': instance.bookCover,
      'currentChapter': instance.currentChapter,
      'totalChapters': instance.totalChapters,
      'progressPercentage': instance.progressPercentage,
      'lastReadAt': instance.lastReadAt.toIso8601String(),
      'status': _$ReadingStatusEnumMap[instance.status]!,
      'participantIds': instance.participantIds,
    };

const _$ReadingStatusEnumMap = {
  ReadingStatus.active: 'active',
  ReadingStatus.completed: 'completed',
  ReadingStatus.paused: 'paused',
};

_$ComfortStoneImpl _$$ComfortStoneImplFromJson(Map<String, dynamic> json) =>
    _$ComfortStoneImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      creatorId: json['creatorId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalTouches: (json['totalTouches'] as num).toInt(),
      lastTouchedAt: json['lastTouchedAt'] == null
          ? null
          : DateTime.parse(json['lastTouchedAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
      isSharedWithCurrentUser:
          json['isSharedWithCurrentUser'] as bool? ?? false,
    );

Map<String, dynamic> _$$ComfortStoneImplToJson(_$ComfortStoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt.toIso8601String(),
      'totalTouches': instance.totalTouches,
      'lastTouchedAt': instance.lastTouchedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'isSharedWithCurrentUser': instance.isSharedWithCurrentUser,
    };

_$FriendshipStatsImpl _$$FriendshipStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendshipStatsImpl(
      totalDays: (json['totalDays'] as num).toInt(),
      meaningfulConversations: (json['meaningfulConversations'] as num).toInt(),
      hoursReadingTogether: (json['hoursReadingTogether'] as num).toInt(),
      comfortTouchesShared: (json['comfortTouchesShared'] as num).toInt(),
    );

Map<String, dynamic> _$$FriendshipStatsImplToJson(
        _$FriendshipStatsImpl instance) =>
    <String, dynamic>{
      'totalDays': instance.totalDays,
      'meaningfulConversations': instance.meaningfulConversations,
      'hoursReadingTogether': instance.hoursReadingTogether,
      'comfortTouchesShared': instance.comfortTouchesShared,
    };
