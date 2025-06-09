import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/widgets/message_bubble.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

class MessageList extends StatelessWidget {
  final String conversationId;
  final String otherParticipantId;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.conversationId,
    required this.otherParticipantId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    return StreamBuilder<List<MessageEntity>>(
      stream: chatProvider.messageStrean(conversationId: conversationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/loading.json',
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading messages',
                  style: TextStyle(
                    color: context.colorScheme.error,
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
                SvgPicture.asset(
                  'assets/svg/chat_icon.svg',
                  height: 70,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: context.headingXs?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a message to start the conversation',
                  style: context.textXs
                      ?.copyWith(color: context.colorScheme.onSurface),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final currentUserId = authProvider.getUserId();
            final message = messages[index];
            final isMe = message.senderId == currentUserId;
            final showTimestamp = index == 0 ||
                messages[index]
                        .timeStamp
                        .difference(messages[index - 1].timeStamp)
                        .inHours >=
                    12;

            return Column(
              children: [
                if (showTimestamp)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _formatTime(message.timeStamp),
                      style: context.textSm?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
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
    final dateToCheck =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

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
