import 'dart:async';

import 'package:brazilian_perfect/presentation/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 46.h,
            ),
            _buildSunemoonSysLabsSection(context)
          ],
        ),
      ),
    ));
  }

  Widget _buildSunemoonSysLabsSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 2.h),
      child: Column(
        children: [
          Text(
            ' SUN&MOON SYS LABS ',
            style: theme.textTheme.displayMedium,
          ),
          Text(
            'by: Fernando Igor',
            style: TextStyle(
                color: appTheme.orange900, fontFamily: 'inter', fontSize: 16.h),
          ),
          Text(
            'Pre-alpha version',
            style: TextStyle(
                color: appTheme.orange900, fontFamily: 'inter', fontSize: 16.h),
          ),
        ],
      ),
    );
  }
}
