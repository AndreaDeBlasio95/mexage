import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container_new.dart';
import 'package:mexage/custom_widgets/message_received_response_view.dart';
import 'package:mexage/models/message_model.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as Rive;

import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../theme/custom_themes.dart';
import '../views/home_view.dart';

class RiveAnimationBottle extends StatefulWidget {
  final String userId;

  const RiveAnimationBottle({super.key, required this.userId});

  @override
  State<RiveAnimationBottle> createState() => _RiveAnimationBottleState();
}

class _RiveAnimationBottleState extends State<RiveAnimationBottle> {
  late Rive.SimpleAnimation _controller;
  int _animationIndex = 0; // Track the current animation index
  bool _isAnimationComplete =
  true; // Track if the current animation is complete
  Message? _nextMessage;
  bool _isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    // Initialize with the first animation
    _controller = Rive.SimpleAnimation('1 - Idle');
    _controller.isActiveChanged.addListener(_checkAnimationComplete);
    _fetchData(); // Fetch data synchronously or simulate it
  }

  Future<void> _fetchData() async {
    // Asynchronously fetch data
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    try {
      Message? message = await messageProvider.getNextMessage(widget.userId, 0, null);
      if (mounted) {
        setState(() {
          _nextMessage = message;
          _isLoading = false; // Update loading state synchronously
          if (_nextMessage != null) {
            print("Message Content: ${_nextMessage!.content}");
          } else {
            print("No message found");
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Even on error, update loading state
          print("Failed to fetch message: $e");
        });
      }
    }
  }

  void _checkAnimationComplete() {
    // When the animation is not active, consider it complete
    if (!_controller.isActive) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isAnimationComplete = true;
        });
      });
    }
  }

  void _toggleAnimation() {
    if (_isAnimationComplete) {
      setState(() {
        _isAnimationComplete = false; // Reset the completion flag
        // Increment the animation index with each tap
        if (_animationIndex < 8) {
          _animationIndex++;
        }

        // Determine the animation based on the current index
        switch (_animationIndex) {
          case 0:
            _controller = Rive.SimpleAnimation('1 - Idle');
            break;
          case 1:
            _controller = Rive.SimpleAnimation('2 - Solo Bottle');
            break;
          case 2:
            _controller = Rive.SimpleAnimation('3-1 - Open Bottle');
            break;
          case 3:
            _controller = Rive.SimpleAnimation('3-2 - Open Bottle');
            break;
          case 4:
            _controller = Rive.SimpleAnimation('3-3 - Open Bottle');
            break;
          case 5:
            _controller = Rive.SimpleAnimation('3-4 - Open Bottle');
            break;
          case 6:
            _controller = Rive.SimpleAnimation('3-5 - Open Bottle');
            break;
          case 7:
            _controller = Rive.SimpleAnimation('4 - Open Parchment');
            break;
          case 8:
            print("8");
            /*
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MessageView(userIdOriginalMessage: userIdOriginalMessage, collectionReference: collectionReference, message: message, themeProvider: themeProvider, originalMessageId: originalMessageId, isLiked: isLiked, userId: userId),
            ));

             */
            break;
        }

        // Attach the listener to the new controller
        _controller.isActiveChanged.addListener(_checkAnimationComplete);
      });
    }
  }

  Future<void> _goHome() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const HomeView(initialIndex: 2), // Setting initial index to 2
      ),
    );
  }

  @override
  void dispose() {
    _controller.isActiveChanged.removeListener(_checkAnimationComplete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);

    return (_animationIndex >= 8 && !_isAnimationComplete)
        ? Container(child: _nextMessage != null ? _buildGetNextMessage(
        _nextMessage, themeProvider, signInProvider) : _buildGoHome(themeProvider))
        : Container(
        margin:
        EdgeInsets.only(top: MediaQuery
            .of(context)
            .size
            .height * 0.2),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: _toggleAnimation, // Change animation on tap
          child: Column(
            children: [
              const Text(
                "Tap the Bottle!",
                style: TextStyle(
                  fontFamily: 'nunito',
                  color: Color(0xFF141F23),
                  fontSize: 22,
                  fontVariations: [
                    FontVariation('wght', 700),
                  ],
                ),
              ),
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
              ),
              Container(
                height: 400,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Stack(
                  children: [
                    Rive.RiveAnimation.asset(
                      "animations/animation.riv",
                      artboard: 'New Artboard',
                      controllers: [
                        _controller
                      ], // Provide the current controller
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white.withOpacity(1),
                              // You can adjust the opacity here
                              Colors.white.withOpacity(0),
                              // You can adjust the opacity here
                            ],
                            stops: const [0.0, 0.5],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildGetNextMessageFuture() {
    final messageProvider =
    Provider.of<MessageProvider>(context, listen: false);
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);

    return FutureBuilder<Message?>(
      future: messageProvider.getNextMessage(widget.userId, 0, null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the result
          return Container();
        } else if (snapshot.hasData) {
          // Use the fetched message data
          Message? message = snapshot.data;
          return _buildGetNextMessage(message, themeProvider, signInProvider);
        } else if (snapshot.hasError) {
          // Handle error state
          return Text('Error: ${snapshot.error}');
        } else {
          // No data received
          return Container(
            width: double.infinity,
            margin:
            EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No Messages Found!",
                  style: themeProvider.tTextGrey,
                ),
                const SizedBox(height: 32),
                AnimatedCartoonContainerNew(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text("Go Back", style: themeProvider.tTextCard),
                  ),
                  callbackFunction: _goHome,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildGetNextMessage(Message? message, CustomThemes themeProvider,
      SignInProvider signInProvider) {
    //int countTap = 0;
    //if (message != null && countTap == 0) {
    return MessageReceivedResponseView(
      userIdOriginalMessage: message!.userId,
      collectionReference: "random",
      message: message.content,
      themeProvider: themeProvider,
      originalMessageId: message.id,
      isLiked: false,
      userId: signInProvider.currentUser!.uid,
    );
  }

  Widget _buildGoHome(CustomThemes themeProvider) {
    return Container(
      width: double.infinity,
      margin:
      EdgeInsets.only(top: MediaQuery
          .of(context)
          .size
          .height * 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "No Messages Found!",
            style: themeProvider.tTextGrey,
          ),
          const SizedBox(height: 32),
          AnimatedCartoonContainerNew(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text("Go Back", style: themeProvider.tTextCard),
            ),
            callbackFunction: _goHome,
          ),
        ],
      ),
    );
  }
}
