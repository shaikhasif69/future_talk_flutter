// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookImpl _$$BookImplFromJson(Map<String, dynamic> json) => _$BookImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      coverEmoji: json['coverEmoji'] as String,
      rating: (json['rating'] as num).toDouble(),
      durationHours: (json['durationHours'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isPremium: json['isPremium'] as bool,
      comfortLevel:
          $enumDecode(_$BookComfortLevelEnumMap, json['comfortLevel']),
      description: json['description'] as String? ?? '',
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      isAvailableForParallel: json['isAvailableForParallel'] as bool? ?? false,
      partnerReadingWith: json['partnerReadingWith'] as String? ?? null,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BookImplToJson(_$BookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'coverEmoji': instance.coverEmoji,
      'rating': instance.rating,
      'durationHours': instance.durationHours,
      'tags': instance.tags,
      'isPremium': instance.isPremium,
      'comfortLevel': _$BookComfortLevelEnumMap[instance.comfortLevel]!,
      'description': instance.description,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'isAvailableForParallel': instance.isAvailableForParallel,
      'partnerReadingWith': instance.partnerReadingWith,
      'genres': instance.genres,
    };

const _$BookComfortLevelEnumMap = {
  BookComfortLevel.comforting: 'comforting',
  BookComfortLevel.emotional: 'emotional',
  BookComfortLevel.gentle: 'gentle',
  BookComfortLevel.mindful: 'mindful',
  BookComfortLevel.energizing: 'energizing',
  BookComfortLevel.challenging: 'challenging',
  BookComfortLevel.inspiring: 'inspiring',
};

_$ReadingProgressImpl _$$ReadingProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$ReadingProgressImpl(
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookAuthor: json['bookAuthor'] as String,
      coverEmoji: json['coverEmoji'] as String,
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentChapter: (json['currentChapter'] as num).toInt(),
      totalChapters: (json['totalChapters'] as num).toInt(),
      mood: $enumDecode(_$ReadingMoodEnumMap, json['mood']),
      minutesLeft: (json['minutesLeft'] as num).toInt(),
      readingStreak: (json['readingStreak'] as num).toInt(),
      partner: json['partner'] == null
          ? null
          : ReadingPartner.fromJson(json['partner'] as Map<String, dynamic>),
      isSynced: json['isSynced'] as bool? ?? true,
      lastReadAt: json['lastReadAt'] as String? ?? '',
    );

Map<String, dynamic> _$$ReadingProgressImplToJson(
        _$ReadingProgressImpl instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'bookAuthor': instance.bookAuthor,
      'coverEmoji': instance.coverEmoji,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'currentChapter': instance.currentChapter,
      'totalChapters': instance.totalChapters,
      'mood': _$ReadingMoodEnumMap[instance.mood]!,
      'minutesLeft': instance.minutesLeft,
      'readingStreak': instance.readingStreak,
      'partner': instance.partner,
      'isSynced': instance.isSynced,
      'lastReadAt': instance.lastReadAt,
    };

const _$ReadingMoodEnumMap = {
  ReadingMood.peaceful: 'peaceful',
  ReadingMood.inspired: 'inspired',
  ReadingMood.curious: 'curious',
  ReadingMood.romantic: 'romantic',
  ReadingMood.growing: 'growing',
  ReadingMood.focused: 'focused',
  ReadingMood.adventurous: 'adventurous',
  ReadingMood.reflective: 'reflective',
};

_$ReadingPartnerImpl _$$ReadingPartnerImplFromJson(Map<String, dynamic> json) =>
    _$ReadingPartnerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarInitial: json['avatarInitial'] as String,
      currentPage: (json['currentPage'] as num).toInt(),
      isOnline: json['isOnline'] as bool,
      lastActiveAt: json['lastActiveAt'] as String? ?? '',
    );

Map<String, dynamic> _$$ReadingPartnerImplToJson(
        _$ReadingPartnerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarInitial': instance.avatarInitial,
      'currentPage': instance.currentPage,
      'isOnline': instance.isOnline,
      'lastActiveAt': instance.lastActiveAt,
    };

_$FriendReadingImpl _$$FriendReadingImplFromJson(Map<String, dynamic> json) =>
    _$FriendReadingImpl(
      friendId: json['friendId'] as String,
      friendName: json['friendName'] as String,
      avatarInitial: json['avatarInitial'] as String,
      bookTitle: json['bookTitle'] as String,
      bookAuthor: json['bookAuthor'] as String,
      currentChapter: json['currentChapter'] as String,
      status: $enumDecode(_$FriendActivityStatusEnumMap, json['status']),
      timeAgo: json['timeAgo'] as String,
      isOpenForPartners: json['isOpenForPartners'] as bool,
      canJoin: json['canJoin'] as bool? ?? false,
    );

Map<String, dynamic> _$$FriendReadingImplToJson(_$FriendReadingImpl instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'friendName': instance.friendName,
      'avatarInitial': instance.avatarInitial,
      'bookTitle': instance.bookTitle,
      'bookAuthor': instance.bookAuthor,
      'currentChapter': instance.currentChapter,
      'status': _$FriendActivityStatusEnumMap[instance.status]!,
      'timeAgo': instance.timeAgo,
      'isOpenForPartners': instance.isOpenForPartners,
      'canJoin': instance.canJoin,
    };

const _$FriendActivityStatusEnumMap = {
  FriendActivityStatus.reading: 'reading',
  FriendActivityStatus.recentlyActive: 'recentlyActive',
  FriendActivityStatus.recharging: 'recharging',
  FriendActivityStatus.offline: 'offline',
};

_$BookRecommendationImpl _$$BookRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$BookRecommendationImpl(
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      reason: json['reason'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      basedOn: json['basedOn'] as String,
      coverEmoji: json['coverEmoji'] as String? ?? '',
    );

Map<String, dynamic> _$$BookRecommendationImplToJson(
        _$BookRecommendationImpl instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'title': instance.title,
      'author': instance.author,
      'reason': instance.reason,
      'confidenceScore': instance.confidenceScore,
      'basedOn': instance.basedOn,
      'coverEmoji': instance.coverEmoji,
    };

_$ReadingStatsImpl _$$ReadingStatsImplFromJson(Map<String, dynamic> json) =>
    _$ReadingStatsImpl(
      booksRead: (json['booksRead'] as num).toInt(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      friendsReading: (json['friendsReading'] as num).toInt(),
      hoursThisMonth: (json['hoursThisMonth'] as num).toInt(),
      totalHours: (json['totalHours'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      favoriteGenreCount: (json['favoriteGenreCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReadingStatsImplToJson(_$ReadingStatsImpl instance) =>
    <String, dynamic>{
      'booksRead': instance.booksRead,
      'currentStreak': instance.currentStreak,
      'friendsReading': instance.friendsReading,
      'hoursThisMonth': instance.hoursThisMonth,
      'totalHours': instance.totalHours,
      'longestStreak': instance.longestStreak,
      'favoriteGenreCount': instance.favoriteGenreCount,
    };
