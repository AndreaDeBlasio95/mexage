import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/custom_snack_bar.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:mexage/views/comments_view.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';

class MessageView extends StatefulWidget {
  final String originalMessageId;
  final String userId;
  final String message;
  final CustomThemes themeProvider;

  const MessageView({
    Key? key,
    required this.message,
    required this.themeProvider,
    required this.originalMessageId,
    required this.userId,
  }) : super(key: key);

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
    bool _canSubmit = false;
    bool _isSubmitted = false;
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
    return Scaffold(
      backgroundColor: widget.themeProvider.cBackGround,
      appBar: AppBar(
        title: Text('Message', style: widget.themeProvider.tTextBoldMedium),
        backgroundColor: widget.themeProvider.cBackGround,
        iconTheme: IconThemeData(color: widget.themeProvider.cTextNormal),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              _isToggleAnimation
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Text(
                        widget.message,
                        style: widget.themeProvider.tTextNormal,
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Text(
                        widget.message,
                        style: widget.themeProvider.tTextNormal,
                      ),
                    ),
              const SizedBox(height: 32),
              !_isToggleAnimation
                  ? Container(
                      child: Text(
                        "Like to leave a comment",
                        style: widget.themeProvider.tTextNormal,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 32),
              !_isSubmitted
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _isToggleAnimation
                            ? AnimatedBuilder(
                                animation: _animationControllerLike,
                                builder: (context, child) {
                                  if (_isLiked) {
                                    return Transform.translate(
                                      offset: Offset(
                                          50 * _dislikeAnimation.value,
                                          -100.0 * _likeAnimation.value),
                                      child: Opacity(
                                        opacity: 1 - _likeAnimation.value,
                                        child: Icon(
                                          Icons.thumb_up_alt_rounded,
                                          color: widget
                                              .themeProvider.cCardMessageInbox,
                                          size: 36,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isToggleAnimation = true;
                                    _isLiked = true;
                                  });
                                  _animateThumbUp();
                                },
                                child: Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: widget.themeProvider.cTextNormal,
                                  size: 36,
                                ),
                              ),
                        _isToggleAnimation
                            ? AnimatedBuilder(
                                animation: _animationControllerDislike,
                                builder: (context, child) {
                                  if (!_isLiked) {
                                    return Transform.translate(
                                      offset: Offset(
                                          0 * _dislikeAnimation.value,
                                          100.0 * _dislikeAnimation.value),
                                      child: Opacity(
                                        opacity: 1 - _dislikeAnimation.value,
                                        child: Icon(
                                          Icons.thumb_down,
                                          color: widget.themeProvider.cRed,
                                          size: 36,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isToggleAnimation = true;
                                    _isLiked = false;
                                  });
                                  _animateThumbDown();
                                },
                                child: Icon(
                                  Icons.thumb_down_off_alt_outlined,
                                  color: widget.themeProvider.cTextDisabled,
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
                            hintStyle: widget.themeProvider.tTextDisabled,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.themeProvider
                                      .cTextDisabled), // Underline color
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.themeProvider
                                      .cCardMessageInbox), // Focused underline color
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
                                    TextSelection.collapsed(offset: 200);
                                _charCount = 200;
                              }
                              if (_charCount >= 50 && _charCount <= 200) {
                                _canSubmit = true;
                              } else {
                                _canSubmit = false;
                              }
                            });
                          },
                          maxLines: null,
                          style: widget.themeProvider.tTextNormal, // Text color
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
                        style: widget.themeProvider.tTextCommentBold,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 12),
              !_isSubmitted
                  ? _canSubmit
                      ? ElevatedButton(
                          onPressed: () async {
                            final messageProvider =
                                Provider.of<MessageProvider>(context,
                                    listen: false);
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            await messageProvider.addComment(
                                widget.userId,
                                userProvider.userName,
                                _textEditingController.text,
                                widget.originalMessageId);
                            if (mounted) {
                              CustomSnackBar.showSnackbar(context,
                                  'Message Sent', widget.themeProvider);
                              setState(() {
                                _isSubmitted = true;
                              });
                              _textEditingController.clear();
                            }
                          },
                          child: Text('Submit'),
                        )
                      : Container()
                  : CommentsView(
                      originalMessageId: widget.originalMessageId,
                      userId: widget.userId,
                      themeProvider: widget.themeProvider),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  void _animateThumbUp() {
    _animationControllerLike.reset();
    _animationControllerLike.forward();
  }

  void _animateThumbDown() {
    _animationControllerDislike.reset();
    _animationControllerDislike.forward();
  }
}
