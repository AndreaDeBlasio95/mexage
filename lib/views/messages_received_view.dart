import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/message_card_received.dart';
import 'package:mexage/custom_widgets/bottle_message.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../custom_widgets/animated_cartoon_container_new.dart';
import '../custom_widgets/new_message_received_screen.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../providers/user_provider.dart';
import '../theme/custom_themes.dart';

class MessagesReceivedView extends StatefulWidget {
  const MessagesReceivedView({super.key});

  @override
  State<MessagesReceivedView> createState() => _MessagesReceivedViewState();
}

class _MessagesReceivedViewState extends State<MessagesReceivedView> {
  late SignInProvider _signProvider;
  late UserProvider _userProvider;
  String _userName = "";

  @override
  void initState() {
    super.initState();

    _signProvider = Provider.of<SignInProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    refreshUsername();
  }

  void refreshUsername() async {
    _userName = await _userProvider.getUserName(
        _signProvider.currentUser!.uid, context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomThemes>(builder: (context, themeProvider, _) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: themeProvider.cBackGround,
          body: Container(
            padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    'Received',
                    style: themeProvider.tTextBoldMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 8),
                _buildUserCanReceiveMessage(themeProvider),
                /*
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
                      return canSendMessage ? const CreateNewMessage() : Container();
                    }
                  },
                ),
                */
              ],
            ),
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

  Widget _buildUserCanReceiveMessage(CustomThemes themeProvider) {
    return FutureBuilder<bool>(
      future: _userProvider.userCanGetMessage(
          _signProvider.currentUser!.uid, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the result
          return Container();
        } else {
          // Handle the result
          if (snapshot.hasError) {
            // Handle error state
            return Text('Error: ${snapshot.error}');
          } else {
            bool canGetMessage = snapshot.data!;
            print(canGetMessage);
            if (canGetMessage) {
              return _buildButtonNewMessage(themeProvider);
            } else {
              // Return an empty container as we're navigating to a new screen
              return _buildMessageReceivedList(themeProvider);
            }
          }
        }
      },
    );
  }

  Widget _buildButtonNewMessage(CustomThemes themeProvider) {
    return GestureDetector(
      onTap: () {
        /*
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewMessageReceivedScreen(
                userId: _signProvider.currentUser!.uid),
          ));
           */
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15, vertical: MediaQuery.of(context).size.height * 0.3),
        child: AnimatedCartoonContainerNew(
          colorCard: themeProvider.cCardColorToOpen,
          colorCardOutline: themeProvider.cCardColorToOpenOutline,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/icon-parchment.png',
                height: 42,
                width: 42,
              ),
              const SizedBox(width: 12),
              Text("New Bottle!", style: themeProvider.tTextCard,),
            ],
          ),
          callbackFunction: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewMessageReceivedScreen(
                  userId: _signProvider.currentUser!.uid),
            ));
          },
        ),
      ),
    );
  }

  Widget _buildMessageReceivedList(CustomThemes themeProvider) {
    return Expanded(
      child: FutureBuilder<List<Message>>(
        future: Provider.of<MessageProvider>(context)
            .getUserMessagesReceived(_signProvider.currentUser!.uid),
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
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  child: Text(
                    "Next message at 07.00 a.m. and 07.00 p.m.",
                    style: themeProvider.tTextNormal,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                //Image.asset("images/icon-palm.png", height: 250),
                RiveAnimationBottle(userId: _signProvider.currentUser!.uid),
              ],
            );
          } else {
            // Display list of messages
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Message message = snapshot.data![index];
                return MessageCardReceived(message: message);
              },
            );
          }
        },
      ),
    );
  }
}
