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
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Consumer<CustomThemes>(
      builder: (context, themeProvider, _) {
        return Container(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  child: OutlinedText(
                    text: 'Trending',
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: themeProvider.cBackGround, letterSpacing: 2.0),
                    outlineColor: themeProvider.cOutline,
                    outlineWidth: 3.0,
                  ),
                ),
              ),
              Expanded(
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
                      content:
                          'I am doing well, thank you! This is a long message',
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
              ),
            ],
          ),
        );
      },
    );
  }
}
