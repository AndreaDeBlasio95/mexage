import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:mexage/utils/utils.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';
import '../views/message_view.dart';

class MessageCardBoard extends StatefulWidget {
  final Message message;

  MessageCardBoard({super.key, required this.message});

  @override
  State<MessageCardBoard> createState() => _MessageCardBoardState();
}

class _MessageCardBoardState extends State<MessageCardBoard> {
  late Future<bool> _messageExistFuture;
  bool _messageExist = false;

  @override
  void initState() {
    super.initState();
    _messageExistFuture = messageExistInUserCollection(context);
    _messageExistFuture.then((value) {
      setState(() {
        _messageExist = value;
      });
    });
  }

  Future<bool> messageExistInUserCollection(context) async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    try {
      bool documentExists = await messageProvider.checkIfDocumentExists(
          widget.message.id, signInProvider.currentUser!.uid);
      print(
          'Document exists from message card board - in the user collection: $documentExists');
      return documentExists;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MessageView(
                originalMessageId: widget.message.id,
                userId: widget.message.userId,
                message: widget.message.content,
                themeProvider: themeProvider),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
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
            transitionDuration:
                const Duration(milliseconds: 500), // Adjust duration as needed
          ),
        );
      },
      child: AnimatedCartoonContainer(
        message: widget.message,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(widget.message.content,
                          style: themeProvider.tTextMessageCard,
                          overflow: TextOverflow.ellipsis),
                    ),
                    !_messageExist ? Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: _buildTrailingLikesWidget(themeProvider),
                      ),
                    ) : Container(
                      height: 40,
                      width: 1,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "lifestyle",
                        style: themeProvider.tTextSnackBar,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "motivation",
                        style: themeProvider.tTextSnackBar,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "+18",
                        style: themeProvider.tTextSnackBar,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingLikesWidget(CustomThemes _themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: const Text(
        "New",
        style: TextStyle(
          fontFamily: 'nunito',
          color: Colors.white,
          fontSize: 14,
          fontVariations: [
            FontVariation('wght', 800),
          ],
        ),
      ),
    );
  }
}
