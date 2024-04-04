import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import '../utils/utils.dart';
import 'animated_cartoon_container.dart';

class MessageCardReceived extends StatelessWidget {
  final Message message;

  const MessageCardReceived({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    String timestampToDate = Utils.timestampToDate(message.timestamp);

    return AnimatedCartoonContainer(
      collectionReference: 'random',
      type: 1,
      message: message,
      isLiked: true,
      receivedMessage: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Content ----------------------------------------------
              Container(
                padding: const EdgeInsets.only(top: 8,),
                width: double.infinity,
                child: Text(message.content,
                    style: themeProvider.tTextCard,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 24),
              // Timestamp ----------------------------------------------
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(timestampToDate,
                    style: themeProvider.tTextSmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
