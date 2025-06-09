import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController messageController;
  final bool isTyping;
  final VoidCallback onSendMessage;

  const MessageInput({
    super.key,
    required this.messageController,
    required this.isTyping,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text input
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle:
                    TextStyle(color: context.colorScheme.onSurfaceVariant),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: context.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
              ),
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTyping
                  ? context.colorScheme.primary
                  : context.colorScheme.secondary.withOpacity(0.5),
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: isTyping
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSecondary,
              onPressed: isTyping ? onSendMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}
