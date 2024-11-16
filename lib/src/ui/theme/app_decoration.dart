import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppDecoration {
  // Cinzaescuro decorations
  static BoxDecoration get cinzaescuro =>
      BoxDecoration(color: theme.colorScheme.onPrimary);

  /// Roxo decorations
  static BoxDecoration get roxo => BoxDecoration(color: appTheme.purple900);

  /// Cinzaclaro decorations
  static BoxDecoration get cinzaclaro =>
      BoxDecoration(color: appTheme.lightgray);
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderTL8 =>
      BorderRadius.vertical(top: Radius.circular(8.h));
}
