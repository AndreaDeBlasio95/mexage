class UserModel {
  final String uid;
  String displayName;
  final String email;
  int rank;
  int subscriptionType;
  int likes;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.rank,
    required this.subscriptionType,
    this.likes = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      rank: json['rank'] as int,
      subscriptionType: json['subscriptionType'] as int,
      likes: json['likes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'rank': rank,
      'subscriptionType': subscriptionType,
      'thumbUp': likes,
    };
  }
}
