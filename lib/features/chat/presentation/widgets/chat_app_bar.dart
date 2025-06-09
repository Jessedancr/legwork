import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/chat/domain/entites/message_entity.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:lottie/lottie.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool _isLoading;
  final String _otherUsername;
  final ChatProvider _chatProvider;
  final ChatDetailScreen widget;

  // CONSTRUCTOR
  const ChatAppBar({
    super.key,
    required bool isLoading,
    required String otherUsername,
    required ChatProvider chatProvider,
    required this.widget,
  })  : _isLoading = isLoading,
        _otherUsername = otherUsername,
        _chatProvider = chatProvider;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: context.colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: _isLoading
          ? Lottie.asset(
              'assets/lottie/loading.json',
              height: 30,
              fit: BoxFit.cover,
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: context.colorScheme.secondary,
                  child: Text(
                    _otherUsername.isNotEmpty
                        ? _otherUsername[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: context.colorScheme.onPrimary,
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
                      style: context.textMd?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    StreamBuilder<List<MessageEntity>>(
                      stream: _chatProvider.messageStrean(
                        conversationId: widget.conversationId,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox();

                        final isOnline = snapshot.data?.any(
                              (msg) =>
                                  msg.senderId == widget.otherParticipantId &&
                                  DateTime.now()
                                          .difference(msg.timeStamp)
                                          .inMinutes <
                                      5,
                            ) ??
                            false;

                        return Text(
                          isOnline ? 'Online' : 'Offline',
                          style: context.textXs?.copyWith(
                            color: isOnline ? Colors.teal : Colors.grey,
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
