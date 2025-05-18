// lib/models/notification_model.dart
class AppNotification {
  final String id;
  final String message;
  final DateTime timestamp;

  AppNotification({
    required this.id,
    required this.message,
    required this.timestamp,
  });
}
