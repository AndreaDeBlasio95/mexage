import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/outline_text.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import 'inbox_view.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  @override
  Widget build(BuildContext context) {

    return Consumer<CustomThemes>(
      builder: (context, themeProvider, _) {
        return Container(
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending', style: themeProvider.tTextBoldMedium,
              ),
              Expanded(
                child: InboxView(
                  messages: [
                    Message(
                      trending: false,
                      id: "1",
                      userId: "1",
                      content: 'Hello, how are you? this is a very long message that will be cut off',
                      rank: 1,
                      likes: 15283019,
                      dislikes: 0,
                      timestamp: Timestamp.now(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
