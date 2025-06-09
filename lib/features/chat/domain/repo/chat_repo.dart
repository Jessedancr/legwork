import 'package:dartz/dartz.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';

abstract class ChatRepo {
  // GET ALL CONVO FOR A USER
  Future<Either<String, List<ConversationEntity>>> getConversations({
    required String userId,
  });

  // GET MESSAGES FOR A SPECIFIC CONVO
  Future<Either<String, List<MessageEntity>>> getMessages({
    required String conversationId,
  });

  // SEND A MESSAGE
  Future<Either<String, MessageEntity>> sendMessage({
    required MessageEntity message,
  });

  // MARK MESSAGE AS READ
  Future<Either<String, void>> markMessageAsRead({
    required MessageEntity message,
  });

  // STREAM FOR REAL-TIME MESSAGES IN A CONVO
  Stream<List<MessageEntity>> messageStream({required String conversationId});

  // STREAM FOR REAL TIME CONVO LIST
  Stream<List<ConversationEntity>> conversationStream({required String userId});

  // CREATE A NEW CONVO
  Future<Either<String, ConversationEntity>> createConversation({
    required ConversationEntity convoEntity,
  });
}
