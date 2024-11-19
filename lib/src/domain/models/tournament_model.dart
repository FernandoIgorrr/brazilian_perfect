import 'package:brazilian_perfect/src/core/chess_tuple.dart';
import 'package:brazilian_perfect/src/exceptions/last_round_missing_results.dart';
import 'package:brazilian_perfect/src/exceptions/player_not_found_excpetion.dart';
import 'package:brazilian_perfect/src/exceptions/tournament_max_rounds_exception.dart';
import 'package:brazilian_perfect/src/domain/models/dto/tournament_creation_dto.dart';
import 'package:brazilian_perfect/src/domain/models/game.dart';
import 'package:brazilian_perfect/src/domain/models/player.dart';
import 'package:brazilian_perfect/src/domain/models/round.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tournament.g.dart';

// ignore: must_be_immutable
@JsonSerializable(explicitToJson: true)
class TournamentModel extends Equatable {
  int? id;
  String name;
  String type;
  DateTime date;
  Status status;
  int? maxNumRounds;
  List<PlayerModel> players = <PlayerModel>[];
  List<RoundModel> rounds = <RoundModel>[];
  bool haveBye = false;

  TournamentModel({
    this.id,
    required this.name,
    required this.type,
    required this.date,
    this.status = Status.criado,
    required this.players,
    required this.rounds,
    this.maxNumRounds,
    this.haveBye = false,
  });

  factory TournamentModel.init() {
    return TournamentModel(
        name: '', type: '', date: DateTime.now(), players: [], rounds: []);
  }

  static TournamentModel toTourmament(TournamentCreationDto tournamentdto) {
    return TournamentModel(
        name: tournamentdto.name,
        type: tournamentdto.type,
        date: tournamentdto.date,
        maxNumRounds: 0,
        players: <PlayerModel>[],
        rounds: <RoundModel>[]);
  }

  set setId(int value) => id = value;

  set setName(String value) => name = value;

  set setDate(DateTime value) => date = value;

  set setType(String value) => type = value;

  set setMaxNumRounds(int value) => maxNumRounds = value;

  void addParticipant(PlayerModel player) {
    players.add(player);
  }

  void addParticipants(List<PlayerModel> players) {
    this.players.addAll(players);
  }

  List<PlayerModel> get getPlayers => players;

  PlayerModel getPlayer(int id) {
    if (id < 0 || id >= players.length) {
      throw PlayerNotFoundException('Player com id $id não foi encontrado.');
    }
    return players[id];
  }

  bool get minFilledDatas => name.isNotEmpty && type.isNotEmpty;

  int get getNumberOfPlayers => players.length;

  bool get canAddMorePlayers => status == Status.criado;

  bool get canItBeStarted => (getNumberOfPlayers > 2);

  /// Método que mapeia o ID do jogador existente para o próprio objeto
  Map<int, PlayerModel> _mapCompetitorsById() {
    return {for (var player in players) player.getId: player};
  }

  void initiateTournament() {
    if (players.length.isOdd) {
      //players.add(Player(players.length, ''));
      haveBye = true;
    }
    createSwissPairings();
    status = Status.iniciado;
  }

  void distributeScore() {
    for (var player in players) {
      player.score = getGamesPlayedByPlayer(player).isEmpty
          ? 0.0
          : getGamesPlayedByPlayer(player)
              .map((game) => game.distributeScore(player))
              .reduce((a, b) => a + b);
      if (getByePlayers().contains(player)) {
        player.score += 1.0;
      }
    }
  }

