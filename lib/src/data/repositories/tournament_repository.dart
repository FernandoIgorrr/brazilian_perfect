import 'dart:convert';

import 'package:brazilian_perfect/src/core/utils/local_storage_constants.dart';
import 'package:brazilian_perfect/src/domain/models/tournament_model.dart';
import 'package:localstorage/localstorage.dart';

class TournamentRepository {
  List<TournamentModel> getTournaments() {
    // Recupera a string JSON do localStorage
    String? jsonString =
        localStorage.getItem(LocalStorageConstants.tournamentsKey);

    return parseTournaments(jsonString);
  }

  List<TournamentModel> parseTournaments(String? jsonString) {
    if (jsonString != null) {
      // Decodifica a string JSON para uma lista de mapas
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Converte cada mapa para uma instância de Tournament e suas classes aninhadas
      return jsonList.map((json) => TournamentModel.fromJson(json)).toList();
    }
    return [];
  }
}
