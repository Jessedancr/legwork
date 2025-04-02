import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:googleapis_auth/auth_io.dart';

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
  final FirebaseMessaging firebaseMessaging;

  NotificationRemoteDataSourceImpl({required this.firebaseMessaging});

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
              'priority': 'high',
              'default_sound': true,
              'default_vibrate_timings': true,
            }
          },
          'apns': {
            'payload': {
              'aps': {'sound': 'default', 'badge': 1}
            }
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
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
}
