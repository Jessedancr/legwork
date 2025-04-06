import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment button
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: const Icon(Icons.attach_file),
              color: colorScheme.primary,
              onPressed: () {
                // Implement the desired functionality for the attachment button here
                print('Attachment button pressed');
              },
            ),
          ),
          const SizedBox(width: 8),

          // Text input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outline,
                ),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isTyping
                  ? colorScheme.primary
                  : colorScheme.secondary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: isTyping ? colorScheme.onPrimary : colorScheme.primary,
              onPressed: isTyping ? onSendMessage : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
