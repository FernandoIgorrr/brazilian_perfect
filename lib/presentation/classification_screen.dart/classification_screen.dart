import 'package:brazilian_perfect/model/tournament.dart';
import 'package:brazilian_perfect/widgets/custom_app_bar.dart';
import 'package:brazilian_perfect/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClassificationScreen extends StatefulWidget {
  final Tournament tournament;

  const ClassificationScreen({super.key, required this.tournament});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  int? _selectedIndex;
  late final Tournament tournament;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tournament = widget.tournament;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const CustomAppBar(title: 'CLASSIFICAÇÃO'),
      body: ListView.separated(
        itemCount: tournament.players.length,
        itemBuilder: (BuildContext context, int index) {
          tournament.distributeScore();
          tournament.updateBuchholzScores();
          tournament.sortPlayersByScoreAndBuchholz();
          var player = tournament.players[index];
          Color tileColor = _selectedIndex == index
              ? appTheme.orange900
              : (index % 2 == 0 ? appTheme.gray500 : appTheme.blueGray7003f);
          return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                  height: 80.h,
                  color: tileColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${index + 1}.  ${player.name}')),
                      Expanded(
                          child: Text(
                        '${player.score}',
                        textAlign: TextAlign.right,
                      )),
                      Expanded(
                          child: Text(
                        '${player.buchholz}',
                        textAlign: TextAlign.right,
                      ))
                    ],
                  )));
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 0),
      ),
    ));
  }
}
