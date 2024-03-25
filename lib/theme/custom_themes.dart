// Light Theme
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomThemes with ChangeNotifier {
  int _theme = 0;

  // Initialize with default values

  // --- COLORS ---
  Color cBackGround = Colors.white;
  Color cTextTitle = const Color(0xFF4259F0);
  Color cTextAppBar = const Color(0xFF4259F0);
  Color cTextGrey = const Color(0xFF454F54);
  Color cTextBold = const Color(0xFFD8FBFC);
  Color cTextNormal = const Color(0xFF454F54);
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
  Color cTextTimestamp = Colors.black;
  Color cSnackBar = Colors.black;
  Color cTextCommentBold = Colors.black;
  Color cTextUsername = Colors.black;
  Color cTextCard = Colors.black;
  Color cTextTag = const Color(0xFF454F54);
  Color cCardColorToOpen = Colors.black;
  Color cCardColorToOpenOutline = Colors.black;

  // --- TEXT STYLES ---
  TextStyle tTextAppBar = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );
  TextStyle tTextGrey = const TextStyle(
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
  TextStyle tTextMessageCardDrawer = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.blue,
    fontSize: 16,
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
  TextStyle tTextTimestamp = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.blue,
    fontSize: 16,
  );
  TextStyle tTextDisabled = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.grey,
    fontSize: 16,
  );
  TextStyle tTextSnackBar = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.grey,
    fontSize: 18,
  );
  TextStyle tTextCommentBold = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.grey,
    fontSize: 18,
  );
  TextStyle tTextUsername = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.grey,
    fontSize: 18,
  );
  TextStyle tTextCard = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.white,
    fontSize: 18,
  );
  TextStyle tTextTag = const TextStyle(
    fontFamily: 'nunito',
    color: Colors.grey,
    fontSize: 18,
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
      cTextGrey = const Color(0xFFE5E5E5);
      cTextBold = const Color(0xFFD8FBFC);
      cTextNormal = const Color(0xFF454F54);
      cTextTabBar = const Color(0xFF7699D4); // vista blue
      cTextDisabled = const Color(0xFF505B63); // Payne's grey
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCardDrawer = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF329BEC);
      cTextWelcomeTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextNavigationSelected = const Color(0xFF137DCD);
      cTextNavigationNotSelected = const Color(0xFF505B63);
      cRed = const Color(0xFFD32F2F);
      cOutlineBlue = const Color(0xFF278EDD);
      cOutline = const Color(0xFFE5E5E5);
      cTextTimestamp = Colors.grey.shade700;
      cSnackBar = const Color(0xFF00120B);
      cTextCommentBold = const Color(0xFF505B63);
      cTextUsername = const Color(0xFF54ADEF);
      cCardColorToOpen = const Color(0xFFECF8FE);
      cCardColorToOpenOutline = const Color(0xFFC4EAFB);
      cTextCard = const Color(0xFF1AADF6);
      cTextTag = const Color(0xFF454F54);
    } else if (value == 1) {
      // --- DARK ---
      cBackGround = const Color(0xFF141F23);
      cTextAppBar = const Color(0xFF7B8BF4); // RISD blue
      cTextTitle = const Color(0xFF7B8BF4); // RISD blue
      cTextGrey = const Color(0xFF212F37);
      cTextBold = const Color(0xFFE6E6E6);
      cTextNormal = const Color(0xFFEAEFF1);
      cTextTabBar = const Color(0xFFF9F4F5); // ice blue
      cTextDisabled = const Color(0xFF505B63); // Payne's grey
      cIcons = const Color(0xFFDCD9FC); // tropical indigo
      cCardMessageInbox = const Color(0xFF54ADEF); // Argentinian blue
      cTextMessageCardDrawer = Colors.white;
      cTabOptions = const Color(0xFF7CC944);
      cCardShadow = const Color(0xFF329BEC);
      cTextWelcomeTitle = const Color(0xFF7D53DE); // Medium slate blue
      cTextNavigationSelected = Colors.white;
      cTextNavigationNotSelected = const Color(0xFF505B63);
      cRed = const Color(0xFFD32F2F);
      cOutlineBlue = const Color(0xFF278EDD);
      cOutline = const Color(0xFFE5E5E5);
      cTextTimestamp = Colors.grey.shade700;
      cSnackBar = Colors.white;
      cTextCommentBold = const Color(0xFF505B63);
      cTextUsername = const Color(0xFF54ADEF);
      cCardColorToOpen = const Color(0xFF4AC6FF);
      cCardColorToOpenOutline = const Color(0xFF4EAFDD);
      cTextCard = const Color(0xFF093247);
      cTextTag = const Color(0xFFDDEEEE);
    }
    setTextStyles(value);
    notifyListeners();
    print('Theme: $currentTheme');
  }

  // Set Text Style
  void setTextStyles (int value) {
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
    tTextGrey = TextStyle(
      fontFamily: 'nunito',
      color: cTextGrey,
      fontSize: 20,
      fontVariations: const [
        FontVariation('wght', 700),
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
    tTextTimestamp = TextStyle(
      fontFamily: 'nunito',
      color: cTextTimestamp,
      fontVariations: const [
        FontVariation('wght', 600),
      ],
    );
    tTextDisabled = TextStyle(
      fontFamily: 'nunito',
      color: cTextDisabled,
      fontSize: 16,
    );
    tTextSnackBar = TextStyle(
      fontFamily: 'nunito',
      color: cBackGround,
      fontSize: 14,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextCommentBold = TextStyle(
      fontFamily: 'nunito',
      color: cTextCommentBold,
      fontSize: 18,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextUsername = TextStyle(
      fontFamily: 'nunito',
      color: cTextUsername,
      fontSize: 14,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextCard = TextStyle(
      fontFamily: 'nunito',
      color: cTextCard,
      fontSize: 18,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
    tTextCard = TextStyle(
      fontFamily: 'nunito',
      color: cTextTag,
      fontSize: 14,
      fontVariations: const [
        FontVariation('wght', 700),
      ],
    );
  }
}
