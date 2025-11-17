import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

abstract class NotificationRepo {
  Future<String?> getDeviceToken();
  Future<void> sendNotification({required NotifEntity notif});
  Future<void> saveNotif(NotifEntity notif);
  Future<List<NotifEntity>> getNotif();
  Future<void> deleteNotif(String notifId);
}
