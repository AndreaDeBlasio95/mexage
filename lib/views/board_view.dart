import 'package:flutter/material.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../providers/open_ai_service.dart';
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
            onPressed: () async {
              final signInProvider =
                  Provider.of<SignInProvider>(context, listen: false);
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final messageProvider =
                  Provider.of<MessageProvider>(context, listen: false);
              messageProvider.addMessage(signInProvider.currentUser!.uid,
                  userProvider.userName, 'content');
              messageProvider.adminSetTopLikedMessages();

              // test open ai
              final OpenAIService openAIService = OpenAIService();
              String message = 'My id card is 1234567890';

              // Call the classifyAndFilterContent method with the user's message
              var passed = await openAIService.getExplicitnessScore(message);
              setState(() {
                print(passed);
              });

              // end test open ai
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
