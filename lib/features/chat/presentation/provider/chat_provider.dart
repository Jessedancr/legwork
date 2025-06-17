import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/features/chat/data/repo_impl/chat_repo_impl.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

class ChatProvider extends ChangeNotifier {
  // INSTANCE OF CHAT REPO IMPL
  final _chatRepo = ChatRepoImpl();
  final _authRepo = AuthRepoImpl();

  final notificationRepo = NotificationRepoImpl();
  final notificationRemoteDataSource = NotificationRemoteDataSourceImpl();

  // State variables
  bool isLoading = false;
  String? error;

  // * Locally stored conversations and messages to avoid fetching conversations and messages multiple times
  List<ConversationEntity> conversations = [];
  Map<String, List<MessageEntity>> messages = {};

  // LOAD CONVO FOR USER
  Future<void> loadConversation({
    required String userId,
  }) async {
    isLoading = true;
    error = null;

    final result = await _chatRepo.getConversations(userId: userId);

    result.fold(
      // handle fail
      (fail) {
        error = fail;
        isLoading = false;
        notifyListeners();
        debugPrint('Error with loadConversation Provider: $error');
      },

      // Handle success
      (conversationsList) {
        conversations = conversationsList;
        isLoading = false;
        notifyListeners();
        debugPrint('Loaded conversations: ${conversations.length}');
      },
    );
  }

  // LOAD MESSAGES FOR CONVO
  Future<void> loadMessages({
    required String conversationId,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await _chatRepo.getMessages(conversationId: conversationId);

    result.fold(
      // Handle fail
      (fail) {
        error = fail;
        isLoading = false;
        notifyListeners();
        debugPrint('Error with loadMessages Provider: $error');
      },

      // handle success
      (messagesList) {
        messages[conversationId] = messagesList;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  // SEND A MESSAGE
  Future<Either<String, MessageEntity>> sendMessage({
    required MessageEntity message,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    debugPrint(
      'ChatProvider: Sending message to conversation: ${message.convoId}',
    );

    try {
      // MESSGAE ENTITY
      final newMessage = MessageEntity(
        messageId: message.messageId,
        convoId: message.convoId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timeStamp: DateTime.now(),
        isRead: false,
      );

      final receiverDeviceToken =
          await _authRepo.getDeviceToken(userId: message.receiverId);
      String senderUsername = '';

      // EXTRACT SENDER USERNAME FROM USING SENDER ID IN MESSAGE ENTITY
      final senderDetails =
          await _authRepo.getUserDetails(uid: message.senderId);
      senderDetails.fold(
        // handle fail
        (fail) => Left(fail),
        (user) {
          senderUsername = user.username;
        },
      );

      // NOTIFICATION ENTITY
      NotifEntity notif = NotifEntity(
        deviceToken: receiverDeviceToken,
        body: message.content,
        title: senderUsername,
      );

      final result = await _chatRepo.sendMessage(message: newMessage);

      await notificationRepo.sendNotification(notif: notif);

      isLoading = false;
      result.fold(
        // handle fail
        (fail) {
          error = fail;
          notifyListeners();
          debugPrint('Error with sendMessage Provider: $error');
        },

        // handle success
        (message) {
          notifyListeners(); // no need to manually add the message, the stream would handle it
        },
      );
      return result;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      debugPrint('ChatProvider: Exception while sending message: $e');
      return Left(e.toString());
    }
  }

  // START LISTENING TO MESSAGE STREAM
  Stream<List<MessageEntity>> messageStrean({
    required String conversationId,
  }) {
    return _chatRepo.messageStream(conversationId: conversationId);
  }

  // CREATE A NEW CONVERSATION
  Future<Either<String, ConversationEntity>> createConversation({
    required ConversationEntity convoEntity,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await _chatRepo.createConversation(convoEntity: convoEntity);

    isLoading = false;
    notifyListeners();
    debugPrint('Created conversation: $result');

    return result;
  }

  // MARK MESSAGE AS READ
  Future<void> markMessageAsRead({
    required MessageEntity message,
  }) async {
    try {
      await _chatRepo.markMessageAsRead(message: message);
    } catch (e) {
      debugPrint('Error with markMessageAsRead Provider: $e');
    }
  }
}
