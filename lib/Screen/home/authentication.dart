// lib/screen/home/authentication.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/notification_provider.dart';
import '../Race/race_list_view.dart';
import 'widgets/notification_screen.dart'; // <-- Make sure this import is correct

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
              RoleSelectionCard(
                icon: Icons.person,
                title: "Race Manager",
                onTap: () {
                  setState(() {
                    isManager = true;
                  });
                },
              ),
              RoleSelectionCard(
                icon: Icons.alarm_add_outlined,
                title: "Race Tracker",
                onTap: () {
                  setState(() {
                    isManager = false;
                  });
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isManager! ? "Race Manager" : "Race Tracker",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF5C6BC0),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
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

class RoleSelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const RoleSelectionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 141.45,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5C6BC0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 84, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.27,
                fontFamily: 'ABeeZee',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
