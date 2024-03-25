import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import '../utils/utils.dart';

class CommentCard extends StatelessWidget {
  final CustomThemes themeProvider;
  final String userName;
  final String content;
  final Timestamp timestamp;
  Color randomColor;

  CommentCard(
      {super.key, required this.themeProvider, required this.userName, required this.content, required this.timestamp, this.randomColor = Colors.blue});

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: themeProvider.cCardDrawer.withOpacity(0.1),
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
