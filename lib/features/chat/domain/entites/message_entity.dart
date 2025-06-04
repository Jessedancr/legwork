class MessageEntity {
  final String messageId;
  final String convoId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timeStamp;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentType;

  // CONSTRUCTOR
  MessageEntity({
    required this.messageId,
    required this.convoId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timeStamp,
    required this.isRead,
    this.attachmentUrl,
    this.attachmentType,
  });
}
