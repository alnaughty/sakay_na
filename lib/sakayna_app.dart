import 'package:flutter/material.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/splash_screen_page.dart';

class SakayNaApp extends StatelessWidget {
  const SakayNaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sakay Na',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        fontFamily: "Montserrat",
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade200,
        ),
      ),
      home: const SplashScreenPage(),
      onGenerateRoute: routeSettings,
    );
  }
}
