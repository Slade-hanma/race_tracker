// lib/widgets/footer_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/result_provider.dart';
import '../../../provider/selection_provider.dart';
import '../../../provider/stopwatch_provider.dart';
import '../../../provider/notification_provider.dart'; // Import the NotificationProvider

class SubmitFooter extends StatelessWidget {
  final StopwatchProvider stopwatchProvider;

  const SubmitFooter({Key? key, required this.stopwatchProvider})
    : super(key: key);

  void submitAll(BuildContext context) {
    final selectionProvider = context.read<SelectionProvider>();
    final resultProvider = context.read<ResultProvider>();
    final notificationProvider =
        context.read<NotificationProvider>(); // Access NotificationProvider

    for (final result in selectionProvider.selectedResults) {
      resultProvider.addResult(result); // This now triggers notification
    }

    selectionProvider.clearSelections();

    // Add notification after submitting the result
    notificationProvider.addNotification('Race results have been submitted.');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Submitted to result list")));
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount =
        context.watch<SelectionProvider>().selectedResults.length;
    return Column(
      children: [
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("$selectedCount participants selected"),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Color(0xFF5B6FC2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap in Consumer to listen for updates in StopwatchProvider
              Consumer<StopwatchProvider>(
                builder: (context, stopwatchProvider, _) {
                  final stopwatchTime = stopwatchProvider.displayTime;
                  SizedBox(width: 500);
                  return Text(
                    stopwatchTime,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: selectedCount > 0 ? () => submitAll(context) : null,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
