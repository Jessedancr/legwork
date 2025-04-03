import 'package:flutter/material.dart';
import 'package:legwork/Features/chat/domain/entites/conversation_entity.dart';
import 'package:legwork/Features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/Features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:legwork/Features/chat/presentation/widgets/conversation_list_item.dart';
import 'package:provider/provider.dart';
import '../../../../../Features/auth/presentation/Provider/my_auth_provider.dart';

class ClientMessages extends StatefulWidget {
  const ClientMessages({super.key});

  @override
  State<ClientMessages> createState() => _ClientMessagesState();
}

class _ClientMessagesState extends State<ClientMessages> {
  late ChatProvider _chatProvider;
  late MyAuthProvider _authProvider;
  
  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    
    // Load conversations when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = _authProvider.currentUserId ?? '';
      if (userId.isNotEmpty) {
        _chatProvider.loadConversation(userId: userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Also update in build
final userId = _authProvider.currentUserId ?? '';
    // This implementation is identical to DancerMessages for now
    // You can customize it later based on specific client needs
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (chatProvider.error != null) {
            return Center(child: Text('Error: ${chatProvider.error}'));
          }
          
          // final userId = _authProvider.currentUser?.email ?? '';
          
          return StreamBuilder<List<ConversationEntity>>(
            stream: chatProvider.listenToConversations(userId: userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              
              final conversations = snapshot.data ?? [];
              
              if (conversations.isEmpty) {
                return const Center(child: Text('No conversations yet'));
              }
              
              return ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ConversationListItem(
                    conversation: conversation,
                    currentUserId: userId,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            conversationId: conversation.id,
                            otherParticipantId: conversation.participants
                                .firstWhere((id) => id != userId),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}