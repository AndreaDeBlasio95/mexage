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
  Color cTextMessageCard = Colors.black;
  Color cTextTabBar = Colors.black;
  Color cIcons = Colors.black;
  Color cCardMessageInbox = Colors.black;
  Color cTabOptions = Colors.black;
  Color cCardShadow = Colors.black;

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
  TextStyle tTextTitleDrawer = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );
  TextStyle tTextMessageCard = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  TextStyle tTextTabOption = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  int get currentTheme => _theme;

  // Set Theme Colors
  void setTheme(int value) {
    _theme = value;
    if (value == 0) {
      // --- LIGHT ---
      cBackGround = Colors.white;
      cTextAppBar = const Color(0xFF7368F5); // Medium slate blue
      cTextTitle = const Color(0xFF7368F5); // Medium slate blue
      cTextBold = const Color(0xFF121212);
      cTextNormal = const Color(0xFF121212);
      cTextSmall = Colors.grey.shade600;
      cTextTabBar = const Color(0xFF7699D4); // vista blue
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCard = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF137DCD);
    } else if (value == 1) {
      // --- DARK ---
      cBackGround = const Color(0xFF121212);
      cTextAppBar = const Color(0xFF7368F5); // Medium slate blue
      cTextTitle = const Color(0xFF7368F5); // Medium slate blue
      cTextBold = Colors.white;
      cTextNormal = Colors.white;
      cTextSmall = Colors.grey.shade400;
      cTextTabBar = const Color(0xFF90FCF9); // ice blue
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCard = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF137DCD);
    }
    setTextStyles(value);
    notifyListeners();
    print('Theme: $currentTheme');
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
    tTextTitleDrawer = TextStyle(
      color: cTextNormal,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );
    tTextMessageCard = TextStyle(
      color: cTextMessageCard,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
    tTextTabBar = TextStyle(
      color: cTabOptions,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
  }
}
