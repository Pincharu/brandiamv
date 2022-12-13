import 'package:flutter/material.dart';

import '../app/app_colors.dart';

InputDecoration textFieldDefault = const InputDecoration(
  fillColor: kcolorTextfield,
  filled: true,
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kcolorTextfield)),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kcolorTextfield)),
);

InputDecoration textFieldWhite = const InputDecoration(
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
);
