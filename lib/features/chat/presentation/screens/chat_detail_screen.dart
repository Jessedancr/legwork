import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/chat/domain/entites/message_entity.dart';
import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/widgets/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String otherParticipantId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherParticipantId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  late ChatProvider _chatProvider;
  late MyAuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    // Load messages when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatProvider.loadMessages(conversationId: widget.conversationId);
      final userId = _authProvider.currentUserId ?? '';
      if (userId.isNotEmpty) {
        _chatProvider.loadConversation(userId: userId);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = _authProvider.currentUser;
    if (currentUser == null) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    // Use Firebase UID instead of email
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    debugPrint(
        'Attempting to send message to conversation: ${widget.conversationId}');
    debugPrint(
        'Sender: $currentUserId, Receiver: ${widget.otherParticipantId}');
    debugPrint('Content: $content');

    final result = await _chatProvider.sendMessage(
      conversationId: widget.conversationId,
      senderId: currentUserId,
      receiverId: widget.otherParticipantId,
      content: content,
    );

    result.fold(
      (fail) => debugPrint('Failed to send message: $fail'),
      (message) => debugPrint('Message sent: $message'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherParticipantId), // Ideally show the name here
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<List<MessageEntity>>(
              stream: _chatProvider.listenToMessages(
                  conversationId: widget.conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;

                    // Mark message as read if it's not from the current user
                    if (!isMe && !message.isRead) {
                      _chatProvider.markMessageAsRead(messageId: message.id);
                    }

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                // Attachment button
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Implement attachment functionality
                  },
                ),

                // Text input
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),

                // Send button
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
