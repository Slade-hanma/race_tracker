// lib/widgets/race_status_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/notification_provider.dart';
import '../../provider/race_status_provider.dart';
import '../../model/race_status_enum.dart';

class RaceStatusWidget extends StatelessWidget {
  final String raceName;
  final bool isManager;

  const RaceStatusWidget({Key? key, required this.raceName, required this.isManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RaceStatusProvider>();

    // Fetch once when building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchStatus(raceName); // Ensures we sync with Firebase
    });

    final currentStatus = provider.getStatus(raceName);

    return Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: currentStatus.backgroundColor,
    borderRadius: BorderRadius.circular(12),
  ),
  child: isManager
      ? DropdownButtonHideUnderline(
          child: DropdownButton<RaceStatus>(
            value: currentStatus,
            dropdownColor: currentStatus.backgroundColor,
            iconEnabledColor: currentStatus.textColor,
            style: TextStyle(color: currentStatus.textColor),
            items: RaceStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.label, style: TextStyle(color: status.textColor)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.updateStatus(raceName, value);
                
                // Trigger notification when the race status changes
                final notificationProvider = context.read<NotificationProvider>();
                notificationProvider.addNotification('${raceName} is now ${value.label}');
              }
            },
          ),
        )
      : Text(
          currentStatus.label,
          style: TextStyle(color: currentStatus.textColor, fontWeight: FontWeight.bold),
        ),
);

}}
