// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Round _$RoundFromJson(Map<String, dynamic> json) => Round(
      id: (json['id'] as num?)?.toInt(),
      number: (json['number'] as num).toInt(),
      games: (json['games'] as List<dynamic>)
          .map((e) => Game.fromJson(e as Map<String, dynamic>))
          .toList(),
      notPaired: json['notPaired'] == null
          ? null
          : Player.fromJson(json['notPaired'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'games': instance.games.map((e) => e.toJson()).toList(),
      'notPaired': instance.notPaired?.toJson(),
    };
