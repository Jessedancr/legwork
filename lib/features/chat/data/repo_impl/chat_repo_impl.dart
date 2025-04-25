import 'package:dartz/dartz.dart';
import 'package:legwork/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:legwork/features/chat/data/models/message_model.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/chat/domain/repo/chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  // INSTANCE OF CHAT REMOTE DATA SOURCE
  final ChatRemoteDataSource remoteDataSource = ChatRemoteDataSourceImpl();

  @override
  Future<Either<String, List<ConversationEntity>>> getConversations({
    required String userId,
  }) async {
    try {
      final result = await remoteDataSource.getConversations(userId: userId);
      return result.fold(
        // handle fail,
        (fail) => Left(fail),

        // Handle success
        (conversations) => Right(conversations),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<MessageEntity>>> getMessages({
    required String conversationId,
  }) async {
    try {
      final result =
          await remoteDataSource.getMessages(conversationId: conversationId);
      return result.fold(
        // handle fail,
        (fail) => Left(fail),

        // Handle success
        (messages) => Right(messages),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MessageEntity>> sendMessage({
    required MessageEntity message,
  }) async {
    try {
      // Convert entity to model
      final messageModel = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timeStamp: message.timeStamp,
        isRead: message.isRead,
      );

      final result = await remoteDataSource.sendMessage(message: messageModel);
      return result.fold(
        // handle fail
        (fail) => Left(fail),

        // handle success
        (message) => Right(message),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> markMessageAsRead({
    required String messageId,
  }) async {
    try {
      final result =
          await remoteDataSource.markMessageAsRead(messageId: messageId);
      return result.fold(
        // Handle fail
        (fail) => Left(fail),

        // Handle success
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<List<MessageEntity>> messageStream({
    required String conversationId,
  }) {
    return remoteDataSource.messageStream(conversationId: conversationId);
  }

  @override
  Stream<List<ConversationEntity>> conversationStream({
    required String userId,
  }) {
    return remoteDataSource.conversationsStream(userId: userId);
  }

  @override
  Future<Either<String, ConversationEntity>> createConversation({
    required List<String> participants,
  }) async {
    try {
      final result =
          await remoteDataSource.createConversation(participants: participants);
      return result.fold(
        // handle fail
        (fail) => Left(fail),

        // handle success
        (conversation) => Right(conversation),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
