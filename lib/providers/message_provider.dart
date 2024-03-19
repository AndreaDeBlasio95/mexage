import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../utils/utils.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMessage(String _userId, String _content) async {
    try {
      String messageId = const Uuid().v4(); // Generate UUID for the message ID
      String _country = Utils.getUserCountry();

      Message message = Message(
        id: messageId,
        userId: _userId,
        content: _content,
        country: _country,
        rank: 0,
        likes: 0,
        dislikes: 0,
        trending: false,
        timestamp: Timestamp.now(),
      );
      await _db.collection(_country).doc("random").collection("messages").doc(messageId).set(message.toJson()); // Use set instead of add to specify the document ID
    } catch (e) {
      print("Error adding message: $e");
    }
  }

  Future<List<Message>> getCountryMessages() async {
    String _country = Utils.getUserCountry();
    try {
      QuerySnapshot querySnapshot = await _db.collection(_country).doc("random").collection("messages").get();
      List<Message> messages = querySnapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return messages;
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }

  Future<List<Message>> getUserMessagesSent(String _userId) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection("users").doc(_userId).collection("messages-sent").get();
      List<Message> messages = querySnapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
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
      List<Message> messages = querySnapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
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

      List<Message> messages = querySnapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
      for (Message message in messages) {
        await _db.collection(_country).doc("trending").collection("messages").doc(message.id).set(message.toJson()); // Use set instead of add to specify the document ID
      }
      print("SET TOP TRENDING");
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }

}
