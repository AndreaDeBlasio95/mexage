import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../theme/custom_themes.dart';
import '../custom_widgets/board_messages.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomThemes>(
      builder: (context, themeProvider, _) {
        return Scaffold(
          backgroundColor: themeProvider.cBackGround,
          body: Container(
            padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending',
                  style: themeProvider.tTextBoldMedium,
                ),
                const SizedBox(height: 8),
                const Expanded(
                  child: BoardMessages(),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final signInProvider =
                  Provider.of<SignInProvider>(context, listen: false);
              final messageProvider =
                  Provider.of<MessageProvider>(context, listen: false);
              messageProvider.addMessage(
                  signInProvider.currentUser!.uid, 'content');
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
