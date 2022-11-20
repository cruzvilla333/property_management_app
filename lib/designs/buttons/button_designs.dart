import 'package:flutter/material.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';

ButtonStyle standardButtonStyle(
    {double height = 10, double width = 10, double radius = 17}) {
  return ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(buttonBackgroundColor),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      fixedSize: MaterialStatePropertyAll(Size(width, height)));
}
