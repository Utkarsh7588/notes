import 'package:flutter/material.dart';

class Palette {
  static MaterialColor kToDark = const MaterialColor(
    0xFFFECD00, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffffffff),
      100: Color(0xfffff5cc),
      200: Color(0xffffeb99),
      300: Color(0xfffee166),
      400: Color(0xfffed733),
      500: Color(0xffcba400),
      600: Color(0xff987b00),
      700: Color(0xff665200),
      800: Color(0xff332900),
      900: Color(0xff000000), //60%
      //100%
    },
  );
}
