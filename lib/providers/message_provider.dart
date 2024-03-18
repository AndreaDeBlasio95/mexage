import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../utils/utils.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMessage(String _userId, String _content, Timestamp _timestamp) async {
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
        timestamp: _timestamp,
      );
      await _db.collection(_country).doc(messageId).set(message.toJson()); // Use set instead of add to specify the document ID
    } catch (e) {
      print("Error adding message: $e");
    }
  }

  Future<List<Message>> getMessages() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('IT').get();
      print("QuerySnapshot: $querySnapshot");
      List<Message> messages = querySnapshot.docs.map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return messages;
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error accordingly
      throw e;
    }
  }

}
