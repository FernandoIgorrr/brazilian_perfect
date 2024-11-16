import 'package:brazilian_perfect/src/domain/models/tournament_model.dart';
import 'package:brazilian_perfect/src/domain/models/tournament_manager.dart';
import 'package:brazilian_perfect/src/ui/presentation/create_tournament_screen/create_tournament_screen.dart';
import 'package:brazilian_perfect/src/ui/presentation/tournament_screen/tournament_screen.dart';
import 'package:brazilian_perfect/src/ui/widgets/custom_elevated_button_create_tournament.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TournamentManager tournamentManager = TournamentManager.instance;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: const CustomAppBar(title: 'BRAZILIAN PERFECT'),
          body: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 22.h,
                  top: 22.h,
                  right: 22.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('TORNEIOS', style: theme.textTheme.headlineLarge)
                  ],
                ),
              ),
              Expanded(
                child: tournamentManager.tournaments.isEmpty
                    ? Center(
                        child: Text(
                          'Não há torneios cadastrados',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.separated(
                        itemCount: tournamentManager.tournaments.length,
                        itemBuilder: (context, int index) {
                          final tournament = tournamentManager
                              .tournaments.reversed
                              .toList()[index];
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              //height: double.maxFinite,
                              width: 328.h,
                              margin: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                  color: tournament.status == Status.criado
                                      ? appTheme.purple900
                                      : tournament.status == Status.iniciado
                                          ? appTheme.orange900
                                          : appTheme.gray500,
                                  borderRadius: BorderRadius.circular(8.h)),
                              child: ListTile(
                                trailing: const Icon(Icons.chevron_right),
                                title: Align(
                                  alignment: const Alignment(0.3, 0),
                                  child: Text(tournament.name),
                                ),
                                subtitle: Align(
                                  alignment: const Alignment(0.3, 0),
                                  child: Text(
                                    "${tournament.type}   |   ${DateFormat('dd/MM/yyyy').format(tournament.date)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {});
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => TournamentScreen(
                                              tournament: tournament)));
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 0),
                      ),
              ),
              //const Spacer(),
              CustomElevatedButtonCreateTournament(
                context: context,
                width: double.maxFinite,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateTournamentScreen()));
                },
              ),
            ],
          )),
    );
  }
}
