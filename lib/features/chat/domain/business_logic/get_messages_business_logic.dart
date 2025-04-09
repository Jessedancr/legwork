import 'package:dartz/dartz.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/chat/domain/repo/chat_repo.dart';

class GetMessagesBusinessLogic {
  // Instance of chat repo
  final ChatRepo chatRepo;

  // Constructor
  GetMessagesBusinessLogic({required this.chatRepo});

  Future<Either<String, List<MessageEntity>>> execute({
    required String conversationId,
  }) async {
    return await chatRepo.getMessages(conversationId: conversationId);
  }
}
