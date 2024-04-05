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

    return Scaffold(
      body: RiveAnimationBottle(userId: widget.userId),
    );
  }
}
