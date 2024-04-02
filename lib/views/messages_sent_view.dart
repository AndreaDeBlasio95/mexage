import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container_new.dart';
import 'package:mexage/custom_widgets/create_new_message.dart';
import 'package:mexage/custom_widgets/message_card_sent.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/message_model.dart';
import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../theme/custom_themes.dart';

class MessagesSentView extends StatefulWidget {
  const MessagesSentView({super.key});

  @override
  State<MessagesSentView> createState() => _MessagesSentViewState();
}

class _MessagesSentViewState extends State<MessagesSentView> {
  late SignInProvider _signProvider;
  late UserProvider _userProvider;
  late String _userName = "";

  @override
  void initState() {
    super.initState();

    _signProvider = Provider.of<SignInProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    refreshUsername();
  }

  Future<void> refreshUsername() async {
    _userName = await _userProvider.getUserName(
        _signProvider.currentUser!.uid, context);
    setState(() {
      _userName = _userName;
    });
    print(_userName);
  }

  Future<void> sendMessage() async {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await messageProvider.addMessage(
        signInProvider.currentUser!.uid,
        userProvider.userName,
        "Message sent from 'Sent View' by ${userProvider.userName}");
  }

  @override
  void dispose() {
    // Dispose any resources if necessary
    super.dispose();
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
                        return Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Container(
                              child: Text(
                                "It's a bit empty here!\nLet's send your first bottle!",
                                style: themeProvider.tTextNormal,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Image.asset("images/icon-palm.png", height: 250),
                          ],
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
                // Use _userName here
                //_buildFutureCanSendMessage()
              ],
            ),
          ),
          floatingActionButton: _buildFutureCanSendMessage(themeProvider),
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

  Widget _buildFutureCanSendMessage(CustomThemes themeProvider) {
    return _userName != ""
        ? FutureBuilder<bool>(
            future: _userProvider.checkCanSendMessage(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Still loading
                return Container();
              } else if (snapshot.hasError) {
                // If an error occurred
                return Container();
              } else {
                // Data is loaded
                final canSendMessage = snapshot.data ?? false;
                return canSendMessage ? Container(
                  height: 80,
                  width: 80,
                  child: FloatingActionButton(
                    elevation: 10,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      // this button will not work because we use onTap on the AnimatedCartoonContainerNew
                    },
                    child: AnimatedCartoonContainerNew(
                      colorCard: themeProvider.cCardColorToOpen,
                      colorCardOutline: themeProvider.cCardColorToOpenOutline,
                      child: Image.asset(
                        'images/icon-parchment.png',
                        height: 70,
                        width: 70,
                      ),
                      callbackFunction: () async {
                        await sendMessage();
                      },
                    ),
                  ),
                ) : Container();
              }
            },
          )
        : Container();
  }
}
