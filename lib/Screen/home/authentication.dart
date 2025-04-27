import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/notification_provider.dart';
import '../Race/race_list_view.dart';
import 'widgets/notification_screen.dart'; // <-- Import this too

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool? isManager;

  @override
  Widget build(BuildContext context) {
    if (isManager == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  title: const Text("Race Manager"),
                  onTap: () {
                    setState(() {
                      isManager = true;
                    });
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Race Tracker"),
                  onTap: () {
                    setState(() {
                      isManager = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(isManager! ? "Race Manager" : "Race Tracker"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                isManager = null;
              });
            },
          ),
          actions: [
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationScreen()),
                        );
                      },
                    ),
                    if (notificationProvider.notifications.isNotEmpty)
                      Positioned(
                        right: 11,
                        top: 11,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${notificationProvider.notifications.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: RacesListView(isManager: isManager!),
      );
    }
  }
}
