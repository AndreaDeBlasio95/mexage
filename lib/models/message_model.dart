class Message {
  String id;
  String content;
  int rank;
  bool ranked;
  int thumbUp = 0;

  Message({
    required this.id,
    required this.content,
    required this.rank,
    required this.ranked,
    this.thumbUp = 0,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      rank: json['rank'] as int,
      ranked: json['ranked'] as bool,
      thumbUp: json['thumbUp'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'rank': rank,
      'ranked': ranked,
      'thumbUp': thumbUp,
    };
  }
}
