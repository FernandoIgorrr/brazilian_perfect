import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      this.centerTitle,
      this.automaticallyImplyLeading,
      this.height});

  final String title;

  final bool? centerTitle;

  final bool? automaticallyImplyLeading;

  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      elevation: 0,
      toolbarHeight: height ?? 66.h,
      title: Text(
        title,
        style: theme.textTheme.headlineLarge,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: centerTitle ?? true,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(66.h);
}
