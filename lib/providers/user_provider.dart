import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _userName = "";

  String get userName => _userName;

  Future<void> registerOrGetUser(context) async {
    SignInProvider _user = Provider.of<SignInProvider>(context, listen: false);
    _user = await Provider.of<SignInProvider>(context, listen: false);

    try {
      DocumentSnapshot userSnapshot =
          await _db.collection("users").doc(_user.currentUser!.uid).get();

      if (userSnapshot.exists) {
        // User already exists, retrieve their data
        UserModel existingUser =
            UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
        _userName = existingUser.userName;

        notifyListeners(); // Notify listeners about the change
      } else {
        // create user model
        var _randomValue = Uuid().v4().toString();
        _userName = "castaway-" + _randomValue; // Use Uuid() directly here

        UserModel newUser = createUserModelToSendToFirestore(_user, _userName);
        notifyListeners(); // Notify listeners about the change

        await _db
            .collection("users")
            .doc(_user.currentUser!.uid)
            .set(newUser.toJson());
      }
    } catch (e) {
      // create user model
      var _randomValue = Uuid().v4().toString();
      _userName = "castaway-" + _randomValue; // Use Uuid() directly here

      UserModel newUser = createUserModelToSendToFirestore(_user, _userName);
      notifyListeners(); // Notify listeners about the change

      await _db
          .collection("users")
          .doc(_user.currentUser!.uid)
          .set(newUser.toJson());
    }
  }

  UserModel createUserModelToSendToFirestore(
      SignInProvider _user, String _userName) {
    UserModel newUser = UserModel(
      uid: _user.currentUser!.uid,
      displayName: _user.currentUser!.displayName ?? '',
      email: _user.currentUser!.email ?? '',
      userName: _userName,
      rank: 0,
      subscriptionType: 0,
      likes: 0,
      messagesSent: 0,
      timestampLastSentMessage: Timestamp.now(),
    );
    return newUser;
  }

  Future<UserModel> getUser(String uid) async {
    try {
      // Get user data from Firestore
      DocumentSnapshot userSnapshot =
          await _db.collection("users").doc(uid).get();
      if (userSnapshot.exists) {
        // User exists, convert data to UserModel and return
        return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
      } else {
        // User doesn't exist
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error getting user: $e');
      // Optionally, you can throw an error or handle it differently based on your requirements
      throw e;
    }
  }

  Future<void> updateUser(UserModel user, String collectionPath) async {
    try {
      // Update user data in Firestore
      await _db.collection(collectionPath).doc(user.uid).update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      // Optionally, you can throw an error or handle it differently based on your requirements
      throw e;
    }
  }

  Future<void> deleteUser(String uid, String collectionPath) async {
    try {
      // Delete user data from Firestore
      await _db.collection(collectionPath).doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
      // Optionally, you can throw an error or handle it differently based on your requirements
      throw e;
    }
  }
}
