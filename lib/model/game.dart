// ignore: must_be_immutable
import 'package:brazilian_perfect/model/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable(explicitToJson: true)
class Game {
  int id;
  int table;
  Player white;
  Player black;
  Result? result;

  Game(
      {required this.id,
      required this.table,
      required this.white,
      required this.black,
      this.result});

  void fillResult(Result value) => result = value;

  bool isWhite(Player player) => player == white;
  bool isBlack(Player player) => player == black;

  double distributeScore(Player player) {
    if (player == white && result == Result.white) {
      return 1.0;
    } else if (player == black && result == Result.black) {
      return 1.0;
    } else if ((player == white || player == black) && result == Result.draw) {
      return 0.5;
    }
    return 0.0;
  }

  bool isOnThisGame(Player player) {
    return player == white || player == black;
  }

  Player? getOpponent(Player player) {
    if (player == white) {
      return black;
    } else if (player == black) {
      return white;
    }
    return null;
  }

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}

enum Result { white, black, draw, bothLose }
