class UserModel {
  final String uid;
  final String displayName;
  final String email;
  String userName;
  int rank;
  int subscriptionType;
  int likes;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.userName = '',
    required this.rank,
    required this.subscriptionType,
    this.likes = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      userName: json['userName'] as String,
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
      'userName': userName,
      'rank': rank,
      'subscriptionType': subscriptionType,
      'likes': likes,
    };
  }
}
