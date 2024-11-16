import 'package:flutter/material.dart';
import '../../core/app_export.dart';

/// A classe that offers pre-defined button styles for customizing button appearence
class CustomButtonStyle {
  /// filled button style
  static ButtonStyle get fillOnPrimaryContainer => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        disabledBackgroundColor: theme.colorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get fillPrimaryContainer => ElevatedButton.styleFrom(
        //backgroundColor: theme.colorScheme.primary,
        backgroundColor: Colors.greenAccent,
        disabledBackgroundColor: theme.colorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillOnPrimaryContainerRectangularBorder =>
      ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        disabledBackgroundColor: theme.colorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get fillPrimaryContainerRectangularBorder =>
      ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        disabledBackgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  // static ButtonStyle get fillOnPrimaryContainerRectangularBorder2 =>
  //     ButtonStyle(
  //       backgroundColor : WidgetStateProperty.all<Color>((Set<WidgetState> states){
  //          if (onPressed == null || isDisabled == true) {
  //               return Colors.grey;
  //             }
  //             return appTheme.primaryColor;
  //       }),
  //         shape: WidgetStateProperty.all<OutlinedBorder>(
  //           RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(0.h),
  //           ),
  //         ),
  //         elevation: WidgetStateProperty.all<double>(0),
  //         padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero));
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.transparent)),
      );
}
