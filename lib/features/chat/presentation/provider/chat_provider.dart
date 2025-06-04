import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/features/chat/data/repo_impl/chat_repo_impl.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';

class ChatProvider extends ChangeNotifier {
  // INSTANCE OF CHAT REPO IMPL
  final chatRepo = ChatRepoImpl();

  final notificationRepo = NotificationRepoImpl();
  final notificationRemoteDataSource = NotificationRemoteDataSourceImpl();
  final _authRemoteDataSource = AuthRemoteDataSourceImpl();

  // State variables
  bool isLoading = false;
  String? error;
  List<ConversationEntity> conversations = [];
  Map<String, List<MessageEntity>> messages = {};

  // CONSTRUCTOR

  // LOAD CONVO FOR USER
  Future<void> loadConversation({
    required String userId,
  }) async {
    isLoading = true;
    error = null;

    final result = await chatRepo.getConversations(userId: userId);

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

    final result = await chatRepo.getMessages(conversationId: conversationId);

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
        debugPrint('Loaded messages for conversation: $conversationId');
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

      final result = await chatRepo.sendMessage(message: newMessage);

      final receiverDeviceToken = await _authRemoteDataSource.getDeviceToken(
        userId: message.receiverId,
      );

      await notificationRepo.sendNotification(
        deviceToken: receiverDeviceToken,
        title: 'New message',
        body: 'New message from ${message.senderId}',
      );

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

  // START LISTENING TO CONVERSATION STREAM
  Stream<List<ConversationEntity>> listenToConversations({
    required String userId,
  }) {
    return chatRepo.conversationStream(userId: userId);
  }

  // START LISTENING TO MESSAGE STREAM
  Stream<List<MessageEntity>> listenToMessages({
    required String conversationId,
  }) {
    debugPrint('Listening to messages for conversation: $conversationId');
    return chatRepo.messageStream(conversationId: conversationId);
  }

  // CREATE A NEW CONVERSATION
  Future<Either<String, ConversationEntity>> createConversation({
    // required List<String> participants,
    required ConversationEntity convoEntity,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await chatRepo.createConversation(
      // participants: participants,
      convoEntity: convoEntity,
    );

    isLoading = false;
    notifyListeners();
    debugPrint('Created conversation: $result');

    return result;
  }

  // MARK MESSAGE AS READ
  Future<void> markMessageAsRead({required String messageId}) async {
    try {
      debugPrint('Chat provider: Marking message as read: $messageId');
      final result = await chatRepo.markMessageAsRead(messageId: messageId);
      result.fold(
        (fail) => debugPrint('Error with markMessageAsRead Provider: $fail'),
        (success) => debugPrint('Successfully marked message as read'),
      );
    } catch (e) {
      debugPrint('Error with markMessageAsRead Provider: $e');
    }
  }
}
