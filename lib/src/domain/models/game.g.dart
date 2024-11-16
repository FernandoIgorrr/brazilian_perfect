// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameFromJson(Map<String, dynamic> json) => GameModel(
      id: (json['id'] as num).toInt(),
      table: (json['table'] as num).toInt(),
      white: PlayerModel.fromJson(json['white'] as Map<String, dynamic>),
      black: PlayerModel.fromJson(json['black'] as Map<String, dynamic>),
      result: $enumDecodeNullable(_$ResultEnumMap, json['result']),
    );

Map<String, dynamic> _$GameToJson(GameModel instance) => <String, dynamic>{
      'id': instance.id,
      'table': instance.table,
      'white': instance.white.toJson(),
      'black': instance.black.toJson(),
      'result': _$ResultEnumMap[instance.result],
    };

const _$ResultEnumMap = {
  Result.white: 'white',
  Result.black: 'black',
  Result.draw: 'draw',
  Result.bothLose: 'bothLose',
};
