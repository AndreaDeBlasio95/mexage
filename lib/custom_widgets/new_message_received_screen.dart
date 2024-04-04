import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/my-rive-animation.dart';

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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                RiveAnimationBottle(userId: widget.userId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
