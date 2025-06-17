import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';
import 'package:legwork/features/notifications/domain/repo/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final _remoteDataSource = NotificationRemoteDataSourceImpl();
  @override
  Future<String?> getDeviceToken() async {
    try {
      return _remoteDataSource.getDeviceToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> sendNotification({required NotifEntity notif}) async {
    try {
      return _remoteDataSource.sendNotification(notif: notif);
    } catch (e) {
      return;
    }
  }
}
