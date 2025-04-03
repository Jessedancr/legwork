import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legwork/Features/chat/domain/entites/conversation_entity.dart';

class ConversationListItem extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;
  final VoidCallback onTap;

  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final otherParticipantId = conversation.participants
        .firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');

    // Format time
    final formatter = DateFormat('h:mm a');
    final timeString = formatter.format(conversation.lastMessageTime);

    // Is the last message from the current user
    final isLastMessageFromMe =
        conversation.lastMessageSenderId == currentUserId;

    return ListTile(
      leading: CircleAvatar(
        child: Text(otherParticipantId.substring(0, 1).toUpperCase()),
      ),
      title: Text(otherParticipantId),
      subtitle: Row(
        children: [
          if (isLastMessageFromMe) const Text('You: '),
          Expanded(
            child: Text(
              conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(timeString, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          if (conversation.hasUnreadMessages && !isLastMessageFromMe)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
