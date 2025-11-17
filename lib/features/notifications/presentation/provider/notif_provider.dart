import 'package:flutter/material.dart';
import 'package:legwork/features/notifications/data/repo_impl/nottification_repo_impl.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

class NotifProvider extends ChangeNotifier {
  final NotificationRepoImpl notifRepo = NotificationRepoImpl();
  bool _isLoading = false;
  List<NotifEntity>? _notifications;
  List<NotifEntity>? get notifications => _notifications;

  Future<void> saveNotif(NotifEntity notif) async {
    _isLoading = true;
    notifyListeners();
    final result = await notifRepo.saveNotif(notif);
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<List<NotifEntity>> getNotif() async {
    _isLoading = true;
    final result = await notifRepo.getNotif();
    _isLoading = false;
    return result;
  }

  Future<void> deleteNotif(String notifId) async {
    await notifRepo.deleteNotif(notifId);
  }
}
