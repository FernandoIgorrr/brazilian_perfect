import 'dart:math';

import 'package:brazilian_perfect/src/core/app_export.dart';
import 'package:brazilian_perfect/src/domain/models/game.dart';
import 'package:brazilian_perfect/src/domain/models/player.dart';
import 'package:brazilian_perfect/src/domain/models/round.dart';
import 'package:brazilian_perfect/src/domain/models/tournament_model.dart';
import 'package:brazilian_perfect/src/domain/models/tournament_manager.dart';
import 'package:brazilian_perfect/src/ui/presentation/classification_screen.dart/classification_screen.dart';
import 'package:brazilian_perfect/src/ui/theme/custom_button_style.dart';
import 'package:brazilian_perfect/src/ui/widgets/custom_app_bar.dart';
import 'package:brazilian_perfect/src/ui/widgets/custom_elevated_button.dart';
import 'package:brazilian_perfect/src/ui/widgets/custom_elevated_button_create_tournament.dart';
import 'package:brazilian_perfect/src/ui/widgets/custom_text_form_field.dart';
import 'package:brazilian_perfect/src/ui/widgets/increment_decrement_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// ignore: must_be_immutable
class TournamentScreen extends StatefulWidget {
  TournamentScreen({super.key, required this.tournament});

  TournamentModel tournament;

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  TournamentManager tournamentManager = TournamentManager.instance;

