import 'package:flutter/material.dart';
import '../theme/custom_themes.dart';

class MessageView extends StatefulWidget {
  final String message;
  final CustomThemes themeProvider;

  const MessageView({
    Key? key,
    required this.message,
    required this.themeProvider,
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
      appBar: AppBar(
        title: Text('Message', style: widget.themeProvider.tTextBoldMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Text(
                  widget.message,
                  style: widget.themeProvider.tTextNormal,
                ),
              ),
              const SizedBox(height: 32),
              !_isToggleAnimation ? Container(
                child: Text(
                  "Like to leave a comment",
                  style: widget.themeProvider.tTextNormal,
                ),
              ) : Container(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _isToggleAnimation
                      ? AnimatedBuilder(
                          animation: _animationControllerLike,
                          builder: (context, child) {
                            if (_isLiked) {
                              return Transform.translate(
                                offset:
                                    Offset( 50 * _dislikeAnimation.value, -100.0 * _likeAnimation.value),
                                child: Opacity(
                                  opacity: 1 - _likeAnimation.value,
                                  child: Icon(
                                    Icons.thumb_up_alt_rounded,
                                    color:
                                        widget.themeProvider.cCardMessageInbox,
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
                                offset:
                                    Offset(0 * _dislikeAnimation.value, 100.0 * _dislikeAnimation.value),
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
              ),
              const SizedBox(height: 24),
              _isLiked
                  ? TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your comment',
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Container(),
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
