import 'package:flutter/material.dart';
import '../theme/custom_themes.dart';

class MessageView extends StatelessWidget {
  final String message;
  final CustomThemes themeProvider;

  const MessageView({super.key, required this.message, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message', style: themeProvider.tTextAppBar),
      ),
      body: Center(
        child: Text(message, style: themeProvider.tTextNormal,),
      ),
    );
  }
}
