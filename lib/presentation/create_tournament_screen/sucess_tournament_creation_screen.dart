import 'package:brazilian_perfect/model/dto/tournament_creation_dto.dart';
import 'package:brazilian_perfect/presentation/home_screen/home_screen.dart';
import 'package:brazilian_perfect/theme/custom_button_style.dart';
import 'package:brazilian_perfect/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';

// ignore: must_be_immutable
class SucessTournamentCreationScreen extends StatelessWidget {
  SucessTournamentCreationScreen({super.key, required this.tournament});

  TournamentCreationDto tournament;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.iconOkCircle,
                height: 328.h,
                width: 328.h,
                fit: BoxFit.contain,
                color: Colors.greenAccent,
              ),
              SizedBox(
                height: 24.h,
              ),
              Text(
                'TORNEIO CRIADO COM SUCESSO',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 24.h,
              ),
              Text(
                tournament.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                tournament.type,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(tournament.date),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: 24.h,
              ),
              CustomElevatedButton(
                width: 328.h,
                text: 'HOME',
                buttonStyle: CustomButtonStyle.fillPrimaryContainer,
                //buttonTextStyle: Theme.of(context).textTheme.headlineLarge,
                onPressed: () => {
                  Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const HomeScreen()),
                      ModalRoute.withName('/'))
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
