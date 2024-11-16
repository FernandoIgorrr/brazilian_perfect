import 'package:brazilian_perfect/src/domain/models/tournament_model.dart';

class TournamentState {
  final List<TournamentModel> tournaments;
  final TournamentModel tournament;

  TournamentState({required this.tournaments, required this.tournament});

  factory TournamentState.init() {
    return TournamentState(
        tournaments: const [], tournament: TournamentModel.init());
  }

  TournamentState copyWith(
      {List<TournamentModel>? tournaments, TournamentModel? tournament}) {
    return TournamentState(
        tournaments: tournaments ?? this.tournaments,
        tournament: tournament ?? this.tournament);
  }
}
