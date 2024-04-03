import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mexage/models/message_model.dart';
import 'package:mexage/views/message_view.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../providers/message_provider.dart';

class RiveAnimationBottle extends StatefulWidget {
  final String userId;

  const RiveAnimationBottle({super.key, required this.userId});

  @override
  State<RiveAnimationBottle> createState() =>
      _RiveAnimationBottleState();
}

class _RiveAnimationBottleState extends State<RiveAnimationBottle> {
  late SimpleAnimation _controller;
  int _animationIndex = 0; // Track the current animation index
  bool _isAnimationComplete = true; // Track if the current animation is complete

  @override
  void initState() {
    super.initState();
    // Initialize with the first animation
    _controller = SimpleAnimation('1 - Idle');
    _controller.isActiveChanged.addListener(_checkAnimationComplete);
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
        _animationIndex++;

        // Determine the animation based on the current index
        switch (_animationIndex) {
          case 0:
            _controller = SimpleAnimation('1 - Idle');
            break;
          case 1:
            _controller = SimpleAnimation('2 - Solo Bottle');
            break;
          case 2:
            _controller = SimpleAnimation('3-1 - Open Bottle');
            break;
          case 3:
            _controller = SimpleAnimation('3-2 - Open Bottle');
            break;
          case 4:
            _controller = SimpleAnimation('3-3 - Open Bottle');
            break;
          case 5:
            _controller = SimpleAnimation('3-4 - Open Bottle');
            break;
          case 6:
            _controller = SimpleAnimation('3-5 - Open Bottle');
            break;
          case 7:
            _controller = SimpleAnimation('4 - Open Parchment');
            break;
          case 8:
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

  @override
  void dispose() {
    _controller.isActiveChanged.removeListener(_checkAnimationComplete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation, // Change animation on tap
      child: Stack(
        children: [
          _animationIndex < 8 ? Container(
            height: 400,
            width: 400,
            child: RiveAnimation.asset(
              "animations/animation.riv",
              artboard: 'New Artboard',
              controllers: [_controller], // Provide the current controller
              fit: BoxFit.fitWidth,
            ),
          ) : _buildGetNextMessage(),
        ],
      ),
    );
  }

  Widget _buildGetNextMessage() {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);

    return FutureBuilder<Message?>(
      future: messageProvider.getNextMessage(widget.userId, 0, null),
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
            // Use the fetched message data
            Message? message = snapshot.data;
            print(widget.userId);
            if (message != null) {
              // If message is not null, you can use its data
              return Text('Message received: ${message.content}');
            } else {
              // Handle case where no message is received
              return Text('No message received');
            }
          }
        }
      },
    );
  }
}
