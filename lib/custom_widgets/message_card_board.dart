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
  final Future<void> Function() refreshDataFunction;

  MessageCardBoard({Key? key, required this.message, required this.refreshDataFunction}) : super(key: key);

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

  Future<void> refreshData() async {
    await widget.refreshDataFunction();
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
        refreshDataFunction: refreshData,
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
                      padding: const EdgeInsets.only(bottom: 4, top: 2, left: 2, right: 2),
                      decoration: BoxDecoration(
                        color: themeProvider.cCardColorToOpenOutline,
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
                //_buildRowTags(themeProvider),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        "New",
        style: TextStyle(
          fontFamily: 'nunito',
          color: _themeProvider.cTextTag,
          fontSize: 14,
          fontVariations: const [
            FontVariation('wght', 800),
          ],
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
