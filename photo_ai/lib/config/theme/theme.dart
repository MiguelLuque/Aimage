import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        // hexadecimal color
        //primaryColor: Color.fromRGBO(178, 223, 219, 1),
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: TextTheme(labelLarge: TextStyle(color: Colors.white)),
        appBarTheme: const AppBarTheme(centerTitle: false),
      );

  // AppTheme copyWith({int? selectedColor, bool? isDarkmode}) => AppTheme(
  //       selectedColor: selectedColor ?? this.selectedColor,
  //       isDarkmode: isDarkmode ?? this.isDarkmode,
  //     );
}
