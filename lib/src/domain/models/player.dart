// ignore: must_be_immutable
import 'package:json_annotation/json_annotation.dart';

//dart run build_runner build --delete-conflicting-outputs

part 'player.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerModel {
  final int id;
  final String name;
  double score = 0.0;
  double buchholz = 0.0;

  PlayerModel(this.id, this.name);

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  int get getId => id;

  String get getName => name;

  void setScore(double value) {
    score += value;
  }

  void setBuchholz(List<PlayerModel> opponents) => buchholz = opponents.isEmpty
      ? 0
      : opponents
          .map((player) => player.score)
          .toList()
          .reduce((a, b) => a + b);
}
