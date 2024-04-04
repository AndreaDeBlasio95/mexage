import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mexage/custom_widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';
import '../theme/custom_themes.dart';

class CommentReceivedView extends StatefulWidget {
  final String originalMessageId;
  final String userId;
  final CustomThemes themeProvider;

  const CommentReceivedView(
      {super.key,
        required this.originalMessageId,
        required this.userId,
        required this.themeProvider});

  @override
  _CommentReceivedViewState createState() => _CommentReceivedViewState();
}

class _CommentReceivedViewState extends State<CommentReceivedView> {
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _comments = [];
  bool _isLoading = false;
  bool _hasMore = true;
  late MessageProvider? messageProvider =
  Provider.of<MessageProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    messageProvider = Provider.of<MessageProvider>(context, listen: false);
    _loadInitialComments();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitialComments() async {
    if (messageProvider == null) return;
    _isLoading = true;
    List<DocumentSnapshot> newComments =
    await messageProvider!.fetchCommentFromRandom(
      widget.originalMessageId,
      widget.userId,
    );
    setState(() {
      _comments = newComments;
      _isLoading = false;
    });
  }

  void _loadMoreComments() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    List<DocumentSnapshot> newComments = await messageProvider!
        .fetchCommentsFromTrending(widget.originalMessageId, widget.userId,
        startAfter: _comments.last);
    setState(() {
      _comments.addAll(newComments);
      _isLoading = false;
      if (newComments.length < 10) {
        _hasMore = false; // Assumes fetch limit is 10
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          if (_comments.isEmpty || _comments[index]['content'] == "") {
            return const SizedBox(
              height: 1,
            );
          }
          return CommentCard(
              themeProvider: widget.themeProvider,
              userName: _comments[index]['userName'],
              userId: _comments[index]['userId'],
              content: _comments[index]['content'],
              timestamp: _comments[index]['timestamp']);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
