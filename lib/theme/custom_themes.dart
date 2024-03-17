// Light Theme
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomThemes with ChangeNotifier {
  int _theme = 0;

  // Initialize with default values

  // --- COLORS ---
  Color cBackGround = Colors.black;
  Color cTextAppBar = Colors.black;
  Color cTextTitle = Colors.black;
  Color cTextGrey = Colors.black;
  Color cTextBold = Colors.black;
  Color cTextBoldMedium = Colors.black;
  Color cTextNormal = Colors.black;
  Color cTextSmall = Colors.black;
  Color cTextMessageCard = Colors.black;
  Color cTextMessageCardDrawer = Colors.black;
  Color cTextTabBar = Colors.black;
  Color cTextDisabled = Colors.black;
  Color cIcons = Colors.black;
  Color cCardMessageInbox = Colors.black;
  Color cTabOptions = Colors.black;
  Color cCardShadow = Colors.black;
  Color cTextWelcomeTitle = Colors.black;
  Color cTextNavigationSelected = Colors.black;
  Color cTextNavigationNotSelected = Colors.black;
  Color cRed = Colors.black;
  Color cOutline = Colors.black;
  Color cOutlineBlue = Colors.black;


  // --- TEXT STYLES ---
  TextStyle tTextHomeTitle = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.blue,
    fontSize: 22,
  );
  TextStyle tTextAppBar = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.blue,
    fontSize: 22,
  );
  TextStyle tTextMedium = const TextStyle(
    color: Colors.black,
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
  TextStyle tTextMessageCardDrawer = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.blue,
    fontSize: 16,
  );
  TextStyle tTextTabOption = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  TextStyle tTextWelcomeTitle = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 48,
  );
  TextStyle tTextNavigationSelected = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );
  TextStyle tTextNavigationNotSelected = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  int get currentTheme => _theme;

  // Set Theme Colors
  void setTheme(int value) {
    _theme = value;
    if (value == 0) {
      // --- LIGHT ---
      cBackGround = Colors.white;
      cTextAppBar = const Color(0xFF4259F0); // Zaffre blue
      cTextTitle = const Color(0xFF4259F0); // Medium slate blue
      cTextGrey = const Color(0xFF4B4B4B);
      cTextBold = const Color(0xFF00120B);
      cTextNormal = const Color(0xFF00120B);
      cTextSmall = Colors.grey.shade600;
      cTextTabBar = const Color(0xFF7699D4); // vista blue
      cTextDisabled = const Color(0xFF505B63); // Payne's grey
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCard = Colors.white;
      cTextMessageCardDrawer = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF329BEC);
      cTextWelcomeTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextBoldMedium = Colors.white;
      cTextNavigationSelected = const Color(0xFF137DCD);
      cTextNavigationNotSelected = const Color(0xFF505B63);
      cRed = const Color(0xFFD32F2F);
      cOutlineBlue = const Color(0xFFA7D6FF);
      cOutline = const Color(0xFFE5E5E5);
    } else if (value == 1) {
      // --- DARK ---
      cBackGround = const Color(0xFF141F25);
      cTextAppBar = const Color(0xFF7B8BF4); // RISD blue
      cTextTitle = const Color(0xFF7B8BF4); // RISD blue
      cTextGrey = Colors.grey.shade400;
      cTextBold = Colors.white;
      cTextNormal = Colors.white;
      cTextSmall = Colors.grey.shade400;
      cTextTabBar = const Color(0xFFF9F4F5); // ice blue
      cTextDisabled = const Color(0xFF505B63); // Payne's grey
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCard = Colors.white;
      cTextMessageCardDrawer = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF329BEC);
      cTextWelcomeTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextBoldMedium = const Color(0xFF141F25);
      cTextNavigationSelected = Colors.white;
      cTextNavigationNotSelected = const Color(0xFF505B63);
      cRed = const Color(0xFFD32F2F);
      cOutlineBlue = const Color(0xFFA7D6FF);
      cOutline = const Color(0xFFE5E5E5);
    }
    setTextStyles(value);
    notifyListeners();
    print('Theme: $currentTheme');
  }

  // Set Text Style
  void setTextStyles (int value) {
    tTextHomeTitle = TextStyle(
      fontFamily: 'nunito',
      color: cTextTitle,
      fontSize: 22,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextAppBar = TextStyle(
      fontFamily: 'nunito',
      color: cTextAppBar,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      fontVariations: const [
        FontVariation('wght', 800),
      ],
    );
    tTextNormal = TextStyle(
      fontFamily: 'nunito',
      color: cTextNormal,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      fontVariations: const [
        FontVariation('wght', 500),
      ],
    );
    tTextMedium = TextStyle(
      fontFamily: 'nunito',
      color: cTextGrey,
      fontSize: 20,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextSmall = TextStyle(
      fontFamily: 'nunito',
      color: cTextSmall,
      fontSize: 10,
      fontVariations: const [
        FontVariation('wght', 500),
      ],
    );
    tTextBold = TextStyle(
      fontFamily: 'nunito',
      color: cTextBold,
      fontSize: 24,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextTabBar = TextStyle(
      fontFamily: 'nunito',
      color: cTextTabBar,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
    tTextTitleDrawer = TextStyle(
      fontFamily: 'nunito',
      color: cTextGrey,
      fontSize: 20,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextMessageCard = TextStyle(
      fontFamily: 'nunito',
      color: cTextMessageCard,
      fontSize: 18,
      fontVariations: const [
        FontVariation('wght', 600),
      ],
    );
     tTextMessageCardDrawer = TextStyle(
      fontFamily: 'nunito',
      color: cTextMessageCardDrawer,
      fontSize: 16,
      fontVariations: const [
        FontVariation('wght', 500),
      ],
    );
    tTextWelcomeTitle = TextStyle(
      fontFamily: 'madami',
      color: cTextWelcomeTitle,
      fontWeight: FontWeight.w800,
      fontSize: 36,
    );
    tTextBoldMedium = TextStyle(
      fontFamily: 'nunito',
      color: cTextGrey,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextNavigationSelected = TextStyle(
      fontFamily: 'nunito',
      color: cTextNavigationSelected,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );
    tTextNavigationNotSelected = TextStyle(
      fontFamily: 'nunito',
      color: cTextNavigationNotSelected,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }
}
