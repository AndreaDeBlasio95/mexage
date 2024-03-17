import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import '../views/message_view.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: themeProvider.cCardShadow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: themeProvider.cCardMessageInbox,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: ListTile(
              title: Text(message.content,
                  style: themeProvider.tTextMessageCard,
                  overflow: TextOverflow.ellipsis),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: themeProvider.cCardMessageInbox,
                  borderRadius: BorderRadius.circular(24),
                ),
                width: 50,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTrailingWidget(),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => MessageView(
                        message: message.content, themeProvider: themeProvider),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastOutSlowIn, // Bounce-in curve
                          ),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 500), // Adjust duration as needed
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    if (message.likes == 0) {
      return Icon(
        Icons.thumb_up_alt_outlined,
        color: Colors.grey.shade200,
        size: 20,
      );
    }
    if (message.likes == 1) {
      return Icon(Icons.thumb_up_alt_rounded,
          color: Colors.grey.shade200, size: 20);
    }
    if (message.likes == 2) {
      return Icon(Icons.thumb_down, color: Colors.grey.shade200, size: 20);
    }
    return const SizedBox();
  }
}
