import 'package:flutter/material.dart';

ButtonStyle standardButtonStyle(
    {double height = 10,
    double width = 10,
    double radius = 17,
    Alignment alignment = Alignment.center,
    Color backgroundColor = Colors.white}) {
  return ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(backgroundColor),
      alignment: alignment,
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      fixedSize: MaterialStatePropertyAll(Size(width, height)));
}
