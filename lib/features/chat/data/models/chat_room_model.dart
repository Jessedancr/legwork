import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';
import 'package:legwork/features/chat/domain/entites/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  // Constructor
  ChatRoomModel({
    required super.chatRoomId,
    required super.client,
    required super.dancer,
    required super.participants,
    required super.lastMessage,
    required super.lastMessageTime,
    // required super.lastMessageSenderId,
    required super.hasUnreadMessages,
  });

  // CONVERT FIREBASE DOC TO CONVO SO WE CAN USE IN THE APP
  factory ChatRoomModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatRoomModel(
      chatRoomId: doc.id,
      client: ClientModel.fromDocument(doc),
      dancer: DancerModel.fromDocument(doc),
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime:
          (data['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // lastMessageSenderId: data['lastMessageSenderId'] ?? '',
      hasUnreadMessages: data['hasUnreadMessages'] ?? false,
    );
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatRoomId: json['roomId'],
      client: ClientModel.fromDoc(json['client']),
      dancer: DancerModel.fromDoc(json['dancer']),
      participants: [
        json['dancer']['_id'] as String,
        json['client']['_id'] as String
      ],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'].toString())
          : DateTime.now(),
      hasUnreadMessages: json['hasUnreadMessages'] ?? false,
      // lastMessageSenderId: lastMessageSenderId,
    );
  }

  // CONVERT TO MAP SO WE CAN STORE IN FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      // 'lastMessageSenderId': lastMessageSenderId,
      'hasUnreadMessages': hasUnreadMessages,
      'convoId': chatRoomId,
    };
  }
}
