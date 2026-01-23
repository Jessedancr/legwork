import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

class ChatRoomEntity {
  final String chatRoomId;
  final DancerEntity dancer;
  final ClientEntity client;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;
  // final String lastMessageSenderId;

  // CONSTRUCTOR
  ChatRoomEntity({
    required this.chatRoomId,
    required this.participants,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.hasUnreadMessages,
    required this.client,
    required this.dancer,
    // required this.lastMessageSenderId,
  });
}
