class ConversationEntity {
  final String convoId;
  final List<String> participants;
  final DateTime lastMessageTime; // Timestamp of last message
  final String lastMessageSenderId;
  final String lastMessage;
  final bool hasUnreadMessages;

  // CONSTRUCTOR
  ConversationEntity({
    required this.convoId,
    required this.participants,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.hasUnreadMessages,
  });
}
