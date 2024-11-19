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

  int get getId => id!;
  int get getNumber => number;
  List<GameModel> get getGames => games;
  PlayerModel? get getNotPaired => notPaired;

  set setId(int id) => id = id;
  set setNumber(int number) => number = number;
  set setGames(List<GameModel> games) => games = games;
  set setNotPaired(PlayerModel? notPaired) => notPaired = notPaired;

  RoundModel(
      {this.id, required this.number, required this.games, this.notPaired});

  factory RoundModel.fromJson(Map<String, dynamic> json) =>
      _$RoundFromJson(json);
  Map<String, dynamic> toJson() => _$RoundToJson(this);

  RoundModel copyWith(
          {int? id,
          int? number,
          List<GameModel>? games,
          PlayerModel? notPaired}) =>
      RoundModel(
          id: id ?? this.id,
          number: number ?? this.number,
          games: games ?? this.games,
          notPaired: notPaired ?? this.notPaired);
}
