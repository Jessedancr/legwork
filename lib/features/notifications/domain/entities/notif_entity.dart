import 'package:hive/hive.dart';
part 'notif_entity.g.dart'; // This file will be generated

@HiveType(typeId: 2)
class NotifEntity {
  @HiveField(0)
  String? notifId;

  @HiveField(1)
  final String deviceToken;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  @HiveField(4)
  final String channelId;

  @HiveField(5)
  final DateTime? createdAt;

  NotifEntity({
    this.notifId,
    required this.deviceToken,
    required this.body,
    required this.title,
    required this.channelId,
    this.createdAt,
  });

  @override
  String toString() {
    return 'Notif(body: $body, title: $title, id: $notifId, channelId: $channelId)';
  }

  factory NotifEntity.empty() {
    return NotifEntity(
      deviceToken: '',
      body: '',
      title: '',
      channelId: '',
      createdAt: DateTime.now(),
    );
  }
}
