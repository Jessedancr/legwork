import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:legwork/features/chat/presentation/widgets/date_header.dart';
import 'package:legwork/features/chat/presentation/widgets/message_input.dart';
import 'package:legwork/features/chat/presentation/widgets/messages_list.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String otherParticipantId;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherParticipantId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

/**
 * STATE CLASS
 */
class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatProvider _chatProvider;
  late MyAuthProvider _authProvider;
  final _authRepo = AuthRepoImpl();
  bool _isTyping = false;
  bool _showScrollButton = false;
  String _otherUsername = '';
  bool _isLoading = true;

  // THIS METHOD RUNS WHEN THE SCREEN IS FIRST CREATED
  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    _scrollController.addListener(_scrollPosition);

    // Load messages when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUserId = _authProvider.getUserId();
      _chatProvider.loadMessages(conversationId: widget.conversationId);
      final userId = currentUserId;
      if (userId.isNotEmpty) {
        _chatProvider.loadConversation(userId: userId);
      }

      // Fetch the other participant's username
      final result =
          await _authRepo.getUsername(userId: widget.otherParticipantId);
      result.fold(
        (error) => setState(() {
          _otherUsername = "User";
          _isLoading = false;
        }),
        (username) => setState(() {
          _otherUsername = username;
          _isLoading = false;
        }),
      );
    });

    // Listen for typing status changes
    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

  // THIS METHOD TRACKS THE SCROLL POSITION OF THE USER
  void _scrollPosition() {
    if (_scrollController.position.pixels > 500 && !_showScrollButton) {
      setState(() {
        _showScrollButton = true;
      });
    } else if (_scrollController.position.pixels <= 500 && _showScrollButton) {
      setState(() {
        _showScrollButton = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // THIS METHOD RUNS WHEN THE WIDGET IS DESTROYED(WHEN THE USER LEAVES THE SCREEN)
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_scrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = _authProvider.currentUser;
    if (currentUser == null) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    final currentUserId = _authProvider.getUserId();

    final result = await _chatProvider.sendMessage(
      conversationId: widget.conversationId,
      senderId: currentUserId,
      receiverId: widget.otherParticipantId,
      content: content,
    );

    result.fold(
      (fail) {
        LegworkSnackbar(
          title: 'Oopes',
          subTitle: fail,
          imageColor: Theme.of(context).colorScheme.onError,
          contentColor: Theme.of(context).colorScheme.error,
        ).show(context);
      },
      (message) {
        _scrollToBottom();
      },
    );
  }

  /// ** BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // * Appbar
      appBar: ChatAppBar(
        theme: theme,
        isLoading: _isLoading,
        colorScheme: colorScheme,
        otherUsername: _otherUsername,
        chatProvider: _chatProvider,
        widget: widget,
      ),

      // * Body
      body: Column(
        children: [
          // Date header
          DateHeader(theme: theme),

          // Messages list
          Expanded(
            child: MessageList(
              conversationId: widget.conversationId,
              otherParticipantId: widget.otherParticipantId,
            ),
          ),

          MessageInput(
            messageController: _messageController,
            isTyping: _isTyping,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
