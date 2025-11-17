import 'package:dartz/dartz.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_local_data_source.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';
import 'package:legwork/features/notifications/domain/repo/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final _remoteDataSource = NotificationRemoteDataSourceImpl();
  final _localDataSource = NotificationLocalDataSource();
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

  @override
  Future<void> saveNotif(NotifEntity notif) {
    return _localDataSource.saveNotif(notif);
  }

  @override
  Future<List<NotifEntity>> getNotif() async {
    final result = await _localDataSource.getNotif();
    return result.fold(
      (fail) => throw Exception(fail),
      (notifs) => notifs,
    );
  }

  @override
  Future<void> deleteNotif(String notifId) async {
    final result = await _localDataSource.deleteNotif(notifId);
    return result.fold((fail) => Right(fail), (_) => null);
  }
}
