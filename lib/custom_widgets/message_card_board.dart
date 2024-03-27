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

  const MessageCardBoard({super.key, required this.message});

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
    if (widget.message.userId == signInProvider.currentUser!.uid) {
      return true;
    }
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

    return Consumer<CustomThemes>(builder: (context, themeProvider, _) {
      return FutureBuilder<bool>(
          future: _messageExistFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(); // Placeholder for loading state
            }
            if (snapshot.hasError) {
              return Container(); // Placeholder for error state
            }
            return AnimatedCartoonContainer(
              message: widget.message,
              isLiked: _messageExist,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4, bottom: 4),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(widget.message.content,
                                  style: themeProvider.tTextCard,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(width: 8),
                          !_messageExist
                              ? _buildTrailingNewOrYour(themeProvider)
                              : Container(
                                  height: 40,
                                  width: 1,
                                ),
                        ],
                      ),
                      //_buildRowTags(themeProvider),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget _buildTrailingNewOrYour(CustomThemes _themeProvider) {
    String _tagNewOrYour = "New";
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    if (widget.message.userId == signInProvider.currentUser!.uid) {
      _tagNewOrYour = "Your";
    }
    return _tagNewOrYour == "New"
        ? Container(
            padding:
                const EdgeInsets.only(bottom: 4, top: 1, left: 2, right: 2),
            decoration: BoxDecoration(
              color: _themeProvider.cIcons,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                _tagNewOrYour,
                style: TextStyle(
                  fontFamily: 'nunito',
                  color: _themeProvider.cTextTag,
                  fontSize: 14,
                  fontVariations: const [
                    FontVariation('wght', 800),
                  ],
                ),
              ),
            ),
          )
        : Container(
            padding:
                const EdgeInsets.only(bottom: 4, top: 1, left: 2, right: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD1A258),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF7D151),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                _tagNewOrYour,
                style: TextStyle(
                  fontFamily: 'nunito',
                  color: _themeProvider.cBackGround,
                  fontSize: 14,
                  fontVariations: const [
                    FontVariation('wght', 800),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildRowTags(CustomThemes _themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            "lifestyle",
            style: _themeProvider.tTextTag,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            "$_messageExist",
            style: _themeProvider.tTextTag,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            "+18",
            style: _themeProvider.tTextTag,
          ),
        ),
      ],
    );
  }
}
