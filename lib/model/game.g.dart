// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      id: (json['id'] as num).toInt(),
      table: (json['table'] as num).toInt(),
      white: Player.fromJson(json['white'] as Map<String, dynamic>),
      black: Player.fromJson(json['black'] as Map<String, dynamic>),
      result: $enumDecodeNullable(_$ResultEnumMap, json['result']),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
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
