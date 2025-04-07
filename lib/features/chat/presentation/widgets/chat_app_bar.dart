import 'package:flutter/material.dart';
import 'package:legwork/Features/chat/domain/entites/message_entity.dart';
import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/screens/chat_detail_screen.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;
  final bool _isLoading;
  final ColorScheme colorScheme;
  final String _otherUsername;
  final ChatProvider _chatProvider;
  final ChatDetailScreen widget;

  // CONSTRUCTOR
  const ChatAppBar({
    super.key,
    required this.theme,
    required bool isLoading,
    required this.colorScheme,
    required String otherUsername,
    required ChatProvider chatProvider,
    required this.widget,
  })  : _isLoading = isLoading,
        _otherUsername = otherUsername,
        _chatProvider = chatProvider;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: _isLoading
          ? const Text('Loading...')
          : Row(
              children: [
                // * Circle avatar, should ideally be the other user's profile picture
                // Todo: Turn this to a reusable widget
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primary.withOpacity(0.2),
                  child: Text(
                    _otherUsername.isNotEmpty
                        ? _otherUsername[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // * Column containing other user's username and online/offline status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _otherUsername,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<List<MessageEntity>>(
                      stream: _chatProvider.listenToMessages(
                        conversationId: widget.conversationId,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();

                        final online = snapshot.data?.any(
                              (msg) =>
                                  msg.senderId == widget.otherParticipantId &&
                                  DateTime.now()
                                          .difference(msg.timeStamp)
                                          .inMinutes <
                                      5,
                            ) ??
                            false;

                        return Text(
                          online ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            color: online ? Colors.green : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
