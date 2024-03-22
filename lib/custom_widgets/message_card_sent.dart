import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container.dart';
import 'package:mexage/utils/utils.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import '../views/message_view.dart';

class MessageCardSent extends StatelessWidget {
  final Message message;

  const MessageCardSent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    String timestampToDate = Utils.timestampToDate(message.timestamp);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MessageView(
                originalMessageId: message.id,
                userId: message.userId,
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
      child: AnimatedCartoonContainer(
        message: message,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Timestamp ----------------------------------------------
                Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(timestampToDate,
                          style: themeProvider.tTextTimestamp)),
                ),
                // Content ----------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
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
                const SizedBox(height: 12),
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
