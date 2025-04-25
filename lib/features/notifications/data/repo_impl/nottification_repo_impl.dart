import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
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
  Future<void> sendNotification({
    required String deviceToken,
    required String title,
    required String body,
  }) async {
    try {
      return _remoteDataSource.sendNotification(
        deviceToken: deviceToken,
        title: title,
        body: body,
      );
    } catch (e) {
      return;
    }
  }
}
