import 'package:brazilian_perfect/core/chess_tuple.dart';
import 'package:brazilian_perfect/exceptions/last_round_missing_results.dart';
import 'package:brazilian_perfect/exceptions/player_not_found_excpetion.dart';
import 'package:brazilian_perfect/exceptions/tournament_max_rounds_exception.dart';
import 'package:brazilian_perfect/model/dto/tournament_creation_dto.dart';
import 'package:brazilian_perfect/model/game.dart';
import 'package:brazilian_perfect/model/player.dart';
import 'package:brazilian_perfect/model/round.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tournament.g.dart';

// ignore: must_be_immutable
@JsonSerializable(explicitToJson: true)
class Tournament {
  int? id;
  String name;
  String type;
  DateTime date;
  Status status;
  int? maxNumRounds;
  List<Player> players = <Player>[];
  List<Round> rounds = <Round>[];
  bool haveBye = false;

  Tournament({
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

  static Tournament toTourmament(TournamentCreationDto tournamentdto) {
    return Tournament(
        name: tournamentdto.name,
        type: tournamentdto.type,
        date: tournamentdto.date,
        maxNumRounds: 0,
        players: <Player>[],
        rounds: <Round>[]);
  }

  setId(int value) {
    id = value;
  }

  setName(String value) {
    name = value;
  }

  setDate(DateTime value) {
    date = value;
  }

  setType(String value) {
    type = value;
  }

  void addParticipant(Player player) {
    players.add(player);
  }

  void addParticipants(List<Player> players) {
    this.players.addAll(players);
  }

  List<Player> get getPlayers => players;

  Player getPlayer(int id) {
    if (id < 0 || id >= players.length) {
      throw PlayerNotFoundException('Player com id $id não foi encontrado.');
    }
    return players[id];
  }

  bool get minFilledDatas => name.isNotEmpty && type.isNotEmpty;

  int get numberOfPlayers => players.length;

  bool get canAddMorePlayers => status == Status.criado;

  bool get canItBeStarted => (numberOfPlayers > 2);

  /// Método que mapeia o ID do jogador existente para o próprio objeto
  Map<int, Player> _mapCompetitorsById() {
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

    Round round =
        Round(id: rounds.length, number: rounds.length + 1, games: <Game>[]);

    final pairedPlayers = <Player>{};

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

          round.games.add(Game(
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
    rounds.add(round);
  }

  bool get areLastRoundResultsFilled => rounds.last.games
      .map((game) => game.result != null ? true : false)
      .reduce((a, b) => a && b);

  ChessTuple<Player> chooseWhoIsBlackOrWhite(Player player1, Player player2) {
    Player white, black;
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

  ChessTuple<int> countOfHowManyTimesThisPlayPlayedWhiteAndBlack(
      Player player) {
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

    Player futureByePlayer =
        aux.firstWhere((player) => !getByePlayers().contains(player));

    players.remove(futureByePlayer);
    players.add(futureByePlayer);
  }

  // Esse método eu criei para fazer uma lista de todos os players que o dado
  // player jogou contra
  List<Game> getGamesPlayedByPlayer(Player player) {
    var games = rounds
        .expand((round) => round.games)
        .where((game) => game.isOnThisGame(player))
        .toList();
    return games;
  }

  List<Player?> getByePlayers() {
    return rounds.map((round) => round.notPaired).toList();
  }

  List<Player> getPlayersPlayedAgainst(Player player) {
    /* Aqui vemos a mestria das streams. oque foi feito aqui?
      primeiro usei o metodo expand() para fazer uma lista só
      de todos os games ou 'matches' do torneio até então
      juntei tudo em lista que antes eram seperados por round,
      logo apos, utilizei o toList() para passar de Iterable<Game>
      para um  *(1)List<Game>, logo usei um map() para usar a função getOpponent()
      em todos os games da lista *(1) e me retornar os oponentes de player que
      é o argumento deste método. Isso me gera um Iterable<Player> só que função
      getOpponent() retorna null quando o jogador 'player' não está no Game,
      então nesta ultimo Iterable tenho vários campos vazios, por isso, utilizo
      where() para filtrar os valores não nulos ai teremos um Iterable<Player> só
      com os oponentes do player em questão. O  último map foi só para fazer um
      cast visto q função retorna getOpponent() retorna uma Player? (retorna um
      player ou não (vulgo nulo)), porém tudo ja foi filtrado e temos só objetos
      do tipo Player (ou uma iterable vazio). Após o cast apenas passei para lista
      com o último método toList() retornando assim todos os adversário jogados
      contra o dado player no torneio!
    */
    // var opponents = rounds
    //     .expand((round) => round.games)
    //     .map((game) => game.getOpponent(player))
    //     .where((player) => player != null)
    //     .map((player) => player!)
    //     .toList();

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

  bool alreadyPlayed(Player a, Player b) {
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

  factory Tournament.fromJson(Map<String, dynamic> json) {
    Tournament tournament = _$TournamentFromJson(json);

    // Após desserializar, resolvemos as referências de jogadores.
    tournament.resolvePlayerReferences();

    return tournament;
  }

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TournamentToJson(this);
}

enum Status { criado, iniciado, acabado }
