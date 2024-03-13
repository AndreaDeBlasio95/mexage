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
  Color cTextBoldMedium = Colors.black;
  Color cTextNormal = Colors.black;
  Color cTextSmall = Colors.black;
  Color cTextMessageCard = Colors.black;
  Color cTextTabBar = Colors.black;
  Color cTextDisabled = Colors.black;
  Color cIcons = Colors.black;
  Color cCardMessageInbox = Colors.black;
  Color cTabOptions = Colors.black;
  Color cCardShadow = Colors.black;
  Color cTextWelcomeTitle = Colors.black;

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
  TextStyle tTextBoldMedium = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 32,
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
  TextStyle tTextWelcomeTitle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 48,
  );

  int get currentTheme => _theme;

  // Set Theme Colors
  void setTheme(int value) {
    _theme = value;
    if (value == 0) {
      // --- LIGHT ---
      cBackGround = Colors.white;
      cTextAppBar = const Color(0xFF7D53DE); // Medium slate blue
      cTextTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextBold = const Color(0xFF00120B);
      cTextNormal = const Color(0xFF00120B);
      cTextSmall = Colors.grey.shade600;
      cTextTabBar = const Color(0xFF7699D4); // vista blue
      cTextDisabled = const Color(0xFF505B63); // Payne's grey
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCard = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF137DCD);
      cTextWelcomeTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextBoldMedium = Colors.white;
    } else if (value == 1) {
      // --- DARK ---
      cBackGround = const Color(0xFF141F25);
      cTextAppBar = const Color(0xFF7D53DE); // Medium slate blue
      cTextTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextBold = Colors.white;
      cTextNormal = Colors.white;
      cTextSmall = Colors.grey.shade400;
      cTextTabBar = const Color(0xFF90FCF9); // ice blue
      cTextDisabled = const Color(0xFF505B63); // Payne's grey
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCard = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF137DCD);
      cTextWelcomeTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextBoldMedium = const Color(0xFF141F25);
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
    tTextWelcomeTitle = TextStyle(
      color: cTextWelcomeTitle,
      fontWeight: FontWeight.w800,
      fontSize: 36,
    );
    tTextBoldMedium = TextStyle(
      color: cTextBoldMedium,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
  }
}
