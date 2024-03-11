import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/message_received.dart';
import '../models/message_model.dart';

class InboxView extends StatelessWidget {
  final List<Message> messages;

  const InboxView({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return MessageCard(message: messages[index]);
        },
      ),
    );
  }
}
