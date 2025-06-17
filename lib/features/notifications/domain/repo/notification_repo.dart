import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

abstract class NotificationRepo {
  Future<String?> getDeviceToken();

  Future<void> sendNotification({required NotifEntity notif});
}
