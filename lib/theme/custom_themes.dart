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
  Color cTextSmall = Colors.black;
  Color cTextTabBar = Colors.black;
  Color cCardMessageInbox = Colors.black;

  // --- TEXT STYLES ---
  TextStyle tTextAppBar = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );
  TextStyle tTextNormal = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 16,
  );
  TextStyle tTextSmall = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 10,
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
      // --- LIGHT ---
      cBackGround = Colors.white;
      cTextAppBar = const Color(0xFF121212);
      cTextTitle = Colors.blue;
      cTextBold = Colors.blue;
      cTextNormal = const Color(0xFF121212);
      cTextSmall = Colors.grey.shade600;
      cTextTabBar = const Color(0xFF7699D4); // vista blue
      cCardMessageInbox = const Color(0xFF03F7EB).withOpacity(0.1); // light grey
    } else if (value == 1) {
      // --- DARK ---
      cBackGround = const Color(0xFF121212);
      cTextAppBar = Colors.white;
      cTextTitle = Colors.white;
      cTextBold = Colors.white;
      cTextNormal = Colors.white;
      cTextSmall = Colors.grey.shade400;
      cTextTabBar = const Color(0xFF90FCF9); // ice blue
      cCardMessageInbox = const Color(0xFF1F1F1F); // dark grey
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
      fontSize: 16,
    );
    tTextSmall = TextStyle(
      color: cTextSmall,
      fontWeight: FontWeight.w600,
      fontSize: 10,
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
