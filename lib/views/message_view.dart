import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container_new.dart';
import 'package:mexage/custom_widgets/custom_snack_bar.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:mexage/views/comments_view.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';

class MessageView extends StatefulWidget {
  final int type; // 1 = Sent, 2 = Received, 3 = Board
  final String userIdOriginalMessage;
  final String collectionReference; // random or trending
  final String originalMessageId;
  final String userId;
  final String message;
  final bool isLiked;
  final CustomThemes themeProvider;

  const MessageView({
    super.key,
    required this.type,
    required this.userIdOriginalMessage,
    required this.collectionReference,
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

  bool likeToSentToProvider = false;
  int _commentType = 0;

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
                                                  // pass this into buttons: submit and skip
                                                  likeToSentToProvider = true;
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
                                                  // pass this into buttons: submit and skip
                                                  likeToSentToProvider = false;
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
                                                  const TextSelection.collapsed(
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
                            !_isSubmitted
                                ? _isLiked
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          AnimatedCartoonContainerNew(
                                            child: Container(
                                                width: 120,
                                                padding:
                                                     EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                child: Text(
                                                  'Reply',
                                                  style: widget
                                                      .themeProvider.tTextCardWhite, textAlign: TextAlign.center,
                                                )),
                                            callbackFunction: () async {
                                              await addCommentCallback(true);
                                            },
                                            colorCard: widget.themeProvider
                                                .cCardColorToOpened,
                                            colorCardOutline: widget.themeProvider.cCardColorToOpenedOutline
                                          ),
                                          AnimatedCartoonContainerNew(
                                            child: Container(
                                              width: 120,
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 16),
                                                child: Text(
                                                  'Skip',
                                                  style: widget
                                                      .themeProvider.tTextCard, textAlign: TextAlign.center,
                                                )),
                                            callbackFunction: () async {
                                              await addCommentCallback(false);
                                            },
                                          ),
                                        ],
                                      )
                                    : Container()
                                : CommentsView(
                              type: widget.type,
                                    originalMessageId: widget.originalMessageId,
                                    userId: widget.userId,
                                    originalUserId: widget.userIdOriginalMessage,
                                    themeProvider: widget.themeProvider),
                            const SizedBox(height: 36),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8),
                          child: _buildMessageViewWithoutInteraction()))
              : Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: _buildMessageViewWithoutInteraction()),
        ),
      ),
    );
  }

  Future<void> addCommentCallback(bool _value) async {
    await addComment(_value);
    if (mounted) {
      setState(() {
        _textEditingController.clear();
      });
    }
  }

  Widget _buildMessageViewWithoutInteraction() {
    print('buildMessageViewWithoutInteraction');
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
          type: widget.type,
            originalMessageId: widget.originalMessageId,
            userId: widget.userId,
            originalUserId: widget.userIdOriginalMessage,
            themeProvider: widget.themeProvider),
      ],
    );
  }

  Future<void> addComment(bool _skipOrSubmit) async {
    // providers
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    // handle if skipped or submitted
    if (!_skipOrSubmit) {
      // skip
      setState(() {
        if (!likeToSentToProvider) {
          // disliked and skipped
          _commentType = 0;
          _textEditingController.clear();
        } else {
          // liked and skipped
          _commentType = 2;
          _textEditingController.clear();
        }
      });
      await messageProvider.addComment(
          widget.userIdOriginalMessage,
          widget.collectionReference,
          signInProvider.currentUser!.uid,
          userProvider.userName,
          "",
          widget.originalMessageId,
          _commentType,
          likeToSentToProvider);
      if (mounted) {
        CustomSnackBar.showSnackbar(
            context, 'Comment Skipped', widget.themeProvider);
        setState(() {
          _isSubmitted = true;
        });
      }
    } else {
      // submit
      setState(() {
        if (!likeToSentToProvider) {
          // disliked and commented
          _commentType = 1;
        } else {
          // liked and commented
          _commentType = 3;
        }
      });
      await messageProvider.addComment(
          widget.userIdOriginalMessage,
          widget.collectionReference,
          signInProvider.currentUser!.uid,
          userProvider.userName,
          _textEditingController.text,
          widget.originalMessageId,
          _commentType,
          likeToSentToProvider);
      if (mounted) {
        CustomSnackBar.showSnackbar(
            context, 'Message Sent', widget.themeProvider);
        setState(() {
          _isSubmitted = true;
        });
      }
    }
  }
}
