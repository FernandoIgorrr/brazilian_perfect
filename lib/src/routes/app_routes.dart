import 'package:brazilian_perfect/src/ui/presentation/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    initialRoute: (context) => const SplashScreen()
  };
}
