import 'dart:async';
import 'package:flutter/material.dart';
import '../model/notification_model.dart';
import '../repository/Mock_Repo/firebase_notification_repo.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseNotificationRepo _repo = FirebaseNotificationRepo();
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  StreamSubscription? _notificationSubscription;

  NotificationProvider() {
    // Start listening automatically when provider is created
    _startListeningNotifications();
  }

  void _startListeningNotifications() {
    // Poll every few seconds (simple way) - or you can do Firebase Realtime subscription
    _notificationSubscription = Stream.periodic(Duration(seconds: 5)).listen((_) async {
      await loadNotifications();
    });
  }

  Future<void> loadNotifications() async {
    _notifications = await _repo.fetchNotifications();
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
    notifyListeners();
  }

  Future<void> addNotification(String message) async {
    final notification = AppNotification(
      id: '', // Firebase will generate
      message: message,
      timestamp: DateTime.now(),
    );
    await _repo.addNotification(notification);
    await loadNotifications();
  }

  Future<void> removeNotification(String id) async {
    await _repo.removeNotification(id);
    await loadNotifications();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
