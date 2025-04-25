abstract class NotificationRepo {
  Future<String?> getDeviceToken();

  Future<void> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
  });
}
