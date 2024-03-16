import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerOrGetUser(context) async {
    final SignInProvider _user = Provider.of<SignInProvider>(context, listen: false);

    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection("users").doc(_user.currentUser!.uid).get();

      if (userSnapshot.exists) {
        // User already exists, retrieve their data
        UserModel existingUser = UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
        print(existingUser);
      } else {
        // create user model
        UserModel newUser = createUserModelToSendToFirestore(_user);

        await _firestore
            .collection("users")
            .doc(_user.currentUser!.uid)
            .set(newUser.toJson());
      }
    } catch (e) {
      print('Error registering or getting user: $e');
      // Optionally, you can throw an error or handle it differently based on your requirements
      throw e;
    }
  }

  UserModel createUserModelToSendToFirestore(SignInProvider _user) {
    UserModel newUser = UserModel(
      uid: _user.currentUser!.uid,
      displayName: _user.currentUser!.displayName ?? '',
      email: _user.currentUser!.email ?? '',
      rank: 0,
      subscriptionType: 0,
      likes: 0,
    );
    return newUser;
  }

  Future<UserModel> getUser(String uid, String collectionPath) async {
    try {
      // Get user data from Firestore
      DocumentSnapshot userSnapshot =
      await _firestore.collection(collectionPath).doc(uid).get();

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
      await _firestore
          .collection(collectionPath)
          .doc(user.uid)
          .update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      // Optionally, you can throw an error or handle it differently based on your requirements
      throw e;
    }
  }

  Future<void> deleteUser(String uid, String collectionPath) async {
    try {
      // Delete user data from Firestore
      await _firestore.collection(collectionPath).doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
      // Optionally, you can throw an error or handle it differently based on your requirements
      throw e;
    }
  }
}