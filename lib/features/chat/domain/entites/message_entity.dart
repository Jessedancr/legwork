class MessageEntity {
  final String messageId;
  final String chatRoomId;
  final String senderId;
  final String receiverId;
  final String content;
  final String senderType;
  final DateTime timeStamp;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentType;

  // CONSTRUCTOR
  MessageEntity({
    required this.messageId,
    required this.chatRoomId,
    required this.senderId,
    required this.senderType,
    required this.receiverId,
    required this.content,
    required this.timeStamp,
    required this.isRead,
    this.attachmentUrl,
    this.attachmentType,
  });
}
