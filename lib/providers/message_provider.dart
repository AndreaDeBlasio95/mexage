import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../utils/utils.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----- SETTERS -----
  Future<void> addMessage(
      String _userId, String _userName, String _content) async {
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

  Future<void> addComment(String _userId, String _userName, String _content,
      String _originalMessage) async {
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
      // update likes in original message
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
      // update a collection to know if the user has commented on the message
      await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-comments-board")
          .doc(_originalMessage)
          .set({'commented': true});
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
    Query query = _db
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

  // Receive the message
  Future<Message?> getNextMessage(
      String userId, int limitIteration, DocumentSnapshot? lastDocument) async {
    if (limitIteration >= 10) {
      return null; // Reached iteration limit, exit recursion
    }

    String country = Utils.getUserCountry();
    Query query = _db
        .collection(country)
        .doc('random')
        .collection('messages')
        .orderBy('timestamp')
        .limit(1);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) {
      return null; // No more documents to fetch
    }

    DocumentSnapshot document = querySnapshot.docs.first;
    Message message = Message.fromJson(document.data() as Map<String, dynamic>);

    // Check if the document exists in messages-received collection
    bool documentExists =
        await checkIfDocumentExistsInUserCollection(message.id, userId);
    print("Document exists: $documentExists");

    bool isMyMessage = message.userId == userId;
    print("It's my message $isMyMessage");

    if (documentExists || isMyMessage) {
      print(
          "The message ${message.id} can't be received by $userId because it's their own message");
      // Fetch another message
      return getNextMessage(userId, limitIteration + 1, document);
    } else {
      print("Message: ${message.id} can be received by $userId");
      // Return the message as it is suitable for the user
      // create comment in user
      await _db
          .collection("users")
          .doc(userId)
          .collection("messages-received")
          .doc(message.id)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      return message;
    }
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

  Future<List<Message>> getUserMessagesReceived(String _userId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-received")
          .orderBy("timestamp", descending: true)
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

  Future<bool> checkIfDocumentExistsInUserCollection(
      String _documentId, String _userId) async {
    String _country = Utils.getUserCountry();
    try {
      DocumentSnapshot snapshot = await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-received")
          .doc(_documentId)
          .get();
      return snapshot.exists;
    } catch (e) {
      print("Error checking document existence: $e");
      return false; // Assuming document doesn't exist if there's an error
    }
  }

  Future<bool> checkIfDocumentExists(String _documentId, String _userId) async {
    String _country = Utils.getUserCountry();
    try {
      DocumentSnapshot snapshot = await _db
          .collection("users")
          .doc(_userId)
          .collection("messages-comments-board")
          .doc(_documentId)
          .get();
      return snapshot.exists;
    } catch (e) {
      print("Error checking document existence: $e");
      return false; // Assuming document doesn't exist if there's an error
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
    await copyCollectionTrending(_country);
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

  Future<void> copyCollectionTrending(String _country) async {
    String _getCurrentWeek = Utils.getCurrentWeekYearFormat();
    // Reference to the source collection
    CollectionReference sourceRef =
    _db.collection(_country).doc("trending").collection("messages");

    // Reference to the destination collection
    CollectionReference destinationRef =
    _db.collection(_country).doc(_getCurrentWeek).collection("messages");

    // Check if any documents exist in the source collection
    QuerySnapshot sourceSnapshot = await sourceRef.limit(1).get();
    if (sourceSnapshot.docs.isEmpty) {
      print('Source collection does not exist');
      return null;
    }

    // Get all documents from the source collection
    QuerySnapshot snapshot = await sourceRef.get();

    // Iterate over each document and copy it to the destination collection
    snapshot.docs.forEach((document) async {
      await destinationRef.doc(document.id).set(document.data());
    });

    //await deleteDocuments(sourceRef);
  }

  Future<void> deleteDocuments(CollectionReference collectionRef) async {
    QuerySnapshot snapshot = await collectionRef.get();
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }
}
