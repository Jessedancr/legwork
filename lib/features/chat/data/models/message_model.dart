import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends MessageEntity {
  // Constructor
  MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.timeStamp,
    required super.isRead,
    super.attachmentUrl,
    super.attachmentType,
  });

  // CONVERT FIREBASE DOC TO CHAT SO WE CAN USE IN THE APP
  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MessageModel(
      id: '${doc.reference.parent.parent?.id}/${doc.id}', // Include both conversation and message IDs
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      content: data['content'] ?? '',
      timeStamp: (data['timeStamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      attachmentUrl: data['attachmentUrl'],
      attachmentType: data['attachmentType'],
    );
  }

  // CONVERT TO MAP SO WE CAN STORE IN FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'isRead': isRead,
      'attachementUrl': attachmentUrl,
      'attachmentType': attachmentType,
    };
  }
}
