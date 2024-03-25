import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';

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
    _messageExistFuture = messageExistInUserCollection();

  }

  Future<bool> messageExistInUserCollection() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    try {
      bool documentExists = await messageProvider.checkIfDocumentExists(
          widget.message.id, signInProvider.currentUser!.uid);
      setState(() {
        _messageExist = documentExists;
      });
      return documentExists;
    } catch (e) {
      print('Error: $e');
      _messageExist = false;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return AnimatedCartoonContainer(
        message: widget.message,
        isLiked: _messageExist,
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
                          style: themeProvider.tTextCard,
                          overflow: TextOverflow.ellipsis),
                    ),
                    !_messageExist ? Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF218FC4),
                        borderRadius: BorderRadius.circular(20),
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
                        style: themeProvider.tTextTag,
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
                        "$_messageExist",
                        style: themeProvider.tTextTag,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "+18",
                        style: themeProvider.tTextTag,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildTrailingLikesWidget(CustomThemes _themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF1AADF6),
        borderRadius: BorderRadius.circular(24),
      ),
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
