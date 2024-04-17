import 'package:flutter/material.dart';
import 'package:zoom_clone_app/utils/colors.dart';

class MyAppThemeData {
  static ThemeData myAppThemeData()  {
    return ThemeData(

    );
  }

  static ThemeData myAppThemeDataDark() {
    return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
    );
  }
}