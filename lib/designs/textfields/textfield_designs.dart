import 'package:flutter/material.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';

InputDecoration standardTextFieldDecoration(
    {String text = '', double radius = 25, Icon? startIcon, Icon? endIcon}) {
  return InputDecoration(
    prefixIcon: startIcon,
    suffixIcon: endIcon,
    hintText: text,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: mainAppBackGroundColor, width: radius)),
    fillColor: Colors.white,
    filled: true,
  );
}
