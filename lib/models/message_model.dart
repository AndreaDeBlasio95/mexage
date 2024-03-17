import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  bool trending;
  final String id;
  final String content;
  int rank;
  int likes;
  int dislikes;
  final Timestamp timestamp;

  Message({
    this.trending = false,
    required this.id,
    required this.content,
    required this.rank,
    this.likes = 0,
    this.dislikes = 0,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      trending: json['trending'] as bool,
      id: json['id'] as String,
      content: json['content'] as String,
      rank: json['rank'] as int,
      likes: json['likes'] as int,
      dislikes: json['dislikes'] as int,
      timestamp: json['timestamp'] as Timestamp,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'trending': trending,
      'id': id,
      'content': content,
      'rank': rank,
      'likes': likes,
      'dislikes': dislikes,
      'timestamp': timestamp,
    };
  }
}
