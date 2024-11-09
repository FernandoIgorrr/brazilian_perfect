import 'package:brazilian_perfect/core/app_export.dart';
import 'package:brazilian_perfect/theme/custom_button_style.dart';
import 'package:brazilian_perfect/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class CustomElevatedButtonCreateTournament extends StatelessWidget {
  CustomElevatedButtonCreateTournament({
    super.key,
    required this.context,
    this.onPressed,
    this.buttonStyle,
    this.width,
    this.text,
  }) {
    leftIcon = _buildLeftIcon();
    rightIcon = _buildRightIcon();
    //buttonStyle = _getButtonStyle();
  }
  final double? width;
  final String? text;
  final BuildContext context;
  late final Widget leftIcon;
  late final Widget rightIcon;
  final ButtonStyle? buttonStyle;
  final Function()? onPressed;

  Widget _buildLeftIcon() {
    return Container(
      margin: EdgeInsets.only(right: 14.h),
      child: CustomImageView(
        imagePath: ImageConstant.iconTrophyLight,
        height: 40.h,
        width: 40.h,
        fit: BoxFit.contain,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildRightIcon() {
    return Container(
      margin: EdgeInsets.only(left: 14.h),
      child: CustomImageView(
        imagePath: ImageConstant.iconTrophyLight,
        height: 40.h,
        width: 40.h,
        fit: BoxFit.contain,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    return CustomButtonStyle.fillOnPrimaryContainerRectangularBorder;
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      width: width ?? 328.h,
      text: text ?? 'CRIAR TORNEIO',
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      buttonStyle: buttonStyle ?? _getButtonStyle(),
      onPressed: onPressed,
    );
  }
}
