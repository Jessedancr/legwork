import 'package:flutter/material.dart';
import 'package:legwork/features/chat/data/models/send_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Socket {
  // * Singleton
  static final Socket _instance = Socket._internal();
  factory Socket() => _instance;
  Socket._internal();

  IO.Socket? socket;

  void initSocket(String username) {
    socket = IO.io(
      'http://192.168.0.3:3000/',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );
    socket?.onConnect(
      (_) {
        debugPrint('CONNECTED: ${socket?.id}');
        socket?.emit('user-join', username);
      },
    );
    socket?.onDisconnect((_) {
      debugPrint('DISCONNECTED');
    });
    socket?.onConnectError((data) {
      debugPrint('Connection Error: $data');
    });
  }

  void closeSocket(String username) {
    if (socket != null && socket!.connected) {
      socket?.emit('disconnection', username);
      socket?.close();
      debugPrint('SOCKET CLOSED');
    } else {
      debugPrint('SOCKET IS NULL OR ALREADY DISCONNECTED');
    }
  }

  void joinChatRoom({
    required String username,
    required String roomId,
  }) {
    if (socket != null && socket!.connected) {
      socket?.emit('join-chatroom', {
        'username': username,
        'roomId': roomId,
      });
      debugPrint('$username Joined chatroom: $roomId');
    } else {
      debugPrint('Cannot join chat room, socket not connected');
    }
  }

  void sendMessage({
    required SendMessageModel message,
  }) {
    if (socket != null && socket!.connected) {
      socket?.emit('send-message', {
        'chatRoomId': message.chatRoomId,
        'senderId': message.senderId,
        'senderType': message.senderType,
        'content': message.content,
      });
      debugPrint('${message.content} sent to ${message.chatRoomId}');
    } else {
      debugPrint('Cannot send message, socket not connected');
    }
  }
}
