import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/message_model.dart';
import '../utils/utils.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //bool _refreshFunction = false;

  //bool get refreshFunction => _refreshFunction;

  // ----- REFRESH from the board card to the board view -----
  Future<void> refreshData(String _documentId, String _userId) async {
    //_refreshFunction = !_refreshFunction;
    checkIfDocumentExistsInUserCollection(_documentId, _userId);
    print("Refreshed Data");
    notifyListeners();
  }

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
          .collection(_country)
          .doc("users")
          .collection("users-active")
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
      String _userIdOriginalMessage,
      String _collectionReference,
      String _userId,
      String _userName,
      String _content,
      String _originalMessage,
      int _commentType,
      bool _isLikedOrDislike) async {
    // _commentType 0 = dislike skipped, 1 = dislike commented, 2 = like skipped, 3 = like commented
    // _collectionReference = "trending" or "random"
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
      String booleanField = "";
      if (_isLikedOrDislike) {
        booleanField = "likes";
      } else {
        booleanField = "dislikes";
      }
      // UPDATING GLOBAL COLLECTION: TRENDING OR RANDOM
      // update likes and rank in original message
      await _db
          .collection(_country)
          .doc(_collectionReference)
          .collection("messages")
          .doc(_originalMessage)
          .update({
        booleanField: FieldValue.increment(1),
        "rank": FieldValue.increment(_commentType)
      });
      // ------------------------------------------------
      // UPDATING USER ORIGINAL MESSAGE
      // update user message sent
      await _db
          .collection(_country)
          .doc("users")
          .collection("users-active")
          .doc(_userIdOriginalMessage)
          .collection("messages-sent")
          .doc(_originalMessage)
          .collection("comments")
          .doc(messageId)
          .set(message.toJson());
      // update user message sent
      await _db
          .collection(_country)
          .doc("users")
          .collection("users-active")
          .doc(_userIdOriginalMessage)
          .collection("messages-sent")
          .doc(_originalMessage)
          .update({
        booleanField: FieldValue.increment(1),
        "rank": FieldValue.increment(_commentType)
      });
      // create comment in trending or random collection
      await _db
          .collection(_country)
          .doc(_collectionReference)
          .collection("messages")
          .doc(_originalMessage)
          .collection("comments")
          .doc(messageId)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      // ------------------------------------------------
      // UPDATING USER RECEIVER COMMENT
      // create comment in user
      if (_collectionReference == "random") {
        await _db
            .collection(_country)
            .doc("users")
            .collection("users-active")
            .doc(_userId)
            .collection("messages-received")
            .doc(_originalMessage)
            .collection("comments")
            .doc(messageId)
            .set(message
            .toJson()); // Use set instead of add to specify the document ID
      }
      // ------------------------------------------------
      // UPDATING TRENDING COLLECTION
      // Only if the addComment is from trending -------------------------------
        await _db
            .collection(_country)
            .doc("users")
            .collection("users-active")
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
        .orderBy("likes", descending: true)
        .orderBy('timestamp')
        .limit(10);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();

    // Check if the comments collection exists
    if (querySnapshot.docs.isEmpty) {
      print("comments collection doesn't exist or is empty");
      return [];
    }

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchCommentFromRandom(
      String _originalMessageId, String _userId,
      {DocumentSnapshot? startAfter}) async {
    String _country = Utils.getUserCountry();
    Query query = _db
        .collection(_country)
        .doc("random")
        .collection("messages")
        .doc(_originalMessageId)
        .collection("comments")
        .orderBy('timestamp', descending: true)
        .limit(10);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();

    // Check if the comments collection exists
    if (querySnapshot.docs.isEmpty) {
      print("comments collection doesn't exist or is empty");
      return [];
    }

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchCommentsMessageSent(
      String _originalMessageId, String _userId,
      {DocumentSnapshot? startAfter}) async {
    String _country = Utils.getUserCountry();
    Query query = _db
        .collection(_country)
        .doc("users")
        .collection("users-active")
        .doc(_userId).collection("messages-sent").doc(_originalMessageId)
        .collection("comments")
        .orderBy('timestamp', descending: true)
        .limit(10);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();

    // Check if the comments collection exists
    if (querySnapshot.docs.isEmpty) {
      print("comments collection doesn't exist or is empty");
      return [];
    }

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
    print("Document exists in user's collection: $documentExists");

    bool isMyMessage;
    if (message.userId == userId) {
      isMyMessage = true;
    } else {
      isMyMessage = false;
    }
    print("It's my message: $isMyMessage");

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
          .collection(country)
          .doc("users")
          .collection("users-active")
          .doc(userId)
          .collection("messages-received")
          .doc(message.id)
          .set(message
              .toJson()); // Use set instead of add to specify the document ID
      updateSingleValueInUserDocument(
          userId, "timestampLastReceivedMessage", Timestamp.now());
      return message;
    }
  }

  // ----- UPDATES -----
  Future<void> updateSingleValueInUserDocument(
      String _userId, String _fieldName, dynamic _value) async {
    String _country = Utils.getUserCountry();
    // Update the value
    await _db
        .collection(_country)
        .doc("users")
        .collection("users-active")
        .doc(_userId)
        .update({
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
    String _country = Utils.getUserCountry();
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_country)
          .doc("users")
          .collection("users-active")
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
    String _country = Utils.getUserCountry();
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(_country)
          .doc("users")
          .collection("users-active")
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
          .collection(_country)
          .doc("users")
          .collection("users-active")
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
          .collection(_country)
          .doc("users")
          .collection("users-active")
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
          .orderBy('rank', descending: true)
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

  /*
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
   */

  Future<void> adminSetTopLikedMessages() async {
    // we can call this once per week:
    String currentWeek = Utils.getCurrentWeekYearFormat();
    // Check if the backup collection exists
    QuerySnapshot _backupCollection = await _db
        .collection("IT")
        .doc(currentWeek)
        .collection("messages")
        .limit(1)
        .get();
    if (_backupCollection.docs.isNotEmpty) {
      print("Backup collection exists, aborting operation.");
      return;
    }

    String _country = Utils.getUserCountry();
    await copyCollectionTrending(_country);

    List<String> collections = ["random-3", "random-2", "random-1", "random"];

    for (String collectionName in collections) {
      try {
        QuerySnapshot querySnapshot = await _db
            .collection(_country)
            .doc(collectionName)
            .collection("messages")
            .orderBy('rank', descending: true)
            .limit(5)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          List<Message> messages = querySnapshot.docs
              .map(
                  (doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          for (Message message in messages) {
            // Set the document in the trending collection
            await _db
                .collection(_country)
                .doc("trending")
                .collection("messages")
                .doc(message.id)
                .set(message.toJson());
            // Delete the document from the current collection
            await _db
                .collection(_country)
                .doc(collectionName)
                .collection("messages")
                .doc(message.id)
                .delete();
          }
          print("SET TOP TRENDING");
          return; // Exit the loop if documents are successfully fetched
        }
      } catch (e) {
        print("Error fetching messages from $collectionName: $e");
        // Handle error accordingly
      }
    }
    print("No documents found in any collection.");
  }

  Future<void> copyCollectionTrending(String _country) async {
    print("Copying collection...");

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
      print('Source collection does not exist, copying reverted!');
      return;
    }

    // Get all documents from the source collection
    QuerySnapshot snapshot = await sourceRef.get();

    // Iterate over each document and copy it to the destination collection
    snapshot.docs.forEach((document) async {
      await destinationRef.doc(document.id).set(document.data());
    });

    await deleteDocuments(sourceRef);
  }

  Future<void> deleteDocuments(CollectionReference collectionRef) async {
    QuerySnapshot snapshot = await collectionRef.get();
    snapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }
}
