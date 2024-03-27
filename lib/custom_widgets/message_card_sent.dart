import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container.dart';
import 'package:mexage/utils/utils.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';

class MessageCardSent extends StatelessWidget {
  final Message message;

  const MessageCardSent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    String timestampToDate = Utils.timestampToDate(message.timestamp);

    return AnimatedCartoonContainer(
      message: message,
      isLiked: false, // todo: change this
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Content ----------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(message.content,
                        style: themeProvider.tTextCard,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: themeProvider.cIcons,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: _buildTrailingLikesWidget(themeProvider),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Timestamp ----------------------------------------------
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(timestampToDate, style: themeProvider.tTextSmall),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingLikesWidget(CustomThemes themeProvider) {
    return Text(
      Utils.formatNumber(message.likes),
      style: TextStyle(
        fontFamily: 'nunito',
        color: themeProvider.cTextNormal,
        fontSize: 14,
        fontVariations: const [
          FontVariation('wght', 800),
        ],
      ),
    );
  }
}
