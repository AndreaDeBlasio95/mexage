import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../utils/utils.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----- SETTERS -----
  Future<void> addMessage(String _userId, String _userName, String _content) async {
    try {
      String messageId = const Uuid().v4(); // Generate UUID for the message ID
      String _country = Utils.getUserCountry();

      Message message = Message(
        id: messageId,
        userId: _userId,
        userName: _userName,
        content: _content,
        country: _country,
        rank: 0,
        likes: 0,
        dislikes: 0,
        trending: false,
        isComment: false,
        originalMessageId: "",
        timestamp: Timestamp.now(),
      );
      await _db
          .collection(_country)
          .doc("random")
          .collection("messages")
          .doc(messageId)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-sent")
          .doc(messageId)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      await updateSingleValueInUserDocument(
          _userId, "timestampLastSentMessage", Timestamp.now());
      await updateSingleValueInUserDocument(
          _userId, "messagesSent", FieldValue.increment(1));
    } catch (e) {
      print("Error adding message: $e");
    }
  }

  Future<void> addComment(
      String _userId, String _userName, String _content, String _originalMessage) async {
    try {
      String messageId = const Uuid().v4(); // Generate UUID for the message ID
      String _country = Utils.getUserCountry();

      Message message = Message(
        id: messageId,
        userId: _userId,
        userName: _userName,
        content: _content,
        country: _country,
        rank: 0,
        likes: 0,
        dislikes: 0,
        trending: false,
        isComment: true,
        originalMessageId: _originalMessage,
        timestamp: Timestamp.now(),
      );
      // udate likes in original message
      await _db
          .collection(_country)
          .doc("trending")
          .collection("messages")
          .doc(_originalMessage)
          .update({'likes': FieldValue.increment(1)});
      // create comment in trending
      await _db
          .collection(_country)
          .doc("trending")
          .collection("messages")
          .doc(_originalMessage)
          .collection("comments")
          .doc(messageId)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      // create comment in user
      await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-comments")
          .doc(messageId)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      await updateSingleValueInUserDocument(
          _userId, "timestampLastSentMessage", Timestamp.now());
      await updateSingleValueInUserDocument(
          _userId, "messagesSent", FieldValue.increment(1));
    } catch (e) {
      print("Error adding message: $e");
    }
  }

  Future<List<DocumentSnapshot>> fetchCommentsFromTrending(
      String _originalMessageId, String _userId,
      {DocumentSnapshot? startAfter}) async {
    String _country = Utils.getUserCountry();
    Query query = FirebaseFirestore.instance
        .collection(_country)
        .doc("trending")
        .collection("messages")
        .doc(_originalMessageId)
        .collection("comments")
        .orderBy('timestamp')
        .limit(10);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs;
  }

  // ----- UPDATES -----
  Future<void> updateSingleValueInUserDocument(
      String _userId, String _fieldName, dynamic _value) async {
    // Update the value
    await _db.collection("users").doc(_userId).update({
      _fieldName: _value,
      // Specify the field you want to update and the new value
    }).then((_) {
      print('Document successfully updated');
    }).catchError((error) {
      print('Error updating document: $error');
    });
  }

  // ----- GETTERS -----
  Future<List<Message>> getCountryMessages() async {
    String _country = Utils.getUserCountry();
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_country)
          .doc("random")
          .collection("messages")
          .get();
      List<Message> messages = querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return messages;
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }

  Future<List<Message>> getUserMessagesSent(String _userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-sent")
          .get();
      List<Message> messages = querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return messages;
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }

  Future<List<Message>> getCountryTrendingMessages() async {
    String _country = Utils.getUserCountry();
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_country)
          .doc("trending")
          .collection("messages")
          .orderBy('likes', descending: true)
          .get();
      List<Message> messages = querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return messages;
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }

  Future<void> adminSetTopLikedMessages() async {
    String _country = Utils.getUserCountry();
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_country)
          .doc("random")
          .collection("messages")
          .orderBy('likes', descending: true)
          .limit(5)
          .get();

      List<Message> messages = querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      for (Message message in messages) {
        await _db
            .collection(_country)
            .doc("trending")
            .collection("messages")
            .doc(message.id)
            .set(message
                .toJson()); // Use set instead of add to specify the document ID
      }
      print("SET TOP TRENDING");
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }
}
