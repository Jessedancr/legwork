class SendMessageModel {
  final String chatRoomId;
  final String senderId;
  final String senderType;
  final String content;

  SendMessageModel({
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.senderType,
  });

  factory SendMessageModel.fromjson(Map<String, dynamic> json) {
    return SendMessageModel(
      chatRoomId: json['chatRoomId'],
      senderId: json['senderId'],
      content: json['content'],
      senderType: json['senderType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'content': content,
      'senderType': senderType,
    };
  }

  factory SendMessageModel.empty() {
    return SendMessageModel(
      chatRoomId: '',
      senderId: '',
      content: '',
      senderType: '',
    );
  }
}
