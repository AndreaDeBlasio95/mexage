import 'package:flutter/material.dart';
import '../theme/custom_themes.dart';

class MessageView extends StatelessWidget {
  final String message;
  final CustomThemes themeProvider;

  const MessageView(
      {super.key, required this.message, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message', style: themeProvider.tTextBoldMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Text(
                  message,
                  style: themeProvider.tTextNormal,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                child: Text(
                  "Like to leave a comment",
                  style: themeProvider.tTextNormal,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    color: themeProvider.cTextDisabled,
                    size: 36,
                  ),
                  Icon(
                    Icons.thumb_down_off_alt_outlined,
                    color: themeProvider.cTextDisabled,
                    size: 36,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
