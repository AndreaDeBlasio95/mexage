import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/message_card_board.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';

class BoardMessagesList extends StatelessWidget {
  const BoardMessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomThemes>(builder: (context, themeProvider, _) {
      return FutureBuilder<List<Message>>(
        future:
            Provider.of<MessageProvider>(context).getCountryTrendingMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display shimmer effect while loading
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            // Handle error case
            return Container(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Handle case when there are no messages
            return Container(
              child: Text('No messages available'),
            );
          } else {
            // Display list of messages
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Message message = snapshot.data![index];
                return MessageCardBoard(message: message);
              },
            );
          }
        },
      );
    });
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
