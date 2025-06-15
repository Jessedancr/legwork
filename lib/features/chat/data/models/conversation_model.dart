import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  // Constructor
  ConversationModel({
    required super.convoId,
    required super.participants,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.lastMessageSenderId,
    required super.hasUnreadMessages,
  });

  // CONVERT FIREBASE DOC TO CONVO SO WE CAN USE IN THE APP
  factory ConversationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ConversationModel(
      convoId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      hasUnreadMessages: data['hasUnreadMessages'] ?? false,
    );
  }

  // CONVERT TO MAP SO WE CAN STORE IN FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageSenderId': lastMessageSenderId,
      'hasUnreadMessages': hasUnreadMessages,
      'convoId': convoId,
    };
  }
}
