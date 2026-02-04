import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/chat/data/data_sources/socket.dart';
import 'package:legwork/features/chat/data/models/message_model.dart';
import 'package:legwork/features/chat/presentation/provider/chat_provider.dart';
import 'package:legwork/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:legwork/features/chat/presentation/widgets/date_header.dart';
import 'package:legwork/features/chat/presentation/widgets/message_input.dart';
import 'package:legwork/features/chat/presentation/widgets/messages_list.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String otherParticipantId;
  final String clientUsername;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherParticipantId,
    required this.clientUsername,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatProvider _chatProvider;
  late MyAuthProvider _authProvider;
  bool _isTyping = false;
  bool _showScrollButton = false;
  String _otherUsername = '';
  String _otherUserType = '';
  bool _isLoading = true;
  final Socket socket = Socket();

  // THIS METHOD RUNS WHEN THE SCREEN IS FIRST CREATED
  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    _scrollController.addListener(_scrollPosition);

    // Load messages when the screen has fully initialised
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final currentUserId = _authProvider.getUserId();

      // Load messages and mark them as read

      // await _chatProvider.loadMessages(conversationId: widget.conversationId);
      // final messages = _chatProvider.messages[widget.conversationId];
      // if (messages != null && messages.isNotEmpty) {
      //   for (final message in messages) {
      //     if (!message.isRead && message.senderId != currentUserId) {
      //       await _chatProvider.markMessageAsRead(message: message);
      //     }
      //   }
      // }

      // if (currentUserId.isNotEmpty) {
      //   _chatProvider.loadConversation(userId: currentUserId);
      // }

      final result =
          await _authProvider.getUserDetails(uid: widget.otherParticipantId);
      result.fold(
        (error) => setState(() {
          _otherUsername = "User";
          _isLoading = false;
        }),
        (userEntity) => setState(() {
          _otherUsername = userEntity.username;
          _otherUserType = userEntity.userType;
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

    final currentUserId = await _authProvider.getUid();

    final message = MessageModel(
      messageId: '',
      chatRoomId: widget.conversationId,
      senderId: currentUserId,
      senderType: _otherUserType,
      receiverId: widget.otherParticipantId,
      content: content,
      timeStamp: DateTime.now(),
      isRead: false,
    );

    socket.sendMessage(message: message);
    _scrollToBottom();
  }

  /// ** BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      floatingActionButton: _showScrollButton
          ? Align(
              alignment: const Alignment(1, 0.7),
              child: FloatingActionButton(
                onPressed: _scrollToBottom,
                backgroundColor: context.colorScheme.onSurface.withOpacity(0.8),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            )
          : null,

      // * Appbar
      appBar: ChatAppBar(
        isLoading: _isLoading,
        otherUsername: _otherUsername,
        chatProvider: _chatProvider,
        widget: widget,
      ),

      // * Body
      body: Column(
        children: [
          // Date header
          const DateHeader(),

          // Messages list
          Expanded(
            child: MessageList(
              scrollController: _scrollController,
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
