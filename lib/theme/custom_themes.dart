// Light Theme
import 'package:flutter/material.dart';

class CustomThemes with ChangeNotifier {
  int _theme = 0;

  // Initialize with default values

  // --- COLORS ---
  Color cBackGround = Colors.black;
  Color cTextAppBar = Colors.black;
  Color cTextTitle = Colors.black;
  Color cTextBold = Colors.black;
  Color cTextNormal = Colors.black;
  Color cTextTabBar = Colors.black;

  // --- TEXT STYLES ---
  TextStyle tTextAppBar = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );
  TextStyle tTextNormal = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 18,
  );
  TextStyle tTextBold = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
  TextStyle tTextTabBar = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  int get currentTheme => _theme;

  // Set Theme Colors
  void setTheme(int value) {
    _theme = value;
    if (value == 0) {
      // light
      cBackGround = Colors.white;
      cTextAppBar = const Color(0xFF121212);
      cTextTitle = Colors.blue;
      cTextBold = Colors.blue;
      cTextNormal = const Color(0xFF121212);
      cTextTabBar = const Color(0xFF7699D4); // vista blue
    } else if (value == 1) {
      // dark
      cBackGround = const Color(0xFF121212);
      cTextAppBar = Colors.white;
      cTextTitle = Colors.white;
      cTextBold = Colors.white;
      cTextNormal = Colors.white;
      cTextTabBar = const Color(0xFF90FCF9); // ice blue
    }
    setTextStyles(value);
    notifyListeners();
  }

  // Set Text Style
  void setTextStyles (int value) {
    tTextAppBar = TextStyle(
      color: cTextAppBar,
      fontWeight: FontWeight.w700,
      fontSize: 22,
    );
    tTextNormal = TextStyle(
      color: cTextNormal,
      fontWeight: FontWeight.normal,
      fontSize: 18,
    );
    tTextBold = TextStyle(
      color: cTextBold,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    );
    tTextTabBar = TextStyle(
      color: cTextTabBar,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
  }
}
