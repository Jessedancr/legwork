class ConversationEntity {
  final String id;
  final List<String> participants;
  final DateTime lastMessageTime; // Timestamp of last message
  final String lastMessageSenderId;
  final String lastMessage;
  final bool hasUnreadMessages;

  // CONSTRUCTOR
  ConversationEntity({
    required this.id,
    required this.participants,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.hasUnreadMessages,
  });
}
