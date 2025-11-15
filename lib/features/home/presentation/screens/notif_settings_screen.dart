import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/notifications/data/data_sources/notif_channels.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifSettingsScreen extends StatefulWidget {
  const NotifSettingsScreen({
    super.key,
  });

  @override
  State<NotifSettingsScreen> createState() => _NotifSettingsScreenState();
}

class _NotifSettingsScreenState extends State<NotifSettingsScreen> {
  late SharedPreferences prefs;
  late MyAuthProvider authProvider;
  late String userType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    userType = authProvider.currentUser!.userType;
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = false;
    });
  }

  bool _isChannelEnabled(NotifChannelId channelId) {
    return prefs.getBool(channelId.name) ?? true;
  }

  Future<void> _toggleChannel(NotifChannelId channelId, bool value) async {
    await prefs.setBool(channelId.name, value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      // * APPBAR
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
        title: Text(
          'Notification Settings',
          style: context.heading2Xs?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),

      // * BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // * JOB APPLICATION NOTIF
            _buildTile(
              channelId: NotifChannelId.applications_channel,
              channel: NotifChannels.applicationsChannel,
              icon: SvgPicture.asset(
                'assets/svg/briefcase.svg',
                color: context.colorScheme.onPrimaryContainer,
              ),
              clientChannelDescr:
                  'Receive updates when you receive a new job application',
            ),
            const SizedBox(height: 16),

            // * CHAT NOTIF
            _buildTile(
              channelId: NotifChannelId.chats_channel,
              channel: NotifChannels.chatsChannel,
              icon: SvgPicture.asset(
                'assets/svg/chat_icon.svg',
                color: context.colorScheme.onPrimaryContainer,
              ),
              clientChannelDescr: 'Notifications for chats and messages',
            ),
            const SizedBox(height: 16),

            if (userType == UserType.dancer.name) ...[
              // * PAYMENTS NOTIF
              _buildTile(
                channelId: NotifChannelId.payments_channel,
                channel: NotifChannels.paymentsChannel,
                icon: SvgPicture.asset(
                  'assets/svg/naira_icon.svg',
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 16),

              // * JOBS FOR YOU NOTIF
              _buildTile(
                channelId: NotifChannelId.jobs_for_you_channel,
                channel: NotifChannels.jobsForYouChannel,
                icon: SvgPicture.asset(
                  'assets/svg/user.svg',
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required NotifChannelId channelId,
    required AndroidNotificationChannel channel,
    required Widget icon,
    String clientChannelDescr = '',
  }) {
    return SwitchListTile(
      title: Text(
        channel.name,
        style: context.textMd?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        userType == UserType.dancer.name
            ? channel.description ?? ''
            : clientChannelDescr,
        style: context.textSm?.copyWith(fontWeight: FontWeight.w400),
      ),
      secondary: icon,
      value: _isChannelEnabled(channelId),
      onChanged: (val) {
        _toggleChannel(channelId, val);
        debugPrint('VALUE FOR ${channelId.name} - $val');
      },
    );
  }
}
