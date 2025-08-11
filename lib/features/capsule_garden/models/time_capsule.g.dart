// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_capsule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeCapsuleImpl _$$TimeCapsuleImplFromJson(Map<String, dynamic> json) =>
    _$TimeCapsuleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      recipientId: json['recipientId'] as String,
      recipientName: json['recipientName'] as String,
      recipientInitial: json['recipientInitial'] as String,
      plantedAt: DateTime.parse(json['plantedAt'] as String),
      deliveryAt: DateTime.parse(json['deliveryAt'] as String),
      growthStage:
          $enumDecode(_$CapsuleGrowthStageEnumMap, json['growthStage']),
      emoji: json['emoji'] as String,
      type: $enumDecode(_$CapsuleTypeEnumMap, json['type']),
      isReady: json['isReady'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      theme: json['theme'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TimeCapsuleImplToJson(_$TimeCapsuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'recipientId': instance.recipientId,
      'recipientName': instance.recipientName,
      'recipientInitial': instance.recipientInitial,
      'plantedAt': instance.plantedAt.toIso8601String(),
      'deliveryAt': instance.deliveryAt.toIso8601String(),
      'growthStage': _$CapsuleGrowthStageEnumMap[instance.growthStage]!,
      'emoji': instance.emoji,
      'type': _$CapsuleTypeEnumMap[instance.type]!,
      'isReady': instance.isReady,
      'progress': instance.progress,
      'theme': instance.theme,
      'metadata': instance.metadata,
    };

const _$CapsuleGrowthStageEnumMap = {
  CapsuleGrowthStage.seed: 'seed',
  CapsuleGrowthStage.sprout: 'sprout',
  CapsuleGrowthStage.sapling: 'sapling',
  CapsuleGrowthStage.tree: 'tree',
  CapsuleGrowthStage.flowering: 'flowering',
  CapsuleGrowthStage.crystal: 'crystal',
  CapsuleGrowthStage.ready: 'ready',
};

const _$CapsuleTypeEnumMap = {
  CapsuleType.personal: 'personal',
  CapsuleType.birthday: 'birthday',
  CapsuleType.anniversary: 'anniversary',
  CapsuleType.encouragement: 'encouragement',
  CapsuleType.gratitude: 'gratitude',
  CapsuleType.futureSelf: 'future_self',
  CapsuleType.celebration: 'celebration',
};

_$GardenStatsImpl _$$GardenStatsImplFromJson(Map<String, dynamic> json) =>
    _$GardenStatsImpl(
      totalPlanted: (json['totalPlanted'] as num?)?.toInt() ?? 0,
      growing: (json['growing'] as num?)?.toInt() ?? 0,
      ready: (json['ready'] as num?)?.toInt() ?? 0,
      delivered: (json['delivered'] as num?)?.toInt() ?? 0,
      recentlyPlanted: (json['recentlyPlanted'] as num?)?.toInt() ?? 0,
      averageGrowthProgress:
          (json['averageGrowthProgress'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$GardenStatsImplToJson(_$GardenStatsImpl instance) =>
    <String, dynamic>{
      'totalPlanted': instance.totalPlanted,
      'growing': instance.growing,
      'ready': instance.ready,
      'delivered': instance.delivered,
      'recentlyPlanted': instance.recentlyPlanted,
      'averageGrowthProgress': instance.averageGrowthProgress,
    };

_$GardenSectionImpl _$$GardenSectionImplFromJson(Map<String, dynamic> json) =>
    _$GardenSectionImpl(
      title: json['title'] as String,
      emoji: json['emoji'] as String,
      capsules: (json['capsules'] as List<dynamic>)
          .map((e) => TimeCapsule.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecode(_$GardenSectionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$GardenSectionImplToJson(_$GardenSectionImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'emoji': instance.emoji,
      'capsules': instance.capsules,
      'type': _$GardenSectionTypeEnumMap[instance.type]!,
    };

const _$GardenSectionTypeEnumMap = {
  GardenSectionType.ready: 'ready',
  GardenSectionType.growing: 'growing',
  GardenSectionType.recentlyPlanted: 'recently_planted',
};
