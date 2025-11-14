import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:legwork/core/network/api_client.dart';
import 'package:legwork/features/notifications/data/data_sources/notif_channels.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationRemoteDataSource {
  Future<String?> getDeviceToken();
  Future<void> sendNotification({required NotifEntity notif});
  Future<void> setupFlutterNotifications();
  void showNotif({
    required RemoteMessage message,
    required FlutterLocalNotificationsPlugin flutterLocalNotif,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final firebaseMessaging = FirebaseMessaging.instance;
  final apiClient = ApiClient();

  /**
   * ASK USER FOR PERMISSION TO SEND NOTIFICATIONS AND GET THE DEVICE TOKEN
   */
  @override
  Future<String?> getDeviceToken() async {
    try {
      return await firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Error getting device token: $e");
      return null;
    }
  }

  // SEND NOTIFICATION
  @override
  Future<void> sendNotification({required NotifEntity notif}) async {
    try {
      final notifBody = {
        'title': notif.title,
        'body': notif.body,
        'deviceToken': notif.deviceToken,
        'channelId': notif.channelId,
      };

      final res = await apiClient.post(
        endpoint: 'notif/send-notif',
        body: notifBody,
      );
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final message = resBody['message'];
      debugPrint(message);
      if (res.statusCode != 200) {
        throw Error();
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
      return;
    }
  }

  // SET UP FLUTTER NOTIFICATION
  @override
  Future<void> setupFlutterNotifications() async {
    // * Permission configs
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    if (!kIsWeb && io.Platform.isAndroid) {
      final flutterLocalNotif = FlutterLocalNotificationsPlugin();
      // * Create notif channel
      final androidImpl =
          flutterLocalNotif.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      for (var channel in NotifChannels.allChannels) {
        await androidImpl?.createNotificationChannel(channel);
        debugPrint('CHANNEL IDs FOR ALL NOTIF CHANNELS: ${channel.id}');
      }

      // * Listen to foreground messages
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          showNotif(
            flutterLocalNotif: flutterLocalNotif,
            message: message,
          );
        },
      );
    }
  }

// * SHOW NOTIFICATION
  @override
  void showNotif({
    required RemoteMessage message,
    required FlutterLocalNotificationsPlugin flutterLocalNotif,
  }) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;
    final channelId = message.data['channelId'] ?? 'system_channel';

    final prefs = await SharedPreferences.getInstance();
    final bool isEnabled = prefs.getBool('$channelId') ?? true;

    if (!isEnabled) return;

    final channel = NotifChannels.allChannels.firstWhere(
      (ch) => ch.id == channelId,
      orElse: () => NotifChannels.system,
    );

    flutterLocalNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
