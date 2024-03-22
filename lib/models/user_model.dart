import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  String userName;
  int rank;
  int subscriptionType;
  int likes;
  int messagesSent;
  int accountStatus;
  Timestamp timestampLastSentMessage;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.userName = '',
    required this.rank,
    required this.subscriptionType,
    this.likes = 0,
    this.accountStatus = 0,
    required this.messagesSent,
    required this.timestampLastSentMessage,
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
      messagesSent: json['messagesSent'] as int,
      accountStatus: json['accountStatus'] as int,
      timestampLastSentMessage: json['timestampLastSentMessage'] as Timestamp,
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
      'messagesSent': messagesSent,
      'accountStatus': accountStatus,
      'timestampLastSentMessage': timestampLastSentMessage,
    };
  }
}
