class NotifEntity {
  final String deviceToken;
  final String title;
  final String body;
  final String channelId;

  NotifEntity({
    required this.deviceToken,
    required this.body,
    required this.title,
    required this.channelId,
  });
}
