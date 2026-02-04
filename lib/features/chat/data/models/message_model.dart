import 'package:legwork/features/chat/domain/entites/message_entity.dart';

class MessageModel extends MessageEntity {
  // Constructor
  MessageModel({
    required super.messageId,
    required super.chatRoomId,
    required super.senderId,
    required super.senderType,
    required super.receiverId,
    required super.content,
    required super.timeStamp,
    required super.isRead,
    super.attachmentUrl,
    super.attachmentType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'],
      chatRoomId: json['chatRoomId'],
      senderId: json['senderId'],
      senderType: json['sender']['userType'],
      receiverId: json['receiverId'],
      content: json['content'],
      timeStamp: json['timeStamp'],
      isRead: json['isRead'],
    );
  }

  // CONVERT TO MAP SO WE CAN STORE IN FIRESTORE
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderType': senderType,
      'content': content,
    };
  }
}
