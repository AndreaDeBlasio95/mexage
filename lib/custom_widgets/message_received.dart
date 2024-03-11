import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../theme/custom_themes.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Card(
      elevation: 0,
      color: themeProvider.cCardMessageInbox,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        title: Text(message.content,
            style: themeProvider.tTextNormal, overflow: TextOverflow.ellipsis),
        trailing: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: themeProvider.cCardMessageInbox,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 50,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrailingWidget(),
            ],
          ),
        ),
        onTap: () {
          // Handle tapping on the message card
          // For example, navigate to a detailed view
        },
      ),
    );
  }

  Widget _buildTrailingWidget() {
    if (message.thumbUp == 0) {
      return Icon(Icons.thumb_up_alt_outlined, color: Colors.grey.shade500);
    }
    if (message.thumbUp == 1) {
      return Icon(Icons.thumb_up_alt_rounded, color: Colors.grey.shade500);
    }
    if (message.thumbUp == 2) {
      return Icon(Icons.thumb_down, color: Colors.grey.shade500);
    }
    return const SizedBox();
  }
}
