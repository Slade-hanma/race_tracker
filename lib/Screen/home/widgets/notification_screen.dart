import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/notification_model.dart';
import '../../../provider/notification_provider.dart';
import 'package:intl/intl.dart'; // Add for better date formatting

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationsOnStart();
  }

  Future<void> _loadNotificationsOnStart() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.loadNotifications();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Notifications ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF5C6BC0),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: provider.loadNotifications,
                child:
                    provider.notifications.isEmpty
                        ? const Center(child: Text('No notifications yet.'))
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: provider.notifications.length,
                          itemBuilder: (context, index) {
                            final AppNotification notification =
                                provider.notifications[index];
                            final formattedTime = DateFormat(
                              'yyyy-MM-dd – kk:mm',
                            ).format(notification.timestamp);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              color: Colors.grey[100],
                              child: ListTile(
                                leading: const Icon(
                                  Icons.notifications,
                                  color: Color(0xFF5C6BC0),
                                ),
                                title: Text(
                                  notification.message,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(formattedTime),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    provider.removeNotification(
                                      notification.id,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
              ),
    );
  }
}
