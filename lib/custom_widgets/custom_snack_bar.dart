import 'package:flutter/material.dart';
import '../theme/custom_themes.dart';

class CustomSnackBar {
  static void showSnackbar(BuildContext context, String message, CustomThemes themeProvider) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: themeProvider.tTextSnackBar,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: themeProvider.cSnackBar,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}