import 'package:brazilian_perfect/src/core/store/store_notify.dart';
import 'package:brazilian_perfect/src/data/repositories/tournament_repository.dart';
import 'package:brazilian_perfect/src/domain/models/tournament_model.dart';

class TournamentController extends StoreNotify<List<TournamentModel>> {
  TournamentController() : super([]);

  void fetch() {
    final _state = TournamentRepository().getTournaments();

    dispatch(_state);
  }

  Future<void> getTournaments() async {}

  Future<void> selectTournament(TournamentModel model) async {
    // value = value.copyWith(tournament: model);
  }
}
