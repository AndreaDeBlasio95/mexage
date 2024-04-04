import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/bottle_message.dart';
import 'package:provider/provider.dart';

import '../theme/custom_themes.dart';

class NewMessageReceivedScreen extends StatefulWidget {
  final String userId;

  const NewMessageReceivedScreen({super.key, required this.userId});

  @override
  State<NewMessageReceivedScreen> createState() =>
      _NewMessageReceivedScreenState();
}

class _NewMessageReceivedScreenState extends State<NewMessageReceivedScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        padding: const EdgeInsets.all(16),
        child: RiveAnimationBottle(userId: widget.userId),
      ),
    );
  }
}
