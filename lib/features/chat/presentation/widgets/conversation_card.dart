import 'package:flutter/material.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'conversation_list_item.dart';

class ConversationCard extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;
  final VoidCallback onTap;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    String? highlightText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Theme.of(context).colorScheme.onPrimary,
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ConversationListItem(
            conversation: conversation,
            currentUserId: currentUserId,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