  void createSwissPairings() {
    if (rounds.isNotEmpty && (rounds.last.number == (maxNumRounds!))) {
      status = Status.acabado;
      throw TournamentMaxRoundsException('Máximo de rodadas chegou no limite');
    }

    if (rounds.isNotEmpty && !areLastRoundResultsFilled) {
      throw LastRoundMissingResults(
          'Todos os resultados da última rodada ainda não foram preenchidos completamente!');
    }

    if (rounds.isNotEmpty) {
      updateBuchholzScores();
    }

    sortPlayersByScoreAndBuchholz();

    RoundModel round = RoundModel(
        id: rounds.length, number: rounds.length + 1, games: <GameModel>[]);

    final pairedPlayers = <PlayerModel>{};
    //List<GameModel> gamesAux = <GameModel>[];

    if (rounds.isEmpty) {
      players.shuffle();
    }

    if (haveBye) {
      if (rounds.isNotEmpty) {
        sortNextByePlayer();
        pairedPlayers.add(players.last);
      }
      round.notPaired = players.last;
    }
    for (int i = 0; i < players.length - 1; i++) {
      final player1 = players[i];

      if (pairedPlayers.contains(player1)) continue;

      for (int j = i + 1; j < players.length; j++) {
        final player2 = players[j];
        if (pairedPlayers.contains(player2)) continue;

        // Evita repetição de adversários
        if (!alreadyPlayed(player1, player2)) {
          ChessTuple chessTuple = chooseWhoIsBlackOrWhite(player1, player2);

          round.games.add(GameModel(
            id: round.games.length,
            table: round.games.length + 1,
            white: chessTuple.white,
            black: chessTuple.black,
          ));

          pairedPlayers.add(player1);
          pairedPlayers.add(player2);
          break;
        }
      }
    }
    if (pairedPlayers.length != players.length) {
      round = bestShufflePairing();
    }

    rounds.add(round);
  }

  RoundModel bestShufflePairing() {
    final pairedPlayers = <PlayerModel>{};
    final List<Map<String, dynamic>> scoreRounds = <Map<String, dynamic>>[];

    RoundModel round = RoundModel(
        id: rounds.length, number: rounds.length + 1, games: <GameModel>[]);
    bool notPaired;
    int count = 0;
    while (count < 100) {
      notPaired = true;
      while (notPaired) {
        for (int i = 0; i < players.length - 1; i++) {
          final player1 = players[i];

          if (pairedPlayers.contains(player1)) continue;

          for (int j = i + 1; j < players.length; j++) {
            final player2 = players[j];
            if (pairedPlayers.contains(player2)) continue;

            // Evita repetição de adversários
            if (!alreadyPlayed(player1, player2)) {
              ChessTuple chessTuple = chooseWhoIsBlackOrWhite(player1, player2);

              round.games.add(GameModel(
                id: round.games.length,
                table: round.getGames.length + 1,
                white: chessTuple.white,
                black: chessTuple.black,
              ));

              pairedPlayers.add(player1);
              pairedPlayers.add(player2);
              break;
            }
          }
        }
        if (pairedPlayers.length != players.length) {
          pairedPlayers.clear();
          round.games.clear();
          if (haveBye) {
            sortNextByePlayer();
            pairedPlayers.add(players.last);
            round.notPaired = players.last;
          }
          players.shuffle();
        } else {
          notPaired = false;
          round.games.sort((a, b) {
            if (a.whoHasTheMostScore.score != b.whoHasTheMostScore.score) {
              return b.whoHasTheMostScore.score.compareTo(a
                  .whoHasTheMostScore.score); // Ordem decrescente por pontuação
            }
            return b.whoHasTheMostScore.score.compareTo(
                a.whoHasTheMostScore.score); // Desempate por Buchholz
          });
          for (int i = 0; i < round.getGames.length; i++) {
            round.games[i].table = 1 + i;
          }
          scoreRounds.add({
            'score': calculateErro(round.getGames),
            'round': round.copyWith()
          });
          count++;
        }
      }
    }
    scoreRounds.sort((a, b) => a['score'].compareTo(b['score']));
    return scoreRounds.first['round'];
  }

  bool get areLastRoundResultsFilled => rounds.last.games
      .map((game) => game.result != null ? true : false)
      .reduce((a, b) => a && b);

  ChessTuple<PlayerModel> chooseWhoIsBlackOrWhite(
      PlayerModel player1, PlayerModel player2) {
    PlayerModel white, black;
    int w1, b1, w2, b2;
    w1 = countOfHowManyTimesThisPlayPlayedWhiteAndBlack(player1).white;
    b1 = countOfHowManyTimesThisPlayPlayedWhiteAndBlack(player1).black;

    w2 = countOfHowManyTimesThisPlayPlayedWhiteAndBlack(player2).white;
    b2 = countOfHowManyTimesThisPlayPlayedWhiteAndBlack(player2).black;

    if ((w1 > b1) && (w2 <= b2)) {
      white = player2;
      black = player1;
    } else if (w2 > b2 && b1 <= w1) {
      white = player1;
      black = player2;
    } else {
      // Se ambos têm um balanço similar, alterna as cores arbitrariamente
      white = player1;
      black = player2;
    }

    return ChessTuple(white, black);
  }

