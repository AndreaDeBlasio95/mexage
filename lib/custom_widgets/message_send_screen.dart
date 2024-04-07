import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';
import '../providers/sign_in_provider.dart';
import '../providers/user_provider.dart';
import 'animated_cartoon_container_new.dart';

class MessageSendScreen extends StatefulWidget {
  final CustomThemes themeProvider;
  final Function callbackFunction; // Add this line

  const MessageSendScreen({Key? key, required this.themeProvider, required this.callbackFunction}) : super(key: key);

  @override
  State<MessageSendScreen> createState() => _MessageSendScreenState();
}

class _MessageSendScreenState extends State<MessageSendScreen> {
  late TextEditingController _textEditingController;
  bool _isComposing = false;
  late bool _canSendMessage = false;
  bool _messageSent = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_onTextChanged);
    checkCanSendMessage();
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
    await messageProvider.addMessage(
        signInProvider.currentUser!.uid,
        userProvider.userName,
        _textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Return true to allow pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bottle's message", style: widget.themeProvider.tTextBoldMedium,),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: widget.themeProvider.tTextDisabled, // Customize hint text color
                    focusedBorder: UnderlineInputBorder( // Customize focused border
                      borderSide: BorderSide(color: Colors.grey.shade400), // Customize border color
                    ),
                  ),
                  keyboardType: TextInputType.multiline, // Enable multiline
                  maxLines: null, // Allow unlimited number of lines
                  minLines: 1, // Minimum number of lines to display
                  textInputAction: TextInputAction.done, // Allow newlines
                  style: widget.themeProvider.tTextCard, // Customize text color
                  onSubmitted: _handleSubmitted,
                ),
              ),
              AnimatedCartoonContainerNew(
                colorCard: _isComposing ? widget.themeProvider.cCardColorToOpened : Colors.grey.shade500,
                colorCardOutline:  _isComposing ? widget.themeProvider.cCardColorToOpenedOutline : Colors.grey.shade600,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Send Message', style: widget.themeProvider.tTextCardWhite)),
                callbackFunction: () async {
                  if (_isComposing && _canSendMessage) {
                    _canSendMessage = false;
                    await sendMessage();
                    widget.callbackFunction(); // Call the function
                    if (mounted){
                      Navigator.pop(context);
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
}

