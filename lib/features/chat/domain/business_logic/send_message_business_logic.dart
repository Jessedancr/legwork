import 'package:dartz/dartz.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/chat/domain/repo/chat_repo.dart';

class SendMessageBusinessLogic {
  // instance of chat repo
  final ChatRepo chatRepo;

  // Constructor
  SendMessageBusinessLogic({required this.chatRepo});

  Future<Either<String, MessageEntity>> execute({
    required MessageEntity message,
  }) async {
    return await chatRepo.sendMessage(message: message);
  }
}
