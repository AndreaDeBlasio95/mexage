import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container.dart';
import 'package:mexage/utils/utils.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import '../views/message_view.dart';

class MessageCardBoard extends StatelessWidget {
  final Message message;

  const MessageCardBoard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MessageView(
                originalMessageId: message.id,
                userId: message.userId,
                message: message.content,
                themeProvider: themeProvider),
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
                        child: _buildTrailingLikesWidget(themeProvider),
                      ),
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

  Widget _buildTrailingLikesWidget(CustomThemes _themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.thumb_up_alt_rounded,
            color: _themeProvider.cOutlineBlue,
          ),
          const SizedBox(width: 4),
          Text(
            Utils.formatNumber(message.likes),
            style: const TextStyle(
              fontFamily: 'nunito',
              color: Colors.white,
              fontSize: 14,
              fontVariations: [
                FontVariation('wght', 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
