import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/chat/domain/entites/message_entity.dart';
import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/widgets/message_bubble.dart';
import 'package:provider/provider.dart';

class MessageList extends StatelessWidget {
  final String conversationId;
  final String otherParticipantId;

  const MessageList({
    super.key,
    required this.conversationId,
    required this.otherParticipantId,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return StreamBuilder<List<MessageEntity>>(
      stream: chatProvider.listenToMessages(conversationId: conversationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Error loading messages',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${snapshot.error}'),
              ],
            ),
          );
        }

        final messages = snapshot.data ?? [];
        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: colorScheme.inverseSurface),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a message to start the conversation',
                  style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;
            final showTimestamp = index == 0 ||
                messages[index].timeStamp.difference(messages[index - 1].timeStamp).inHours >= 12;

            return Column(
              children: [
                if (showTimestamp)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _formatTime(message.timeStamp),
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                MessageBubble(message: message, isMe: isMe),
              ],
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (dateToCheck == today) {
      return 'Today at ${_formatTimeOnly(timestamp)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday at ${_formatTimeOnly(timestamp)}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${_formatTimeOnly(timestamp)}';
    }
  }

  String _formatTimeOnly(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}