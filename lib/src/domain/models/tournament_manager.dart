import 'dart:convert';

import 'package:brazilian_perfect/src/domain/models/tournament_model.dart';
import 'package:localstorage/localstorage.dart';

//dart run build_runner build

class TournamentManager {
  static TournamentManager? _instance;

  late List<TournamentModel> tournaments;

  TournamentManager._() {
    tournaments = loadTournamentsOfLocalStorage;
  }

  static TournamentManager get instance {
    return _instance ??= TournamentManager._();
  }

  String _listOfTournamentsToJsonString() {
    // Converte cada Tournament da lista para JSON
    List<Map<String, dynamic>> jsonList =
        tournaments.map((tournament) => tournament.toJson()).toList();

    // Converte a lista JSON para uma string
    return jsonEncode(jsonList);
  }

  void saveTournamentsOnLocalStorage() {
    localStorage.setItem('tournaments', _listOfTournamentsToJsonString());
  }

  List<TournamentModel> get loadTournamentsOfLocalStorage {
    // Recupera a string JSON do localStorage
    String? jsonString = localStorage.getItem('tournaments');

    if (jsonString != null) {
      // Decodifica a string JSON para uma lista de mapas
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Converte cada mapa para uma instância de Tournament
      return jsonList.map((json) => TournamentModel.fromJson(json)).toList();
    }
    return []; // Retorna uma lista vazia se não houver dados no localStorage
  }

  void createTournament(TournamentModel tournament) {
    tournament.setId = tournaments.length;
    tournaments.add(tournament);
  }
}
