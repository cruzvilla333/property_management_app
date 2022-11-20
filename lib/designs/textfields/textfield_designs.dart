import 'package:flutter/material.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';

InputDecoration standartTextFieldDecoration(
    {String text = '', double radius = 100}) {
  return InputDecoration(
    hintText: text,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: backGroundColor, width: 100)),
    fillColor: Colors.white,
    filled: true,
  );
}
