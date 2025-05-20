import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/notification_provider.dart';
import '../../../provider/result_provider.dart';
import '../../../provider/selection_provider.dart';
import '../../../provider/stopwatch_provider.dart';

class SubmitFooter extends StatelessWidget {
  const SubmitFooter({Key? key}) : super(key: key);

  void submitAll(BuildContext context) {
    final selectionProvider = context.read<SelectionProvider>();
    final resultProvider = context.read<ResultProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    for (final result in selectionProvider.selectedResults) {
      resultProvider.addResult(result); // Triggers notification internally
    }

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
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.all(0),
            child: Text("$selectedCount participants selected"),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(color: Color(0xFF5B6FC2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<StopwatchProvider>(
                builder: (context, stopwatchProvider, _) {
                  final stopwatchTime = stopwatchProvider.displayTime;
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
