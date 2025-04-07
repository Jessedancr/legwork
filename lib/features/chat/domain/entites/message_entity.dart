class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timeStamp;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentType;

  // CONSTRUCTOR
  MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timeStamp,
    required this.isRead,
     this.attachmentUrl,
     this.attachmentType,
  });
}
