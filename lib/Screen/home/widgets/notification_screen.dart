import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/notification_model.dart';
import '../../../provider/notification_provider.dart';

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
        title: const Text('Notifications'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadNotifications,
              child: provider.notifications.isEmpty
                  ? const Center(child: Text('No notifications yet.'))
                  : ListView.builder(
                      itemCount: provider.notifications.length,
                      itemBuilder: (context, index) {
                        final AppNotification notification = provider.notifications[index];
                        return ListTile(
                          title: Text(notification.message),
                          subtitle: Text(notification.timestamp.toLocal().toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.removeNotification(notification.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
