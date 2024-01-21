import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  final _primary = const Color.fromRGBO(239, 45, 86, 1);
  final _secondary = const Color.fromRGBO(255, 150, 31, 1);

  final _white = const Color.fromRGBO(247, 255, 247, 1);

  final _black = const Color.fromRGBO(38, 37, 39, 1);

  final _error = Colors.red;
  final _surface = const Color.fromRGBO(51, 49, 53, 1);

  final _gradient = const LinearGradient(colors: [
    Color.fromRGBO(239, 45, 86, 1),
    Color.fromRGBO(255, 150, 31, 1),
  ]);

  get primary => _primary;
  get secondary => _secondary;
  get white => _white;
  get black => _black;
  get error => _error;
  get surface => _surface;
  get gradient => _gradient;

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          background: _black,
          brightness: Brightness.dark,
          error: _error,
          primary: primary,
          onPrimary: _error,
          secondary: _secondary,
          onSecondary: _black,
          onError: _white,
          onBackground: _white,
          surface: _surface,
          onSurface: _white,
        ),
        tabBarTheme: TabBarTheme(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          indicator: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: _white,
          ),
          labelColor: _black,
          unselectedLabelColor: _white,
        ),
        textTheme: TextTheme(
          labelLarge: TextStyle(color: _white, fontSize: 18),
          bodyLarge: TextStyle(color: _white),
          // Define el tamaño de la fuente del texto
          bodyMedium: TextStyle(fontSize: 16, color: _white),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),

        // elevatedButtonTheme: const ElevatedButtonThemeData(
        //     style: ButtonStyle(
        //         backgroundColor: MaterialStatePropertyAll(Colors.white)
        //         ))
      );
}
