import 'package:brazilian_perfect/src/domain/models/game.dart';
import 'package:brazilian_perfect/src/domain/models/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'round.g.dart';

@JsonSerializable(explicitToJson: true)
class RoundModel {
  int? id;
  int number;
  List<GameModel> games = <GameModel>[];
  PlayerModel? notPaired;

  RoundModel(
      {this.id, required this.number, required this.games, this.notPaired});

  factory RoundModel.fromJson(Map<String, dynamic> json) =>
      _$RoundFromJson(json);
  Map<String, dynamic> toJson() => _$RoundToJson(this);
}
