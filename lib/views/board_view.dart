import 'package:flutter/material.dart';

import '../models/message_model.dart';
import 'inbox_view.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InboxView(
        messages: [
          Message(
            id: "1",
            content: 'Hello, how are you?',
            rank: 1,
            ranked: false,
            thumbUp: 0,
          ),
          Message(
            id: "2",
            content: 'I am doing well, thank you! This is a long message',
            rank: 2,
            ranked: true,
            thumbUp: 1,
          ),
          Message(
            id: "3",
            content: 'Short message',
            rank: 2,
            ranked: true,
            thumbUp: 2,
          ),
        ],
      ),
    );
  }
}
