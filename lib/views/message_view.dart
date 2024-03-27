import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/custom_snack_bar.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:mexage/views/comments_view.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';

class MessageView extends StatefulWidget {
  final String originalMessageId;
  final String userId;
  final String message;
  final bool isLiked;
  final CustomThemes themeProvider;

  const MessageView({
    super.key,
    required this.message,
    required this.themeProvider,
    required this.originalMessageId,
    required this.isLiked,
    required this.userId,
  });

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late AnimationController _animationControllerLike;
  late AnimationController _animationControllerDislike;
  late Animation<double> _likeAnimation;
  late Animation<double> _dislikeAnimation;
  bool _isToggleAnimation = false;
  bool _isLiked = false;
  int _charCount = 0;
  bool _canSubmit = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _animationControllerLike = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationControllerDislike = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _likeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationControllerLike, curve: Curves.easeInOut),
    );
    _dislikeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationControllerDislike, curve: Curves.easeInOut),
    );

    _charCount = 0;

    if (widget.isLiked) {
      setState(() {
        _isToggleAnimation = true;
        _isSubmitted = true;
        _isLiked = true;
        _canSubmit = true;
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _animationControllerLike.dispose();
    _animationControllerDislike.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        // When navigating back, toggle the flag to call the function
        Provider.of<MessageProvider>(context, listen: false).refreshData(
            widget.originalMessageId, signInProvider.currentUser!.uid);
        return true; // Return true to allow pop
      },
      child: Scaffold(
        backgroundColor: widget.themeProvider.cBackGround,
        appBar: AppBar(
          title: Text('Message', style: widget.themeProvider.tTextBoldMedium),
          backgroundColor: widget.themeProvider.cBackGround,
          iconTheme: IconThemeData(color: widget.themeProvider.cTextNormal),
        ),
        body: SingleChildScrollView(
          child: widget.userId != signInProvider.currentUser!.uid
              ? Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: !widget.isLiked
                      ? Column(
                          children: [
                            // Display the message content
                            _isToggleAnimation
                                ? Container(
                                    width: double.infinity,
                                    child: Text(
                                      widget.message,
                                      style: widget.themeProvider.tTextNormal,
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Text(
                                      widget.message,
                                      style: widget.themeProvider.tTextNormal,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                            const SizedBox(height: 32),
                            // Display the rate message text
                            !_isToggleAnimation
                                ? Container(
                                    child: Text(
                                      "Rate the message",
                                      style: widget.themeProvider.tTextNormal,
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 32),
                            // Display the like and dislike buttons
                            !_isSubmitted
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _isToggleAnimation
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isToggleAnimation = true;
                                                  _isLiked = true;
                                                });
                                              },
                                              child: Icon(
                                                Icons.thumb_up_alt_outlined,
                                                color: widget
                                                    .themeProvider.cTextNormal,
                                                size: 36,
                                              ),
                                            ),
                                      _isToggleAnimation
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isToggleAnimation = true;
                                                  _isLiked = true;
                                                });
                                              },
                                              child: Icon(
                                                Icons
                                                    .thumb_down_off_alt_outlined,
                                                color: widget.themeProvider
                                                    .cTextDisabled,
                                                size: 36,
                                              ),
                                            ),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(height: 24),
                            !_isSubmitted
                                ? _isLiked
                                    ? TextField(
                                        controller: _textEditingController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your text',
                                          hintStyle: widget
                                              .themeProvider.tTextDisabled,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: widget.themeProvider
                                                    .cTextDisabled), // Underline color
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: widget.themeProvider
                                                    .cCardDrawer), // Focused underline color
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _charCount = value.length;
                                            if (_charCount > 200) {
                                              // Limit the text to 500 characters
                                              _textEditingController.text =
                                                  _textEditingController.text
                                                      .substring(0, 200);
                                              _textEditingController.selection =
                                                  TextSelection.collapsed(
                                                      offset: 200);
                                              _charCount = 200;
                                            }
                                            if (_charCount >= 0 &&
                                                _charCount <= 200) {
                                              _canSubmit = true;
                                            } else {
                                              _canSubmit = false;
                                            }
                                          });
                                        },
                                        maxLines: null,
                                        style: widget.themeProvider
                                            .tTextNormal, // Text color
                                      )
                                    : Container()
                                : Container(),
                            const SizedBox(height: 12),
                            !_isSubmitted
                                ? _isLiked
                                    ? Text(
                                        'Character count: $_charCount / 200 \nCharacter min: 50 - Character max: 200',
                                        style: widget.themeProvider.tTextSmall,
                                        textAlign: TextAlign.center,
                                      )
                                    : Container()
                                : Container(),
                            const SizedBox(height: 12),
                            _isSubmitted
                                ? Container(
                                    child: Text(
                                      'Comments',
                                      style:
                                          widget.themeProvider.tTextCommentBold,
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 12),
                            !_isSubmitted
                                ? _canSubmit
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              final messageProvider =
                                                  Provider.of<MessageProvider>(
                                                      context,
                                                      listen: false);
                                              final userProvider =
                                                  Provider.of<UserProvider>(
                                                      context,
                                                      listen: false);
                                              final signInProvider =
                                                  Provider.of<SignInProvider>(
                                                      context,
                                                      listen: false);
                                              await messageProvider.addComment(
                                                  signInProvider
                                                      .currentUser!.uid,
                                                  userProvider.userName,
                                                  _textEditingController.text,
                                                  widget.originalMessageId,
                                                  true);
                                              if (mounted) {
                                                CustomSnackBar.showSnackbar(
                                                    context,
                                                    'Message Sent',
                                                    widget.themeProvider);
                                                setState(() {
                                                  _isSubmitted = true;
                                                });
                                                _textEditingController.clear();
                                              }
                                            },
                                            child: Text('Submit'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              _textEditingController.clear();
                                              final messageProvider =
                                                  Provider.of<MessageProvider>(
                                                      context,
                                                      listen: false);
                                              final userProvider =
                                                  Provider.of<UserProvider>(
                                                      context,
                                                      listen: false);
                                              final signInProvider =
                                                  Provider.of<SignInProvider>(
                                                      context,
                                                      listen: false);
                                              await messageProvider.addComment(
                                                  signInProvider
                                                      .currentUser!.uid,
                                                  userProvider.userName,
                                                  _textEditingController.text,
                                                  widget.originalMessageId,
                                                  true);
                                              if (mounted) {
                                                CustomSnackBar.showSnackbar(
                                                    context,
                                                    'Comment Skipped',
                                                    widget.themeProvider);
                                                setState(() {
                                                  _isSubmitted = true;
                                                });
                                              }
                                            },
                                            child: Text('Skip'),
                                          ),
                                        ],
                                      )
                                    : Container()
                                : CommentsView(
                                    originalMessageId: widget.originalMessageId,
                                    userId: widget.userId,
                                    themeProvider: widget.themeProvider),
                            const SizedBox(height: 36),
                          ],
                        )
                      : _buildMessageViewWithoutInteraction())
              : _buildMessageViewWithoutInteraction(),
        ),
      ),
    );
  }

  Widget _buildMessageViewWithoutInteraction() {
    return Column(
      children: [
        Container(
          child: Text(
            widget.message,
            style: widget.themeProvider.tTextNormal,
          ),
        ),
        const SizedBox(height: 32),
        CommentsView(
            originalMessageId: widget.originalMessageId,
            userId: widget.userId,
            themeProvider: widget.themeProvider),
      ],
    );
  }

  void _animateThumbUp() {
    _animationControllerLike.reset();
    _animationControllerLike.forward();
  }

  void _animateThumbDown() async {
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Add empty comment to the message if disliked, this message will not be rendered in the comments_view
    await messageProvider.addComment(signInProvider.currentUser!.uid,
        userProvider.userName, "", widget.originalMessageId, false);
    if (mounted) {
      _animationControllerDislike.reset();
      _animationControllerDislike.forward();
    }
  }
}
