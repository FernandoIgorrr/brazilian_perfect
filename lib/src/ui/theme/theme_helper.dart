import 'package:flutter/material.dart';
import '../../core/utils/size_utils.dart';

String _appTheme = 'darkCode';
DarkCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

class ThemeHelper {
  /// A map of custom colors theme supported  by the app
  final Map<String, DarkCodeColors> _supportedCustomColor = {
    'darkCode': DarkCodeColors()
  };

  /// A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'darkCode': ColorSchemes.darkCodeScheme
  };

  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  /// Return the darkCode colors for the current theme
  DarkCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? DarkCodeColors();
  }

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.darkCodeScheme;
    return ThemeData(
        visualDensity: VisualDensity.standard,
        colorScheme: colorScheme,
        textTheme: TextThemes.textTheme(colorScheme),
        scaffoldBackgroundColor: colorScheme.onPrimary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: appTheme.blueGray7003f,
              elevation: 4,
              visualDensity: const VisualDensity(
                vertical: -4,
                horizontal: -4,
              ),
              padding: EdgeInsets.zero),
        ),
        dividerTheme: DividerThemeData(
          thickness: 4,
          space: 4,
          color: colorScheme.onPrimaryContainer,
        ));
  }

  /// Returns the darkCode colors for the current theme.
  DarkCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        displayMedium: TextStyle(
          color: appTheme.orange900,
          fontSize: 80.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 64.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 64.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          color: appTheme.gray500,
          fontSize: 50.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 50.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: Colors.greenAccent,
          fontSize: 50.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          color: appTheme.gray500,
          fontSize: 40.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: 40.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 40.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 32.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: const Color(0X3F2B5D66),
          fontSize: 32.fSize,
          fontFamily: 'Scaatliches',
          fontWeight: FontWeight.w400,
        ),
      );
}

/// Class contaning the supported color schemes.
class ColorSchemes {
  static const darkCodeScheme = ColorScheme.dark(
    primary: Color(0XFF75295A),
    onPrimary: Color(0XFF303030),
    onPrimaryContainer: Color(0XFFD9D9D9),
    secondary: Color(0XFF55B8C9),
    //onSecondaryContainer: Color(),
    onSecondary: Color(0XFF929292),
  );
}

/// Class containing custom colors for a darkCode theme.
class DarkCodeColors {
  /// Primary
  Color get primary => const Color(0XFF55B8C9);

  /// BlueGrayf
  Color get blueGray7003f => const Color(0X3F2B5D66);

  /// Gray
  Color get gray500 => const Color(0XFF929292);

  /// LightGrey
  Color get lightgray => const Color(0XFFD9D9D9);

  ///white
  Color get white => const Color(0XFFFFFFFF);

  /// Purple
  Color get purple900 => const Color(0XFF75295A);

  /// Orange
  Color get orange900 => const Color(0XFFF3831C);
}
