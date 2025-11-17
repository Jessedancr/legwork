import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifChannels {
  static const applicationsChannel = AndroidNotificationChannel(
    'applications_channel',
    'Job Application Updates',
    description: 'Receive updates about your job applications status',
    importance: Importance.high,
    enableLights: true,
    ledColor: Colors.blue,
  );

  static const chatsChannel = AndroidNotificationChannel(
    'chats_channel',
    'Chat Notifications',
    description: 'Notifications for chats and messages',
    importance: Importance.high,
    enableLights: true,
    ledColor: Colors.teal,
  );

  static const paymentsChannel = AndroidNotificationChannel(
    'payments_channel',
    'Payments Notifications',
    description: 'Receive notifications for payments on jobs done',
    importance: Importance.max,
    enableLights: true,
    ledColor: Colors.deepPurple,
  );

  static const jobsForYouChannel = AndroidNotificationChannel(
    'jobs_for_you_channel',
    'Recommended Jobs',
    description: 'Recieve notifications for jobs you may want to apply for',
    importance: Importance.max,
    enableLights: true,
    ledColor: Colors.deepPurple,
  );

  static const system = AndroidNotificationChannel(
    'system_channel',
    'System Alerts',
    description: 'Important alerts',
    importance: Importance.max,
    ledColor: Colors.red,
  );

  static final allChannels = [
    applicationsChannel,
    chatsChannel,
    paymentsChannel,
    jobsForYouChannel,
    system,
  ];
}