  double calculateErro(List<GameModel> games) {
    return games
        .map((game) => (game.white.score - game.black.score).abs())
        .reduce((a, b) => a + b);
  }

  ChessTuple<int> countOfHowManyTimesThisPlayPlayedWhiteAndBlack(
      PlayerModel player) {
    var games = getGamesPlayedByPlayer(player);
    var list = games
        .map((game) => game.isWhite(player))
        .map((element) => element ? 1 : 0);
    int num;

    if (list.isNotEmpty) {
      num = list.reduce((a, b) => a + b);
    } else {
      num = 0;
    }
    return ChessTuple(num, games.length - num);
  }

  void sortPlayersByScoreAndBuchholz() {
    players.sort((a, b) {
      if (a.score != b.score) {
        return b.score.compareTo(a.score); // Ordem decrescente por pontuação
      }
      return b.buchholz.compareTo(a.buchholz); // Desempate por Buchholz
    });
  }

  void sortNextByePlayer() {
    var aux = [...players].reversed.toList();

    PlayerModel futureByePlayer =
        aux.firstWhere((player) => !getByePlayers().contains(player));

    players.remove(futureByePlayer);
    players.add(futureByePlayer);
  }

  /*
    Aqui temos a função que retorna todos os jogos que o player jogou no torneio
    até o momento. Aqui eu simplemente pego todos o rounds da variável rounds e 
    então aplico o método expand que onde ele irá juntar em um lista só todos os
    games ou 'matches' de todos ou rounds. uma vez feito isso, temos todos os
    games em uma lista, então eu aplico o método where onde eu retorno apenas os
    games onde o dado player está usando a função isOnThisGame que retorna true
    caso o player esteja no game e false caso contrário. No final só uso o toList()
    para passar para de Iterable<Game> para List<Game>.
  */
  List<GameModel> getGamesPlayedByPlayer(PlayerModel player) {
    var games = rounds
        .expand((round) => round.games)
        .where((game) => game.isOnThisGame(player))
        .toList();
    return games;
  }

  List<PlayerModel?> getByePlayers() {
    return rounds.map((round) => round.notPaired).toList();
  }

  /* Aqui vemos a mestria das streams. oque foi feito aqui? primeiro usei o 
    metodo getGamesPlayedByPlayer(player) para pegar a lista de todos os games 
    ou 'matches' que o dado player jogou, logo apos, utilizei um map() para usar 
    a função getOpponent() como função do map para me retornar os oponentes do 
    dado player (que é o argumento deste método). último map foi só para fazer 
    um cast visto q função getOpponent() retorna um Player? (retorna um player 
    ou não (vulgo nulo)), porém como temos estamos analizando a lista de jogos 
    do que o player jogou, é impossivel termos como resposta um oponente venha. Após 
    o cast apenas passei para lista com o último método toList() retornando assim
    todos os adversário jogados contra o dado player no torneio!
    */
  List<PlayerModel> getPlayersPlayedAgainst(PlayerModel player) {
    var opponents = getGamesPlayedByPlayer(player)
        .map((game) => game.getOpponent(player))
        .map((player) => player!)
        .toList();
    return opponents;
  }

  void updateBuchholzScores() {
    for (var player in players) {
      player.setBuchholz(getPlayersPlayedAgainst(player));
    }
  }

  bool alreadyPlayed(PlayerModel a, PlayerModel b) {
    return getPlayersPlayedAgainst(a).contains(b);
  }

  void resolvePlayerReferences() {
    final playerById = _mapCompetitorsById();

    for (var round in rounds) {
      if (haveBye) {
        round.notPaired = playerById[round.notPaired!.id] ?? round.notPaired;
      }
      for (var game in round.games) {
        game.white = playerById[game.white.getId] ?? game.white;
        game.black = playerById[game.black.getId] ?? game.black;
      }
    }
  }

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    TournamentModel tournament = _$TournamentFromJson(json);

    // Após desserializar, resolvemos as referências de jogadores.
    tournament.resolvePlayerReferences();

    return tournament;
  }

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TournamentToJson(this);

  @override
  List<Object?> get props => [
        id,
      ];
}

enum Status { criado, iniciado, acabado }
