import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';

import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/widgets/conversation_card.dart';
import 'package:provider/provider.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Messages',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: colorScheme.primary,
            ),
            onPressed: _refreshConversations,
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (chatProvider.error != null) {
            return Center(
              child: Text('Error: ${chatProvider.error}'),
            );
          }

          final conversations = chatProvider.conversations;

          if (conversations.isEmpty) {
            return const Center(
              child: Text('No conversations yet'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshConversations,
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
                    Navigator.pushNamed(context, '/chatDetailScreen',
                        arguments: {
                          'conversationId': conversation.id,
                          'otherParticipantId':
                              conversation.participants.firstWhere(
                            (id) => id != userId,
                          )
                        });
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
