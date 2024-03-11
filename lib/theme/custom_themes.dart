// Light Theme
import 'package:flutter/material.dart';

class CustomThemes with ChangeNotifier {
  int _theme = 0;
  late Color cBackGround;
  late Color cTitle;
  late Color cTextBold;
  late Color cTextNormal;

  int get currentTheme => _theme;

  void setTheme(int _value) {
    _theme = _value;
    if (_value == 0) {
      cBackGround = Colors.white;
      cTitle = Colors.black;
      cTextBold = Colors.black;
      cTextNormal = Colors.black;
    } else {
      cBackGround = const Color(0xFF121212);
      cTitle = Colors.white;
      cTextBold = Colors.white;
      cTextNormal = Colors.white;
    }
    notifyListeners();
  }
}