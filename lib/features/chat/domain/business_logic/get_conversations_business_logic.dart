import 'package:dartz/dartz.dart';
import 'package:legwork/Features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/Features/chat/domain/repo/chat_repo.dart';

class GetConversationsBusinessLogic {
  final ChatRepo chatRepo;

  // Constructor
  GetConversationsBusinessLogic({required this.chatRepo});

  Future<Either<String, List<ConversationEntity>>> execute({
    required String userId,
  }) async {
    return await chatRepo.getConversations(userId: userId);
  }
}
