// lib/repositories/firebase_notification_repo.dart
import 'dart:convert';
import '../../data/notification_dto.dart';
import '../../model/notification_model.dart';
import '../notification_repo.dart';
import 'firebase_base_repo.dart';

class FirebaseNotificationRepo extends FirebaseBaseRepo implements NotificationRepo {
  final String collectionPath = 'notifications';

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    final response = await get(collectionPath);
    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];

    return data.entries.map((e) {
      return AppNotificationDto.fromJson(e.value, e.key).toModel();
    }).toList();
  }

  @override
  Future<void> addNotification(AppNotification notification) async {
    final dto = AppNotificationDto.fromModel(notification);
    await post(collectionPath, dto.toJson());
  }

  @override
  Future<void> removeNotification(String id) async {
    await delete('$collectionPath/$id');
  }
}
