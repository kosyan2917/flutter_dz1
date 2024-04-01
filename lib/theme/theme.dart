import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        background: Colors.white,
        secondary: Colors.black,
        primary: Colors.blue
    )
);
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Colors.black,
        secondary: Colors.white,
        primary: Colors.blue
    )
);

final themeProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

class ThemeNotifier extends ChangeNotifier {
    ThemeData _themeData = lightMode;

    ThemeData get themeData => _themeData;

    void toggleDark() {
        _themeData = darkMode;
        notifyListeners();
    }

    void toggleLight() {
        _themeData = lightMode;
        notifyListeners();
    }
}