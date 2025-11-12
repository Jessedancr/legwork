import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:legwork/core/network/api_client.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<String?> getDeviceToken();
  Future<void> sendNotification({required NotifEntity notif});
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
    }
  }

  // SET UP FLUTTER NOTIFICATION
  Future<void> setupFlutterNotifications() async {
    // * Permission configs
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    if (!kIsWeb && io.Platform.isAndroid) {
      // * Channel definition
      // TODO: Add multiple channels for different types of notifs
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'legwork_notifications',
        'Legwork Notifications',
        description: 'Notifications from Legwork app.',
        importance: Importance.max,
        enableLights: true,
        ledColor: Colors.deepPurple,
      );

      // * Instance of notif package
      final flutterLocalNotif = FlutterLocalNotificationsPlugin();

      // * Create notif channel
      await flutterLocalNotif
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // * Listen to foreground messages
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          RemoteNotification? notification = message.notification;

          if (notification != null) {
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
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
          }
        },
      );
    }
  }
}
