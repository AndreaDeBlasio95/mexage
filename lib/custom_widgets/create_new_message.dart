import 'package:flutter/material.dart';
import 'package:mexage/providers/message_provider.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/custom_themes.dart';

class CreateNewMessage extends StatelessWidget {
  const CreateNewMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomThemes>(builder: (context, themeProvider, _) {
      return GestureDetector(
        onTap: () async {
          final signInProvider = Provider.of<SignInProvider>(context, listen: false);
          final messageProvider = Provider.of<MessageProvider>(context, listen: false);
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await messageProvider.addMessage(signInProvider.currentUser!.uid, userProvider.userName, "Message sent from 'Sent View' by ${userProvider.userName}");
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              ),
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(bottom: 6, left: 2, right: 2, top: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF48ACF0),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Image.asset(
                'images/icon-parchment.png',
                height: 50,
                width: 50,
              ),
            ),
          ),
        ),
      );
    });
  }
}
