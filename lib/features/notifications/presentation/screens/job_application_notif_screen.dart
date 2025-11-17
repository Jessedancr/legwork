import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';
import 'package:legwork/features/notifications/presentation/provider/notif_provider.dart';
import 'package:legwork/features/notifications/presentation/widgets/notif_tile.dart';
import 'package:provider/provider.dart';

class JobApplicationNotifScreen extends StatefulWidget {
  const JobApplicationNotifScreen({super.key});

  @override
  State<JobApplicationNotifScreen> createState() =>
      _JobApplicationNotifScreenState();
}

class _JobApplicationNotifScreenState extends State<JobApplicationNotifScreen>
    with AutomaticKeepAliveClientMixin {
  final String appChannel = NotifChannelId.applications_channel.name;
  final String paymentChannel = NotifChannelId.payments_channel.name;
  final String jobsForYouChannel = NotifChannelId.jobs_for_you_channel.name;

  List<NotifEntity> notifications = [];
  @override
  void initState() {
    super.initState();
    _loadNotifs();
  }

  void _loadNotifs() async {
    final provider = Provider.of<NotifProvider>(context, listen: false);
    final notifs = await provider.getNotif();
    setState(() {
      notifications = notifs;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final provider = Provider.of<NotifProvider>(context, listen: false);

        final notif = notifications[index];
        final String notifChannelId = notif.channelId;
        return NotifTile(
          svgIconPath: notifChannelId == appChannel
              ? 'assets/svg/briefcase.svg'
              : 'assets/svg/naira_icon.svg',
          notifTitle: notif.title,
          onDeleteNotif: () async {
            final notifId = notif.notifId ?? '';
            await provider.deleteNotif(notifId);
            setState(() {
              notifications.removeAt(index);
            });
          },
          onButtonPressed: () {},
          buttonText: notifChannelId == appChannel
              ? 'View Application'
              : notifChannelId == paymentChannel
                  ? 'View Payment Details'
                  : 'View Job Details',
          notifBody: notif.body,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
