import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/chat/data/models/conversation_model.dart';
import 'package:legwork/Features/chat/data/models/message_model.dart';

/**
 * THIS ABSTRACY CLASS DEFINES WHAT OPERATIONS IT'S IMPLEMENTATION CAN CARRY OUT
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
  Future<Either<String, MessageModel>> sendMessage(
      {required MessageModel message});

  // MARK MESSAGE AS READ
  Future<Either<String, void>> markMessageAsRead({
    required String messageId,
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
    required List<String> participants,
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
      final snapShot = await db
          .collection('conversations')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final conversations = snapShot.docs
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
      final snapShot = await db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .get();

      final messages =
          snapShot.docs.map((doc) => MessageModel.fromDocument(doc)).toList();

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
      // Get conversation ID directly from the parameter
      String conversationId = message.id;
      debugPrint('Sending message to conversation: $conversationId');

      // Create a new message doc without specifiying an ID
      final messageRef = await db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add(message.toMap());

      // Update conversation with the last message info
      await db.collection('conversations').doc(conversationId).update({
        'lastMessage': message.content,
        'lastMessageTime': Timestamp.fromDate(message.timeStamp),
        'lastMessageSenderId': message.senderId,
        'hasUnreadMessages': true,
      });

      // Get the crested message with ID
      final messageDoc = await messageRef.get();
      return Right(MessageModel.fromDocument(messageDoc));
    } catch (e) {
      debugPrint('Error sending message: ${e.toString()}');
      return Left('Error sending message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> markMessageAsRead({
    required String messageId,
  }) async {
    try {
      // MessageId is the actual document ID of the message
      await db
          .collection('conversations')
          .doc(messageId.split('/')[0]) // Get conversation ID from path
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});

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
    required List<String> participants,
  }) async {
    try {
      // Check if conversation already exists
      final existingConversation = await db
          .collection('conversations')
          .where('participants', isEqualTo: participants)
          .get();

      if (existingConversation.docs.isNotEmpty) {
        return Right(
            ConversationModel.fromDocument(existingConversation.docs.first));
      }

      // Create new conversation
      final conversationData = {
        'participants': participants,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
        'lastMessageSenderId': '',
        'hasUnreadMessages': false,
      };

      final docRef = await db.collection('conversations').add(conversationData);
      final docSnapshot = await docRef.get();

      return Right(ConversationModel.fromDocument(docSnapshot));
    } catch (e) {
      debugPrint('Error creating conversation: ${e.toString()}');
      return Left('Error creating conversation: ${e.toString()}');
    }
  }
}
