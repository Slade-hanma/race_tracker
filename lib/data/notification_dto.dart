// lib/dtos/app_notification_dto.dart
import '../model/notification_model.dart';

class AppNotificationDto {
  final String? id;
  final String message;
  final String timestamp; // Store as ISO String for Firebase

  AppNotificationDto({
    this.id,
    required this.message,
    required this.timestamp,
  });

  factory AppNotificationDto.fromJson(Map<String, dynamic> json, String id) {
    return AppNotificationDto(
      id: id,
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': timestamp,
    };
  }

  AppNotification toModel() {
    return AppNotification(
      id: id ?? '',
      message: message,
      timestamp: DateTime.parse(timestamp),
    );
  }

  static AppNotificationDto fromModel(AppNotification notification) {
    return AppNotificationDto(
      id: notification.id,
      message: notification.message,
      timestamp: notification.timestamp.toIso8601String(),
    );
  }
}
