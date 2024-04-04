import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/message_received_response_view.dart';
import 'package:provider/provider.dart';

import '../models/message_model.dart';
import '../theme/custom_themes.dart';
import '../views/message_view.dart';

class AnimatedCartoonContainer extends StatefulWidget {
  final Widget child;
  final int type; // 1 = Received, 2 = Sent, 3 = Board
  final String collectionReference;
  final Message message;
  final bool isLiked;
  final bool? receivedMessage;
  final Color? colorCard;
  final Color? colorCardOutline;

  const AnimatedCartoonContainer({super.key, required this.collectionReference, required this.type, required this.child, required this.message, required this.isLiked, this.receivedMessage, this.colorCard, this.colorCardOutline});

  @override
  _AnimatedCartoonContainerState createState() => _AnimatedCartoonContainerState();
}

class _AnimatedCartoonContainerState extends State<AnimatedCartoonContainer> {
  bool _isPressed = false;
  final double _shadowSize = 6.0;
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  widget.receivedMessage! == true ? MessageReceivedResponseView(
                      userIdOriginalMessage: widget.message.userId,
                      collectionReference: widget.collectionReference,
                      originalMessageId: widget.message.id,
                      userId: widget.message.userId,
                      message: widget.message.content,
                      isLiked: widget.isLiked,
                      themeProvider: themeProvider)
                      : MessageView(
                    type: widget.type,
                    userIdOriginalMessage: widget.message.userId,
                      collectionReference: widget.collectionReference,
                      originalMessageId: widget.message.id,
                      userId: widget.message.userId,
                      message: widget.message.content,
                      isLiked: widget.isLiked,
                      themeProvider: themeProvider),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn, // Bounce-in curve
                    ),
                  ),
                  child: child,
                );
              },
              transitionDuration:
              Duration(milliseconds: 500), // Adjust duration as needed
            ),
          );
        },
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          curve: Curves.ease,
          margin: EdgeInsets.only(bottom: _isPressed ? 0 : _shadowSize, top: _isPressed ? _shadowSize : 0,),
          decoration: BoxDecoration(
            color: widget.colorCardOutline ?? themeProvider.cCardColorToOpenOutline,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.ease,
            padding: EdgeInsets.only(bottom: _isPressed ? _shadowSize : 0),
            margin: EdgeInsets.only(bottom: _isPressed ? 0 : _shadowSize),
            decoration: BoxDecoration(
              color: widget.colorCard ?? themeProvider.cCardColorToOpen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}