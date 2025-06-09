import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/chat/data/models/conversation_model.dart';
import 'package:legwork/features/chat/data/models/message_model.dart';

/**
 * THIS ABSTRACT CLASS DEFINES WHAT OPERATIONS IT'S IMPLEMENTATION CAN CARRY OUT
 */
abstract class ChatRemoteDataSource {
  // GET CONVERSATIONS FOR A SPECIFIC USER
  Future<Either<String, List<ConversationModel>>> getConversations({
    required String userId,
  });

  // GET MESSAGES FOR A SPECIFIC CONVERSATION
  Future<Either<String, List<MessageModel>>> getMessages({
    required String conversationId,
  });

  // SEND MESSAGE
  Future<Either<String, MessageModel>> sendMessage({
    required MessageModel message,
  });

  // MARK MESSAGE AS READ
  Future<Either<String, void>> markMessageAsRead({
    required MessageModel message,
  });

  // MESSAGE STREAM
  Stream<List<MessageModel>> messageStream({
    required String conversationId,
  });

  // CONVERSATIONS STREAM
  Stream<List<ConversationModel>> conversationsStream({
    required String userId,
  });

  // CREATE CONVERSATION
  Future<Either<String, ConversationModel>> createConversation({
    // required List<String> participants,
    required ConversationModel conversationModel,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // GET CONVERSATIONS FOR A SPECIFIC USER
  @override
  Future<Either<String, List<ConversationModel>>> getConversations({
    required String userId,
  }) async {
    try {
      // Query the db to get the list of convos for user
      final convoSnapshot = await db
          .collection('conversations')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      // Map each convo to Conversation model using the fromDocument method
      final conversations = convoSnapshot.docs
          .map((doc) => ConversationModel.fromDocument(doc))
          .toList();

      return Right(conversations);
    } catch (e) {
      debugPrint('Error getting conversations: ${e.toString()}');
      return left(e.toString());
    }
  }

  // GET MESSAGES FOR A SPECIFIC CONVERSATION
  @override
  Future<Either<String, List<MessageModel>>> getMessages({
    required String conversationId,
  }) async {
    try {
      // Query the db to get the list of messages for a specific convo
      final messagesSnapshot = await db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .get();

      // Map each message to message model using the fromDocument method
      final messages = messagesSnapshot.docs
          .map((doc) => MessageModel.fromDocument(doc))
          .toList();

      return Right(messages);
    } catch (e) {
      debugPrint('Error getting messages: ${e.toString()}');
      return Left('Error getting messages: ${e.toString()}');
    }
  }

  // SEND MESSAGE
  @override
  Future<Either<String, MessageModel>> sendMessage({
    required MessageModel message,
  }) async {
    try {
      // * Get conversation ID directly from the parameter
      String conversationId = message.convoId;
      debugPrint('convo ID: $conversationId');

      /// * Get the conversation's doc ref
      // * go into it's messages collection and generate an ID
      final convoDocRef = db.collection('conversations').doc(conversationId);
      final messageDocId = convoDocRef.collection('messages').doc().id;

      // * Update the message doc with the ID
      final updatedMessageDoc = {
        ...message.toMap(),
        'messageId': messageDocId,
      };

      await db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageDocId)
          .set(updatedMessageDoc);

      // Update conversation with the last message info
      final latestMessageInfo = {
        'lastMessage': message.content,
        'lastMessageTime': Timestamp.fromDate(message.timeStamp),
        'lastMessageSenderId': message.senderId,
        'hasUnreadMessages': true,
      };
      await db
          .collection('conversations')
          .doc(conversationId)
          .update(latestMessageInfo);

      // Get the crested message with ID
      final messageDocRef = db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageDocId);

      final messageDocSnapshot = await messageDocRef.get();
      return Right(MessageModel.fromDocument(messageDocSnapshot));
    } catch (e) {
      debugPrint('Error sending message: ${e.toString()}');
      return Left('Error sending message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> markMessageAsRead({
    required MessageModel message,
  }) async {
    try {
      debugPrint(
        'Marking message as read - ConversationId: ${message.convoId}, MessageId: ${message.messageId}',
      );

      // Update the message's isRead field to true
      await db
          .collection('conversations')
          .doc(message.convoId)
          .collection('messages')
          .doc(message.messageId)
          .update({'isRead': true});

      // Also update the conversation's hasUnreadMessages
      final convoDocRef = db.collection('conversations').doc(message.convoId);
      final convoDoc = await convoDocRef.get();

      if (convoDoc.exists) {
        final messages = await db
            .collection('conversations')
            .doc(message.convoId)
            .collection('messages')
            .where('isRead', isEqualTo: true)
            .get();

        if (messages.docs.isNotEmpty) {
          await convoDocRef.update({'hasUnreadMessages': false});
        }
        debugPrint('Marked message as read: ${message.messageId}');
      }

      return const Right(null);
    } catch (e) {
      debugPrint('Error marking message as read: ${e.toString()}');
      return Left('Error marking message as read: ${e.toString()}');
    }
  }

  @override
  Stream<List<MessageModel>> messageStream({
    required String conversationId,
  }) {
    try {
      debugPrint('Starting message stream for conversation: $conversationId');
      return db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .map((snapshot) {
        final messages =
            snapshot.docs.map((doc) => MessageModel.fromDocument(doc)).toList();
        debugPrint('Received ${messages.length} messages');
        return messages;
      });
    } catch (e) {
      debugPrint('Error with message stream: ${e.toString()}');
      return Stream.value([]);
    }
  }

  @override
  Stream<List<ConversationModel>> conversationsStream({
    required String userId,
  }) {
    try {
      return db
          .collection('conversations')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ConversationModel.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      debugPrint('Error with conversation stream');
      return Stream.value([]);
    }
  }

  @override
  Future<Either<String, ConversationModel>> createConversation({
    // required List<String> participants,
    required ConversationModel conversationModel,
  }) async {
    try {
      // Check if conversation already exists
      final existingConversation = await db
          .collection('conversations')
          .where('participants', isEqualTo: conversationModel.participants)
          .get();

      if (existingConversation.docs.isNotEmpty) {
        return Right(
          ConversationModel.fromDocument(existingConversation.docs.first),
        );
      }

      // Generate unique convo ID
      final String convoId = db.collection('conversations').doc().id;
      debugPrint('Created convo ID: $convoId');

      final updatedConvoData = {
        ...conversationModel.toMap(),
        'convoId': convoId,
      };

      // Save created convo with explicir convoId field
      await db.collection('conversations').doc(convoId).set(updatedConvoData);

      final docSnapshot =
          await db.collection('conversations').doc(convoId).get();
      // final docSnapshot = await docRef.get();

      return Right(ConversationModel.fromDocument(docSnapshot));
    } catch (e) {
      debugPrint('Error creating conversation: ${e.toString()}');
      return Left('Error creating conversation: ${e.toString()}');
    }
  }
}
