import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mexage/utils/utils.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import '../views/message_view.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return GestureDetector(
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
            transitionDuration:
                Duration(milliseconds: 500), // Adjust duration as needed
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: themeProvider.cCardShadow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: themeProvider.cCardMessageInbox,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(message.content,
                      style: themeProvider.tTextMessageCard,
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: _buildTrailingLikesWidget(),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildTrailingLikesWidget() {
    return Text(
      Utils.formatNumber(message.likes),
      style: const TextStyle(
        fontFamily: 'nunito',
        color: Colors.white,
        fontSize: 14,
        fontVariations: [
          FontVariation('wght', 800),
        ],
      ),
    );
  }
}