  String namePlayerController = '';
  int maxNumRoundsController = 0;
  late TournamentModel tournament;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    tournament = widget.tournament;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: tournament.name),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                title: Align(
                  alignment: const Alignment(0.2, 0),
                  child: Text('Jogadores (${tournament.players.length})'),
                ),
                // collapsedBackgroundColor: ,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 476.h, // Altura máxima permitida
                    ),
                    child: tournament.players.isEmpty
                        ? Text(
                            'Nenhum jogador inscrito',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: tournament.players.length,
                            itemBuilder: (BuildContext context, int index) {
                              tournament.players.sort((a, b) {
                                return a.name.compareTo(b.name);
                              });
                              PlayerModel player = tournament.players[index];
                              if (player.name.isEmpty) {
                                return SizedBox(
                                  height: 0.h,
                                );
                              } else {
                                return Text(player.getName);
                              }
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 0),
                          ),
                  ),
                  SizedBox(
                    child: tournament.canAddMorePlayers
                        ? CustomElevatedButton(
                            text: 'Adcionar jogador',
                            onPressed: tournament.canAddMorePlayers
                                ? () async {
                                    await _buildShowDialogName(context);
                                    setState(() {});
                                  }
                                : null,
                            buttonStyle: CustomButtonStyle
                                .fillOnPrimaryContainerRectangularBorder,
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Align(
                  alignment: Alignment(0.2, 0),
                  child: Text('Rodadas'),
                ),
                // collapsedBackgroundColor: ,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 476.h, // Altura máxima permitida
                    ),
                    child: tournament.rounds.isEmpty
                        ? Text(
                            'O torneio ainda não começou',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: tournament.rounds.length,
                            itemBuilder: (BuildContext context, int index) {
                              RoundModel round = tournament.rounds[index];
                              return ExpansionTile(
                                title: Align(
                                  alignment: const Alignment(0.2, 0),
                                  child: Text('RODADA ${round.number}'),
                                ),
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount:
                                        tournament.rounds[index].games.length,
                                    itemBuilder:
                                        (BuildContext context, int jindex) {
                                      GameModel game = tournament
                                          .rounds[index].games[jindex];

                                      Color tileColor =
                                          _selectedIndex == index + 10 * jindex
                                              ? appTheme.orange900
                                              : (jindex % 2 == 0
                                                  ? appTheme.gray500
                                                  : appTheme.blueGray7003f);
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex =
                                                index + 10 * jindex;
                                          });
                                        },
                                        child: Container(
                                          height: 80.h,
                                          color: tileColor,
                                          child: tournament.rounds[index] ==
                                                  tournament.rounds.last
                                              ? _buildGamesOfCurrentlyRound(
                                                  game, index, jindex, false)
                                              : _buildGames(game),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(height: 0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = round.games.length + 1;
                                      });
                                    },
                                    child: Container(
                                        color:
                                            _selectedIndex == index + 10 * (round.games.length + 1)
                                                ? appTheme.orange900
                                                : (round.games.length + 1 % 2 == 0
                                                    ? appTheme.gray500
                                                    : appTheme.blueGray7003f),
                                        child: !tournament.haveBye
                                            ? const SizedBox()
                                            : (tournament.rounds[index] ==
                                                    tournament.rounds.last
                                                ? _buildGamesOfCurrentlyRound(
                                                    GameModel(
                                                        result: Result.white,
                                                        id: round.games.length,
                                                        table:
                                                            round.games.length +
                                                                1,
                                                        white: round.notPaired!,
                                                        black: PlayerModel(
                                                            99, 'BYE')),
                                                    index,
                                                    round.games.length + 1,
                                                    true)
                                                : _buildGames(GameModel(
                                                    result: Result.white,
                                                    id: round.games.length,
                                                    table: round.games.length + 1,
                                                    white: round.notPaired!,
                                                    black: PlayerModel(99, 'BYE'))))),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 0),
                          ),
                  ),
                  CustomElevatedButton(
                    text: 'Classificação',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ClassificationScreen(
                                  tournament: tournament)));
                    },
                  ),
                  SizedBox(
                    height: 300.h,
                  )
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: tournament.rounds.isEmpty
            ? _buildInitiateTournament(context)
            : tournament.rounds.length == tournament.maxNumRounds
                ? _buildClassification(context)
                : _buildPairing(context),
      ),
    );
  }

  _buildClassification(BuildContext context) {
    return CustomElevatedButton(
      text: 'CLASSIFICAÇÃO',
      width: double.maxFinite,
      buttonStyle: CustomButtonStyle.fillOnPrimaryContainerRectangularBorder,
      //context: context,
      onPressed: tournament.areLastRoundResultsFilled
          ? () async {
              if (tournament.areLastRoundResultsFilled) {
                tournament.distributeScore();
                tournament.updateBuchholzScores();
                tournament.status = Status.acabado;
                //tournament.createSwissPairings();
                tournamentManager.saveTournamentsOnLocalStorage();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ClassificationScreen(tournament: tournament)));
                setState(() {});
              }
            }
          : null,
    );
  }

  _buildPairing(BuildContext context) {
    return CustomElevatedButton(
      text: 'EMPARCEIRAR PRÓXIMA RODADA',
      width: double.maxFinite,
      buttonStyle: CustomButtonStyle.fillOnPrimaryContainerRectangularBorder,
      //context: context,
      onPressed: tournament.areLastRoundResultsFilled
          ? () async {
              if (tournament.areLastRoundResultsFilled) {
                tournament.distributeScore();
                tournament.createSwissPairings();
                tournamentManager.saveTournamentsOnLocalStorage();
                setState(() {});
              } else {}
            }
          : null,
    );
  }

  _buildGamesOfCurrentlyRound(
      GameModel game, int index, int jindex, bool isBye) {
    return ListTile(
      title: _buildGames(game),
      onTap: () {
        setState(() {
          _selectedIndex = index + 10 * jindex; // Atualiza o índice selecionado
        });
      },
      onLongPress: () async {
        setState(() {
          _selectedIndex = index + 10 * jindex; // Atualiza o índice selecionado
        });
        isBye ? {} : await _buildShowDialogResult(context, game);
        setState(() {});
      },
    );
  }

  _buildGames(
    GameModel game,
  ) {
    String res;
    if (game.result == null) {
      res = 'X';
    } else if (game.result == Result.white) {
      res = '1   :   0';
    } else if (game.result == Result.draw) {
      res = '0.5  :  0.5';
    } else if (game.result == Result.black) {
      res = '0   :   1';
    } else {
      res = '0   :   0';
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Text(
          '${game.table}.  ${game.white.name} (${game.white.score})',
          textAlign: TextAlign.left,
        ),
      ),
      Expanded(
          child: Text(
        res,
        textAlign: TextAlign.center,
      )),
      Expanded(
          child: game.black.id == 99 && game.black.name == 'BYE'
              ? Text(
                  game.black.name,
                  textAlign: TextAlign.right,
                )
              : Text(
                  '(${game.black.score})  ${game.black.name}',
                  textAlign: TextAlign.right,
                )),
    ]);
  }

  _buildInitiateTournament(BuildContext context) {
    return CustomElevatedButtonCreateTournament(
      text: 'INICIAR TORNEIO',
      width: double.maxFinite,
      context: context,
      onPressed: tournament.canItBeStarted
          ? () async {
              if (tournament.type == 'round robin') {
              } else {
                await _buildShowDialogRoundsNum(context);
                setState(() {});
              }
            }
          : null,
    );
  }

  _buildShowDialogResult(BuildContext context, GameModel game) async {
    return showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: appTheme.purple900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
            title: Text(
              'RESULTADO',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            actions: [
              _buildCustomElevatadeButtonResult(context, game, Result.white),
              _buildCustomElevatadeButtonResult(context, game, Result.draw),
              _buildCustomElevatadeButtonResult(context, game, Result.bothLose),
              _buildCustomElevatadeButtonResult(context, game, Result.black),
            ],
          );
        },
        context: context);
  }

  _buildCustomElevatadeButtonResult(
      BuildContext context, GameModel game, result) {
    var width = 48.h;
    String res;
    if (result == Result.white) {
      res = '1 : 0';
    } else if (result == Result.draw) {
      res = '0.5 : 0.5';
    } else if (result == Result.black) {
      res = '0 : 1';
    } else {
      res = '0 : 0';
    }
    return CustomElevatedButton(
      text: res,
      buttonStyle: CustomButtonStyle.fillOnPrimaryContainer,
      buttonTextStyle: Theme.of(context).textTheme.headlineMedium,
      width: result == Result.draw ? width + 24.h : width,
      onPressed: () {
        game.fillResult(result);
        tournamentManager.saveTournamentsOnLocalStorage();
        Navigator.of(context).pop();
      },
    );
  }

  _buildShowDialogName(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            backgroundColor: appTheme.purple900,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.h), // Defina o raio desejado aqui
            ),
            title: Text(
              'Adicionar jogador',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            content: CustomTextFormField(
              hintText: 'Nome do jogador',
              onChange: (value) {
                setState(() {
                  namePlayerController = value;
                });
              },
            ),
            actions: [
              Observer(builder: (_) {
                return CustomElevatedButton(
                  text: 'Adicionar',
                  buttonStyle: CustomButtonStyle.fillOnPrimaryContainer,
                  onPressed: _filledName
                      ? () {
                          tournament.players.add(PlayerModel(
                              tournament.players.length, namePlayerController));
                          tournamentManager.saveTournamentsOnLocalStorage();

                          Navigator.of(context).pop();
                        }
                      : null,
                );
              })
            ],
          );
        });
      },
    );
  }

  _buildShowDialogRoundsNum(BuildContext context) async {
    int minValue = (sqrt(tournament.numberOfPlayers) + 1).round();
    int maxValue = tournament.players.length - 1;
    maxNumRoundsController = minValue;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.purple900,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.h), // Defina o raio desejado aqui
          ),
          title: Text(
            'Número de rodadas',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          content: IncrementDecrementField(
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int value) {
              maxNumRoundsController = value;
            },
          ),
          actions: [
            Observer(builder: (_) {
              return CustomElevatedButton(
                  text: 'INICIAR',
                  buttonStyle: CustomButtonStyle.fillOnPrimaryContainer,
                  onPressed: () {
                    tournament.maxNumRounds = maxNumRoundsController;
                    try {
                      tournament.initiateTournament();
                      tournamentManager.saveTournamentsOnLocalStorage();
                    } catch (e) {
                      _buildSnackBarError(context, e.toString());
                    }
                    Navigator.of(context).pop();
                  });
            })
          ],
        );
      },
    );
  }

  _buildSnackBarError(BuildContext context, String err) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            err,
            textAlign: TextAlign.center,
          )));
    }
  }

  bool get _filledName => namePlayerController.isNotEmpty;
}
