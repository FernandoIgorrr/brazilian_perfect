import 'package:brazilian_perfect/model/game.dart';
import 'package:brazilian_perfect/model/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'round.g.dart';

@JsonSerializable(explicitToJson: true)
class Round {
  int? id;
  int number;
  List<Game> games = <Game>[];
  Player? notPaired;

  Round({this.id, required this.number, required this.games, this.notPaired});

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);
  Map<String, dynamic> toJson() => _$RoundToJson(this);
}
