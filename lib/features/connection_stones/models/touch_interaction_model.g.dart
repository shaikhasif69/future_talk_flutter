// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'touch_interaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TouchInteractionImpl _$$TouchInteractionImplFromJson(
  Map<String, dynamic> json,
) => _$TouchInteractionImpl(
  id: json['id'] as String,
  stoneId: json['stoneId'] as String,
  touchType: $enumDecode(_$TouchTypeEnumMap, json['touchType']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
  direction: $enumDecode(_$TouchDirectionEnumMap, json['direction']),
  friendId: json['friendId'] as String,
  message: json['message'] as String?,
  intensity: (json['intensity'] as num?)?.toDouble() ?? 1.0,
  hadHapticFeedback: json['hadHapticFeedback'] as bool? ?? true,
  touchLocation: json['touchLocation'] == null
      ? null
      : TouchLocation.fromJson(json['touchLocation'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TouchInteractionImplToJson(
  _$TouchInteractionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'stoneId': instance.stoneId,
  'touchType': _$TouchTypeEnumMap[instance.touchType]!,
  'timestamp': instance.timestamp.toIso8601String(),
  'duration': instance.duration?.inMicroseconds,
  'direction': _$TouchDirectionEnumMap[instance.direction]!,
  'friendId': instance.friendId,
  'message': instance.message,
  'intensity': instance.intensity,
  'hadHapticFeedback': instance.hadHapticFeedback,
  'touchLocation': instance.touchLocation,
};

const _$TouchTypeEnumMap = {
  TouchType.quickTouch: 'quickTouch',
  TouchType.longPress: 'longPress',
  TouchType.doubleTap: 'doubleTap',
  TouchType.heartTouch: 'heartTouch',
};

const _$TouchDirectionEnumMap = {
  TouchDirection.sent: 'sent',
  TouchDirection.received: 'received',
};

_$TouchLocationImpl _$$TouchLocationImplFromJson(Map<String, dynamic> json) =>
    _$TouchLocationImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      size: (json['size'] as num?)?.toDouble() ?? 50.0,
    );

Map<String, dynamic> _$$TouchLocationImplToJson(_$TouchLocationImpl instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y, 'size': instance.size};

_$ComfortStatsImpl _$$ComfortStatsImplFromJson(Map<String, dynamic> json) =>
    _$ComfortStatsImpl(
      touchesGiven: (json['touchesGiven'] as num?)?.toInt() ?? 0,
      comfortReceived: (json['comfortReceived'] as num?)?.toInt() ?? 0,
      sacredStones: (json['sacredStones'] as num?)?.toInt() ?? 0,
      dailyStreak: (json['dailyStreak'] as num?)?.toInt() ?? 0,
      totalStones: (json['totalStones'] as num?)?.toInt() ?? 0,
      favoriteStoneType: json['favoriteStoneType'] as String?,
      mostConnectedFriend: json['mostConnectedFriend'] as String?,
      weeklyTouchGoal: (json['weeklyTouchGoal'] as num?)?.toInt() ?? 21,
      weeklyTouches: (json['weeklyTouches'] as num?)?.toInt() ?? 0,
      monthlyComfortGoal: (json['monthlyComfortGoal'] as num?)?.toInt() ?? 30,
      monthlyComfortReceived:
          (json['monthlyComfortReceived'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ComfortStatsImplToJson(_$ComfortStatsImpl instance) =>
    <String, dynamic>{
      'touchesGiven': instance.touchesGiven,
      'comfortReceived': instance.comfortReceived,
      'sacredStones': instance.sacredStones,
      'dailyStreak': instance.dailyStreak,
      'totalStones': instance.totalStones,
      'favoriteStoneType': instance.favoriteStoneType,
      'mostConnectedFriend': instance.mostConnectedFriend,
      'weeklyTouchGoal': instance.weeklyTouchGoal,
      'weeklyTouches': instance.weeklyTouches,
      'monthlyComfortGoal': instance.monthlyComfortGoal,
      'monthlyComfortReceived': instance.monthlyComfortReceived,
    };
