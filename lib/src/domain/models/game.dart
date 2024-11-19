// ignore: must_be_immutable
import 'package:brazilian_perfect/src/domain/models/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable(explicitToJson: true)
class GameModel {
  int id;
  int table;
  PlayerModel white;
  PlayerModel black;
  Result? result;

  GameModel(
      {required this.id,
      required this.table,
      required this.white,
      required this.black,
      this.result});

  void fillResult(Result value) => result = value;

  bool isWhite(PlayerModel player) => player == white;
  bool isBlack(PlayerModel player) => player == black;

  double distributeScore(PlayerModel player) {
    if (player == white && result == Result.white) {
      return 1.0;
    } else if (player == black && result == Result.black) {
      return 1.0;
    } else if ((player == white || player == black) && result == Result.draw) {
      return 0.5;
    }
    return 0.0;
  }

  bool isOnThisGame(PlayerModel player) {
    return player == white || player == black;
  }

  PlayerModel? getOpponent(PlayerModel player) {
    if (player == white) {
      return black;
    } else if (player == black) {
      return white;
    }
    return null;
  }

  PlayerModel get whoHasTheMostScore => (white.score != black.score)
      ? (white.score > black.score)
          ? white
          : black
      : (white.buchholz >= black.buchholz)
          ? white
          : black;

  bool equals(GameModel game) {
    return (white == game.white || white == game.black) &&
        (black == game.white || black == game.black);
  }

  factory GameModel.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);
}

enum Result { white, black, draw, bothLose }
