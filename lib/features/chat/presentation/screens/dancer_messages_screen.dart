import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/widgets/conversation_card.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DancerMessagesScreen extends StatefulWidget {
  const DancerMessagesScreen({super.key});

  @override
  State<DancerMessagesScreen> createState() => _DancerMessagesScreenState();
}

class _DancerMessagesScreenState extends State<DancerMessagesScreen> {
  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final userId = authProvider.getUserId();

    // Only fetch conversations if they are not already loaded
    if (chatProvider.conversations.isEmpty &&
        !chatProvider.isLoading &&
        userId.isNotEmpty) {
      await chatProvider.loadConversation(userId: userId);
    }
  }

  Future<void> _refreshConversations() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final userId = authProvider.getUserId();

    if (userId.isNotEmpty) {
      await chatProvider.loadConversation(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,

        // * Appbar
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Messages',
            style: context.heading2Xs?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: context.colorScheme.surface,
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: context.colorScheme.onSurface,
              ),
              onPressed: _refreshConversations,
            ),
          ],
        ),

        // * Body
        body: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            if (chatProvider.isLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }

            if (chatProvider.error != null) {
              return Center(
                child: Text('Error: ${chatProvider.error}'),
              );
            }

            final conversations = chatProvider.conversations;

            if (conversations.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/chat_icon.svg',
                      height: 70,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'No conversations yet',
                      style: context.textLg?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return LiquidPullToRefresh(
              onRefresh: _refreshConversations,
              color: context.colorScheme.primary,
              backgroundColor: context.colorScheme.surface,
              animSpeedFactor: 3.0,
              showChildOpacityTransition: false,
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  final userId =
                      Provider.of<MyAuthProvider>(context, listen: false)
                          .getUserId();

                  return ConversationCard(
                    conversation: conversation,
                    currentUserId: userId,
                    onTap: () {
                      // navigate to chat detail screen
                      Navigator.pushNamed(
                        context,
                        '/chatDetailScreen',
                        arguments: {
                          'conversationId': conversation.convoId,
                          'otherParticipantId':
                              conversation.participants.firstWhere(
                            (id) => id != userId,
                          )
                        },
                      );

                      // Attempt to mark messages as read
                      final messages =
                          chatProvider.messages[conversation.convoId];
                      if (messages != null && messages.isNotEmpty) {
                        final unreadMsg =
                            messages.firstWhere((msg) => msg.isRead == false);
                        chatProvider.markMessageAsRead(message: unreadMsg);
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
