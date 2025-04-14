import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:googleapis_auth/auth_io.dart';

import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class NotificationRemoteDataSource {
  Future<String?> getDeviceToken();
  Future<void> setupFirebaseListeners();
  Future<void> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final firebaseMessaging = FirebaseMessaging.instance;

  // GET THE DEVICE TOKEN
  @override
  Future<String?> getDeviceToken() async {
    try {
      await firebaseMessaging.requestPermission();
      return await firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Error getting device token: $e");
      return null;
    }
  }

  // SETTING UP FIREBASE LISTENERS
  @override
  Future<void> setupFirebaseListeners() async {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("Foreground message: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("Message clicked: ${message.notification?.title}");
    });
  }

  // SEND NOTIFICATION
  @override
  Future<void> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
  }) async {
    const String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/legwork-jessedancr/messages:send';

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
          'token': deviceToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'android': {
            'notification': {
              'channel_id': 'high_importance_channel',
              'notification_priority': 'PRIORITY_MAX',
              'visibility': 'PUBLIC',
              'default_sound': true,
              'default_vibrate_timings': true,
              'icon': '@mipmap/ic_launcher',
              'color': '#FF0000',
              'sound': 'default'
            },
            'priority': 'HIGH'
          },
          'apns': {
            'headers': {'apns-priority': '10', 'apns-push-type': 'alert'},
            'payload': {
              'aps': {
                'alert': {
                  'title': title,
                  'body': body,
                },
                'badge': 1,
                'sound': 'default',
                'content-available': 1,
                'mutable-content': 1
              }
            }
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'notification_count': '1'
          }
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
        debugPrint('Notification sent successfully');
      }
    } catch (e) {
      debugPrint('Error sending notification(NRDS): $e');
    }
  }

  // SET UP FLUTTER NOTIFICATION
  Future<void> setupFlutterNotifications() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (!kIsWeb && io.Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        enableLights: true,
        ledColor: Colors.deepPurple,
        enableVibration: true,
        playSound: true,
        showBadge: true,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon ?? '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
                number: int.parse(message.data['notification_count'] ??
                    '1'), // Set badge number
                showWhen: true,
                enableLights: true,
                color: const Color.fromARGB(255, 255, 0, 0),
                visibility: NotificationVisibility.public,
                playSound: true,
                enableVibration: true,
              ),
            ),
          );
        }
      });
    }

    // Set badge number when app is in background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

// Add this outside the class
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if needed
  await Firebase.initializeApp();

  // Handle background messages
  debugPrint('Handling background message: ${message.messageId}');
}
