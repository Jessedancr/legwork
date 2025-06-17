import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:googleapis_auth/auth_io.dart';

import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<String?> getDeviceToken();
  Future<void> sendNotification({required NotifEntity notif});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final firebaseMessaging = FirebaseMessaging.instance;

  /**
   * ASK USER FOR PERMISSION TO SEND NOTIFICATIONS AND GET THE DEVICE TOKEN
   */
  @override
  Future<String?> getDeviceToken() async {
    try {
      // await firebaseMessaging.requestPermission();
      return await firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Error getting device token: $e");
      return null;
    }
  }

  // SEND NOTIFICATION
  @override
  Future<void> sendNotification({required NotifEntity notif}) async {
    String fcmUrl = dotenv.env['FCM_URL']!;

    try {
      // Load service account from asset file
      final String serviceAccountJsonString =
          await rootBundle.loadString('assets/service-account.json');

      debugPrint("Loading service account from assets file");

      // Parse the JSON directly
      final Map<String, dynamic> serviceAccountJson =
          jsonDecode(serviceAccountJsonString);

      // LOAD THE SERVICE ACCOUNT CREDENTIALS
      final serviceAcctCred =
          ServiceAccountCredentials.fromJson(serviceAccountJson);

      // Authenticate and get access token
      final authClient = await clientViaServiceAccount(
        serviceAcctCred,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      // Construct notification payload
      final payload = {
        'message': {
          'token': notif.deviceToken,
          'notification': {
            'title': notif.title,
            'body': notif.body,
          },
          'android': {
            'notification': {
              'default_sound': true,
              'icon': '@mipmap/ic_launcher',
              'sound': 'default'
            },
            'priority': 'HIGH'
          },
        }
      };

      // Send the notification
      final response = await authClient.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to send notification: ${response.body}');
      } else {
        debugPrint('Notification sent successfully: ${response.body}');
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
