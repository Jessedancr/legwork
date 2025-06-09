import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: context.colorScheme.primary,
        splashFactory: InkRipple.splashFactory,
        child: ConversationListItem(
          conversation: conversation,
          currentUserId: currentUserId,
          onTap: onTap,
        ),
      ),
    );
  }
}
