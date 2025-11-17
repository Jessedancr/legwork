import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class NotificationLocalDataSource {
  static const String boxName = 'notif_box';
  final Uuid uuid = const Uuid();

  String generateUid() {
    return uuid.v4();
  }

  String get genUid => uuid.v4();

  // * Save notif to hive
  Future<Either<String, void>> saveNotif(NotifEntity notif) async {
    try {
      final box = Hive.box<NotifEntity>(boxName);
      final notifId = notif.notifId = genUid;
      await box.put(notifId, notif);

      // * Update the list of all notification IDs in SharedPrefs
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingIds = prefs.getStringList('notifIds') ?? [];
      existingIds.add(notifId);
      await prefs.setStringList('notifIds', existingIds);

      debugPrint('Notification saved to hive with ID: $notifId');
      debugPrint('Total notifications in box: ${box.values.length}');
      return const Right(null);
    } catch (e) {
      debugPrint('Unknown error saving notification to hive: ${e.toString()}');
      return const Left('Unknown error saving notification to hive');
    }
  }

  // * Get notif from hive
  Future<Either<String, List<NotifEntity>>> getNotif() async {
    try {
      final box = Hive.box<NotifEntity>(boxName);
      final prefs = await SharedPreferences.getInstance();
      final notifIds = prefs.getStringList('notifIds') ?? [];

      // * Retrieve all notifications using their IDs
      final List<NotifEntity> notifications = [];
      for (String id in notifIds) {
        final NotifEntity? notif = box.get(id);
        if (notif != null) {
          notifications.add(notif);
        }
      }
      notifications.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      debugPrint('Retrieved ${notifications.length} notifications from hive');

      return Right(notifications);
    } catch (e) {
      debugPrint(
        'Unknown error occured while getting notifications from hive: ${e.toString()}',
      );
      return const Left(
        'Unknown error occured while getting notifications',
      );
    }
  }

  // * Get single notification by ID
  Future<Either<String, NotifEntity?>> getNotifById(String notifId) async {
    try {
      final box = Hive.box<NotifEntity>(boxName);
      final NotifEntity? notif = box.get(notifId);
      return Right(notif);
    } catch (e) {
      debugPrint('Error getting notification by ID: ${e.toString()}');
      return Left('Error getting notification: ${e.toString()}');
    }
  }

  // * Delete notification
  Future<Either<String, void>> deleteNotif(String notifId) async {
    try {
      final box = Hive.box<NotifEntity>(boxName);
      await box.delete(notifId);

      // Remove from SharedPreferences list
      final prefs = await SharedPreferences.getInstance();
      final List<String> notifIds = prefs.getStringList('notifIds') ?? [];
      notifIds.remove(notifId);
      await prefs.setStringList('notifIds', notifIds);

      return const Right(null);
    } catch (e) {
      debugPrint('Error deleting notification: ${e.toString()}');
      return Left('Error deleting notification: ${e.toString()}');
    }
  }
}
