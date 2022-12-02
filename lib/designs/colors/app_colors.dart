import 'package:flutter/material.dart';
import 'dart:math';

const test = Color.fromARGB(191, 160, 255, 253);
const houseIcon = Color.fromARGB(206, 0, 0, 0);
Color mainAppBackGroundColor = Colors.grey.shade300;
MaterialColor mainAppColor = Colors.blue;
Color mainAppButtonBackgroundColor = Colors.white;
Color mainAppTextFieldColor = Colors.white;
Color mainAppBarColor = Colors.white;
Color mainAppTextColor = Colors.black;
Color mainAppIconColor = Colors.black;
Color mainAppTileColor = Colors.white;

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
