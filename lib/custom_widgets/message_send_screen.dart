import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../providers/user_provider.dart';
import 'animated_cartoon_container_new.dart';

class MessageSendScreen extends StatefulWidget {
  final CustomThemes themeProvider;
  final Function callbackFunction; // Add this line

  const MessageSendScreen(
      {Key? key, required this.themeProvider, required this.callbackFunction})
      : super(key: key);

  @override
  State<MessageSendScreen> createState() => _MessageSendScreenState();
}

class _MessageSendScreenState extends State<MessageSendScreen> {
  late TextEditingController _textEditingController;
  bool _isComposing = false;
  late bool _canSendMessage = false;
  bool _messageSent = false;

  // animation
  bool isVisibleAnimation = true;
  late SimpleAnimation _controller;
  int _animationIndex = 0; // Track the current animation index
  bool _isAnimationComplete =
      true; // Track if the current animation is complete

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_onTextChanged);
    checkCanSendMessage();
    _controller = SimpleAnimation('1 - Open Parchment');
    _controller.isActiveChanged.addListener(_checkAnimationComplete);
    _startAnimation();
  }

  void _startAnimation() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationIndex = 0;
      _controller.isActive = true;
      isVisibleAnimation = true;
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        isVisibleAnimation = false;
      });
    });
  }

  void _endingAnimation() async {
    setState(() {
      _toggleAnimation();
      //_controller.isActive = true;
      isVisibleAnimation = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _toggleAnimation();
      });
    });
    Future.delayed(const Duration(milliseconds: 5000), () {
      widget.callbackFunction(); // Call the function
      if (mounted) {
        Navigator.pop(context);
      }
    });
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

  void _onTextChanged() {
    setState(() {
      _isComposing = _textEditingController.text.isNotEmpty;
    });
  }

  void _handleSubmitted(String text) {
    // You can handle sending the message here.
    print('Message sent: $text');
    // Clear text field after sending message
    //_textEditingController.clear();
    //setState(() {
    //  _isComposing = false;
    //});
  }

  // Function to close the keyboard externally
  void closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> checkCanSendMessage() async {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final canSendMessage = await _userProvider.checkCanSendMessage(context);
    setState(() {
      _canSendMessage = canSendMessage;
    });
  }

  Future<void> sendMessage() async {
    _messageSent = true;
    closeKeyboard();
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await messageProvider.addMessage(signInProvider.currentUser!.uid,
        userProvider.userName, _textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _controller.isActiveChanged.removeListener(_checkAnimationComplete);
    super.dispose();
  }

  void _toggleAnimation() {
    if (_isAnimationComplete) {
      setState(() {
        _isAnimationComplete = false; // Reset the completion flag
        // Increment the animation index with each tap
        if (_animationIndex < 2) {
          _animationIndex++;
        }

        // Determine the animation based on the current index
        switch (_animationIndex) {
          case 0:
            _controller = SimpleAnimation('1 - Open Parchment');
            break;
          case 1:
            _controller = SimpleAnimation('2 - Close Parchment');
            break;
          case 2:
            _controller = SimpleAnimation('3 - Send Message');
            break;
        }

        // Attach the listener to the new controller
        _controller.isActiveChanged.addListener(_checkAnimationComplete);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Return true to allow pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Bottle's message",
            style: widget.themeProvider.tTextBoldMedium,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              isVisibleAnimation
                  ? _buildAnimatedContainer(_controller)
                  : Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: widget.themeProvider.tTextDisabled,
                          // Customize hint text color
                          focusedBorder: UnderlineInputBorder(
                            // Customize focused border
                            borderSide: BorderSide(
                                color: Colors
                                    .grey.shade400), // Customize border color
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        // Enable multiline
                        maxLines: null,
                        // Allow unlimited number of lines
                        minLines: 1,
                        // Minimum number of lines to display
                        textInputAction: TextInputAction.done,
                        // Allow newlines
                        style: widget.themeProvider.tTextCard,
                        // Customize text color
                        onSubmitted: _handleSubmitted,
                      ),
                    ),
              isVisibleAnimation ? Container () : AnimatedCartoonContainerNew(
                colorCard: _isComposing
                    ? widget.themeProvider.cCardColorToOpened
                    : Colors.grey.shade500,
                colorCardOutline: _isComposing
                    ? widget.themeProvider.cCardColorToOpenedOutline
                    : Colors.grey.shade600,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text('Send Message',
                        style: widget.themeProvider.tTextCardWhite)),
                callbackFunction: () async {
                  if (_isComposing && _canSendMessage) {
                    _canSendMessage = false;
                    await sendMessage();
                    //widget.callbackFunction(); // Call the function
                    if (mounted) {
                      //Navigator.pop(context);
                      _endingAnimation();
                    }
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(SimpleAnimation controller) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: RiveAnimation.asset(
          'animations/animation_send_message.riv',
          artboard: 'New Artboard',
          controllers: [controller],
          fit: BoxFit.fitWidth,
      ),
    );
  }
}
