// lib/repositories/notification_repo.dart
import '../model/notification_model.dart';

abstract class NotificationRepo {
  Future<List<AppNotification>> fetchNotifications();
  Future<void> addNotification(AppNotification notification);
  Future<void> removeNotification(String id);
}
