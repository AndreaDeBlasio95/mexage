import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  bool trending;
  final String id;
  final String userId;
  final String content;
  String country;
  int rank;
  int likes;
  int dislikes;
  bool isComment;
  String originalMessageId;
  final Timestamp timestamp;

  Message({
    this.trending = false,
    required this.id,
    required this.userId,
    required this.content,
    this.country = 'none',
    required this.rank,
    this.likes = 0,
    this.dislikes = 0,
    this.isComment = false,
    this.originalMessageId = '',
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      trending: json['trending'] as bool,
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      country: json['country'] as String,
      rank: json['rank'] as int,
      likes: json['likes'] as int,
      dislikes: json['dislikes'] as int,
      isComment: json['isComment'] as bool,
      originalMessageId: json['originalMessageId'] as String,
      timestamp: json['timestamp'] as Timestamp,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'trending': trending,
      'id': id,
      'userId': userId,
      'content': content,
      'country': country,
      'rank': rank,
      'likes': likes,
      'dislikes': dislikes,
      'isComment': isComment,
      'originalMessageId': originalMessageId,
      'timestamp': timestamp,
    };
  }
}
