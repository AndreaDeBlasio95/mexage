import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/message_card_sent.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../custom_widgets/message_card_board.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../theme/custom_themes.dart';

class MessagesSent extends StatelessWidget {
  const MessagesSent({super.key});

  @override
  Widget build(BuildContext context) {
    final _signProvider = Provider.of<SignInProvider>(context, listen: false);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    return Consumer<CustomThemes>(builder: (context, themeProvider, _) {
      return Scaffold(
        backgroundColor: themeProvider.cBackGround,
        body: Container(
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  'Sent',
                  style: themeProvider.tTextBoldMedium,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<Message>>(
                  future: Provider.of<MessageProvider>(context)
                      .getUserMessagesSent(_signProvider.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display shimmer effect while loading
                      return _buildShimmerEffect();
                    } else if (snapshot.hasError) {
                      // Handle error case
                      return Container(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      // Handle case when there are no messages
                      return Container(
                        child: const Text('No messages available'),
                      );
                    } else {
                      // Display list of messages
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Message message = snapshot.data![index];
                          return MessageCardSent(message: message);
                        },
                      );
                    }
                  },
                ),
              ),
              FutureBuilder<bool>(
                future: _userProvider.checkCanSendMessage(context),
                builder: (context, snapshot) {
                  // Checking connection state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Still loading
                    return Container();
                  } else if (snapshot.hasError) {
                    // If an error occurred
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Data is loaded
                    final canSendMessage = snapshot.data ?? false;
                    return Text(canSendMessage
                        ? 'You can send a message.'
                        : 'You cannot send a message today.');
                  }
                },
              ),
            ],
          ),
        ),
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
              height: 60.0,
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
