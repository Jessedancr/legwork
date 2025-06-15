import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Format time
    final formatter = DateFormat('h:mm a');
    final timeString = formatter.format(message.timeStamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isMe
              ? context.colorScheme.primary
              : context.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: screenWidth(context) * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: context.textXs?.copyWith(
                    color: isMe
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 15,
                    color: message.isRead
                        ? context.colorScheme.primaryContainer
                        : Colors.grey[600],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
