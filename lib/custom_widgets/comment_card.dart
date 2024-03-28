import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:provider/provider.dart';
import '../providers/sign_in_provider.dart';
import '../utils/utils.dart';

class CommentCard extends StatelessWidget {
  final CustomThemes themeProvider;
  final String userName;
  final String userId;
  final String content;
  final Timestamp timestamp;
  Color randomColor;

  CommentCard(
      {super.key, required this.themeProvider, required this.userName, required this.userId, required this.content, required this.timestamp, this.randomColor = Colors.blue});

  Color generateRandomBlueColor() {
    Random random = Random();
    // Generate random values for red and green components
    int red = random.nextInt(180);
    int green = random.nextInt(180);
    // Blue component set to maximum value for a shade of blue
    int blue = 255;
    // Create Color object with the generated values
    return Color.fromRGBO(red, green, blue, 1);
  }

  @override
  Widget build(BuildContext context) {
    randomColor = generateRandomBlueColor();
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    bool isMyComment = userId == signInProvider.currentUser!.uid;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: themeProvider.cCardDrawer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: isMyComment ? Border.all(color: randomColor, width: 1) : Border.all(color: Colors.transparent, width: 0)
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Timestamp ----------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: randomColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontFamily: 'nunito',
                          color: randomColor,
                          fontSize: 14,
                          fontVariations: const [
                            FontVariation('wght', 700),
                          ],
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content ----------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                content,
                style: themeProvider.tTextNormal,
              ),
            ),
            Text(
              Utils.timestampToDate(timestamp),
              style: themeProvider.tTextSmall,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
