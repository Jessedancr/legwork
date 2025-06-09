import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/chat/domain/entites/conversation_entity.dart';
import 'package:provider/provider.dart';

class ConversationListItem extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;
  final String? currentUserUsername;
  final VoidCallback onTap;

  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    this.currentUserUsername,
  });

  @override
  Widget build(BuildContext context) {
    // Instance of auth provider
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    // Get the other participant's ID
    final otherParticipantId = conversation.participants
        .firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');

    // Format time
    final formatter = DateFormat('h:mm a');
    final timeString = formatter.format(conversation.lastMessageTime);

    // Is the last message from the current user
    final isLastMessageFromMe =
        conversation.lastMessageSenderId == currentUserId;

    return FutureBuilder<Either<String, UserEntity>>(
      future: authProvider.getUserDetails(uid: otherParticipantId),
      builder: (context, snapshot) {
        String username = 'loading...';

        if (snapshot.hasData) {
          username = snapshot.data!.fold(
            (error) => error,
            (userEntity) => userEntity.username,
          );
        } else if (snapshot.hasError) {
          username = 'Error';
        }

        return ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          leading: CircleAvatar(
            backgroundColor: context.colorScheme.onPrimaryContainer,
            child: Text(
              username != 'Loading...' && username.isNotEmpty
                  ? username[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: context.colorScheme.surface,
              ),
            ),
          ),
          title: Text(username),
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
              Text(timeString, style: context.textSm),
              const SizedBox(height: 4),
              if (conversation.hasUnreadMessages && !isLastMessageFromMe)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.primary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
