// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_stone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectionStoneImpl _$$ConnectionStoneImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionStoneImpl(
      id: json['id'] as String,
      stoneType: $enumDecode(_$StoneTypeEnumMap, json['stoneType']),
      name: json['name'] as String,
      friendName: json['friendName'] as String,
      friendId: json['friendId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastTouchedByOwner: json['lastTouchedByOwner'] == null
          ? null
          : DateTime.parse(json['lastTouchedByOwner'] as String),
      lastReceivedComfort: json['lastReceivedComfort'] == null
          ? null
          : DateTime.parse(json['lastReceivedComfort'] as String),
      totalTouches: (json['totalTouches'] as num?)?.toInt() ?? 0,
      totalComfortReceived:
          (json['totalComfortReceived'] as num?)?.toInt() ?? 0,
      isReceivingComfort: json['isReceivingComfort'] as bool? ?? false,
      isSendingComfort: json['isSendingComfort'] as bool? ?? false,
      intention: json['intention'] as String?,
      isQuickAccess: json['isQuickAccess'] as bool? ?? false,
      connectionStrength:
          (json['connectionStrength'] as num?)?.toDouble() ?? 0.5,
    );

Map<String, dynamic> _$$ConnectionStoneImplToJson(
        _$ConnectionStoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stoneType': _$StoneTypeEnumMap[instance.stoneType]!,
      'name': instance.name,
      'friendName': instance.friendName,
      'friendId': instance.friendId,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastTouchedByOwner': instance.lastTouchedByOwner?.toIso8601String(),
      'lastReceivedComfort': instance.lastReceivedComfort?.toIso8601String(),
      'totalTouches': instance.totalTouches,
      'totalComfortReceived': instance.totalComfortReceived,
      'isReceivingComfort': instance.isReceivingComfort,
      'isSendingComfort': instance.isSendingComfort,
      'intention': instance.intention,
      'isQuickAccess': instance.isQuickAccess,
      'connectionStrength': instance.connectionStrength,
    };

const _$StoneTypeEnumMap = {
  StoneType.roseQuartz: 'roseQuartz',
  StoneType.clearQuartz: 'clearQuartz',
  StoneType.amethyst: 'amethyst',
  StoneType.oceanWave: 'oceanWave',
  StoneType.cherryBlossom: 'cherryBlossom',
  StoneType.sunstone: 'sunstone',
  StoneType.moonstone: 'moonstone',
  StoneType.lavenderJade: 'lavenderJade',
};
