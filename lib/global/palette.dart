import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff98FB98, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff89e289), //10%
      100: Color(0xff7ac97a), //20%
      200: Color(0xff6ab06a), //30%
      300: Color(0xff5b975b), //40%
      400: Color(0xff4c7e4c), //50%
      500: Color(0xff3d643d), //60%
      600: Color(0xff2e4b2e), //70%
      700: Color(0xff1e321e), //80%
      800: Color(0xff0f190f), //90%
      900: Color(0xff000000), //100%
    },
  );
}
