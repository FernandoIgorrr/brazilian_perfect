import 'package:brazilian_perfect/presentation/create_tournament_screen/create_tournament_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String splashscreen = 'splash_screen';
  static const String homeScreen = '/home_screen';
  static const String createTournamentScreen = '/create_tournament_screen';
  static const String sucessTournamentCeationScreen =
      '/sucess_tournament_ceation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    splashscreen: (context) => const SplashScreen(),
    homeScreen: (context) => const HomeScreen(),
    createTournamentScreen: (context) => const CreateTournamentScreen(),
    initialRoute: (context) => const SplashScreen()
  };
}
