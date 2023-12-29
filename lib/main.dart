import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/res/my_colors.dart';
import 'package:education_app/core/services/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education App - Zia',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(color: Colors.transparent),
        fontFamily: Fonts.poppins,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: MyColors.primaryColour,
        ),
      ),
      onGenerateRoute: generateRoute,
    );
  }
}
