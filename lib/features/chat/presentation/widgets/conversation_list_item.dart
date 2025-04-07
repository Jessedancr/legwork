import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legwork/Features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/Features/chat/domain/entites/conversation_entity.dart';

class ConversationListItem extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;
  final String? currentUserUsername;
  final VoidCallback onTap;

  ConversationListItem({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
    this.currentUserUsername,
  });

  // instance of auth repo
  final AuthRepoImpl _authRepo = AuthRepoImpl();

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

    return FutureBuilder<Either<String, String>>(
      future: _authRepo.getUsername(userId: otherParticipantId),
      builder: (context, snapshot) {
        // final username = snapshot.data as String;
        String username = 'loadin...';

        if (snapshot.hasData) {
          username = snapshot.data!.fold(
            (error) => error,
            (success) => success,
          );
        } else if (snapshot.hasError) {
          username = 'Error';
        }

        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Text(
              username != 'Loading...' && username.isNotEmpty
                  ? username[0].toUpperCase()
                  : '?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
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
      },
    );
  }
}
