import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:legwork/features/notifications/domain/repo/notification_repo.dart';

class NottificationRepoImpl implements NotificationRepo {
  final _remoteDataSource = NotificationRemoteDataSourceImpl();
  @override
  Future<String?> getDeviceToken() async {
    try {
      return _remoteDataSource.getDeviceToken();
    } catch (e) {
      return null;
    }
  }
}
