// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerFromJson(Map<String, dynamic> json) => PlayerModel(
      (json['id'] as num).toInt(),
      json['name'] as String,
    )
      ..score = (json['score'] as num).toDouble()
      ..buchholz = (json['buchholz'] as num).toDouble();

Map<String, dynamic> _$PlayerToJson(PlayerModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'score': instance.score,
      'buchholz': instance.buchholz,
    };
