import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/network/api_client.dart';
import 'package:legwork/features/chat/data/data_sources/socket.dart';
import 'package:legwork/features/chat/data/models/chat_room_model.dart';
import 'package:legwork/features/chat/data/models/message_model.dart';

final ApiClient apiClient = ApiClient();
final Socket socket = Socket();

/**
 * THIS ABSTRACT CLASS DEFINES WHAT OPERATIONS IT'S IMPLEMENTATION CAN CARRY OUT
 */
abstract class ChatRemoteDataSource {
  // GET CONVERSATIONS FOR A SPECIFIC USER
  Future<Either<String, List<ChatRoomModel>>> getConversations({
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

  // CREATE CONVERSATION
  Future<Either<String, ChatRoomModel>> createConversation({
    required String username,
    required String dancerId,
    required String clientId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // GET CONVERSATIONS FOR A SPECIFIC USER
  @override
  Future<Either<String, List<ChatRoomModel>>> getConversations({
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
          .map((doc) => ChatRoomModel.fromDocument(doc))
          .toList();

      return Right(conversations);
    } catch (e) {
      // debugPrint('Error getting conversations: ${e.toString()}');
      return left(e.toString());
    }
  }

  // GET MESSAGES FOR A SPECIFIC CONVERSATION
  @override
  Future<Either<String, List<MessageModel>>> getMessages({
    required String conversationId,
  }) async {
    throw UnimplementedError();
  }

  // SEND MESSAGE
  @override
  Future<Either<String, MessageModel>> sendMessage({
    required MessageModel message,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, void>> markMessageAsRead({
    required MessageModel message,
  }) async {
    try {
      debugPrint(
        'Marking message as read - ConversationId: ${message.chatRoomId}, MessageId: ${message.messageId}',
      );

      // Update the message's isRead field to true
      await db
          .collection('conversations')
          .doc(message.chatRoomId)
          .collection('messages')
          .doc(message.messageId)
          .update({'isRead': true});

      // Also update the conversation's hasUnreadMessages
      final convoDocRef =
          db.collection('conversations').doc(message.chatRoomId);
      final convoDoc = await convoDocRef.get();

      if (convoDoc.exists) {
        final messages = await db
            .collection('conversations')
            .doc(message.chatRoomId)
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
    // try {
    //   debugPrint('Starting message stream for conversation: $conversationId');
    //   return db
    //       .collection('conversations')
    //       .doc(conversationId)
    //       .collection('messages')
    //       .orderBy('timeStamp', descending: true)
    //       .snapshots()
    //       .map((snapshot) {
    //     final messages =
    //         snapshot.docs.map((doc) => MessageModel.fromDocument(doc)).toList();
    //     return messages;
    //   });
    // } catch (e) {
    //   debugPrint('Error with message stream: ${e.toString()}');
    //   return Stream.value([]);
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<String, ChatRoomModel>> createConversation({
    required String username,
    required String dancerId,
    required String clientId,
  }) async {
    try {
      debugPrint('CLIENT ID: $clientId');
      debugPrint('DANCER ID: $dancerId');
      final roomId = '${dancerId}_$clientId';

      socket.joinChatRoom(
        username: username,
        roomId: roomId,
      );

      final res = await apiClient.post(
        endpoint: 'chat/create-chat-room',
        body: {'dancerId': dancerId, 'clientId': clientId},
      );
      final resBody = jsonDecode(res.body);
      final message = resBody['message'];

      if (res.statusCode != 200) {
        debugPrint(message);
        return Left(message);
      }
      debugPrint(message);
      final Map<String, dynamic> chatRoomMap = resBody['chatRoom'];
      final chatRoomModel = ChatRoomModel.fromJson(chatRoomMap);
      return Right(chatRoomModel);
    } catch (e) {
      debugPrint('Error creating conversation: ${e.toString()}');
      return const Left('Error creating conversation');
    }
  }
}
