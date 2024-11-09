import 'package:brazilian_perfect/model/dto/tournament_creation_dto.dart';
import 'package:brazilian_perfect/model/tournament.dart';
import 'package:brazilian_perfect/model/tournament_manager.dart';
import 'package:brazilian_perfect/presentation/create_tournament_screen/sucess_tournament_creation_screen.dart';
import 'package:brazilian_perfect/theme/custom_button_style.dart';
import 'package:brazilian_perfect/widgets/custom_app_bar.dart';
import 'package:brazilian_perfect/widgets/custom_elevated_button_create_tournament.dart';
import 'package:brazilian_perfect/widgets/custom_radio_choice.dart';
import 'package:brazilian_perfect/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../core/app_export.dart';
import 'package:intl/intl.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});
  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  late final BuildContext parentContext;
  TournamentCreationDto tournament = TournamentCreationDto();
  TextEditingController tournamentNameInputController = TextEditingController();
  TextEditingController tournamentTypeController = TextEditingController();
  TextEditingController tournamentDateInputController = TextEditingController();

  late final List<String> tournamentTypeChoiceItems = ['swiss', 'round robin'];

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'CRIAR TORNEIO'),
        body: SingleChildScrollView(
          child: Align(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                _buildTournamentNameInput(),
                const SizedBox(
                  height: 24,
                ),
                _buildTournamentTypeInput(),
                const SizedBox(
                  height: 24,
                ),
                _buildTournamentDateInput(),
                const SizedBox(
                  height: 24,
                ),
                Observer(builder: (_) {
                  return CustomElevatedButtonCreateTournament(
                      context: context,
                      buttonStyle: CustomButtonStyle.fillOnPrimaryContainer,
                      onPressed:
                          tournament.minFilledDatas ? _createTournament : null);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentNameInput() {
    return CustomTextFormField(
      //onChange: (value) => tournament.setName(value),
      onChange: (value) {
        setState(() {
          tournament.setName(value);
        });
      },
      hintText: 'NOME DO TORNEIO',
      width: 328.h,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
    );
  }

  Widget _buildTournamentTypeInput() {
    return CustomRadioChoice(
      onSelected: (String value) {
        tournament.setType(value);
      },
      choices: tournamentTypeChoiceItems,
    );
  }

  Widget _buildTournamentDateInput() {
    return CustomTextFormField(
      width: 328.h,
      controller: tournamentDateInputController,
      //onChange: (value) => tournament.setDate(value),
      hintText: "DATA DO TORNEIO",
      readonly: true,
      textInputType: TextInputType.datetime,
      suffix: IconButton(
        icon: CustomImageView(
          imagePath: ImageConstant.iconCalendar,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () => _buildSelectDate(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Data vazia!';
        }
        return null;
      },
    );
  }

  Future<void> _buildSelectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(DateTime.now().month),
        lastDate: DateTime(DateTime.now().year + 1),
        builder: (context, child) {
          return FittedBox(
            child: Theme(
                data: ThemeData(colorSchemeSeed: appTheme.purple900),
                child: child!),
          );
        });

    if (picked != null) {
      setState(() {
        tournamentDateInputController.text =
            DateFormat('dd/MM/yyyy').format(picked);
        tournament.setDate(picked);
      });
    }
  }

  _createTournament() async {
    TournamentManager tournamentManager = TournamentManager.instance;
    tournamentManager.createTournament(Tournament.toTourmament(tournament));
    tournamentManager.saveTournamentsOnLocalStorage();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                SucessTournamentCreationScreen(tournament: tournament)));

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       backgroundColor: Colors.greenAccent,
    //       content: Text(
    //         "Torneio criado com sucesso!",
    //         textAlign: TextAlign.center,
    //       )));
    // }
  }
}
