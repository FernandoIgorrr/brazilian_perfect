// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentModel _$TournamentFromJson(Map<String, dynamic> json) =>
    TournamentModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      status:
          $enumDecodeNullable(_$StatusEnumMap, json['status']) ?? Status.criado,
      players: (json['players'] as List<dynamic>)
          .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) => RoundModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxNumRounds: (json['maxNumRounds'] as num?)?.toInt(),
      haveBye: json['haveBye'] as bool? ?? false,
    );

Map<String, dynamic> _$TournamentToJson(TournamentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'date': instance.date.toIso8601String(),
      'status': _$StatusEnumMap[instance.status]!,
      'maxNumRounds': instance.maxNumRounds,
      'players': instance.players.map((e) => e.toJson()).toList(),
      'rounds': instance.rounds.map((e) => e.toJson()).toList(),
      'haveBye': instance.haveBye,
    };

const _$StatusEnumMap = {
  Status.criado: 'criado',
  Status.iniciado: 'iniciado',
  Status.acabado: 'acabado',
};
