// lib/screens/widgets/stopwatch_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/stopwatch_provider.dart';

class StopwatchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StopwatchProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          provider.displayTime, // Should include milliseconds like "00:01:23.456"
          style: TextStyle(fontSize: 50),
        ),
        const SizedBox(height: 20),
        if (!provider.isRunning)
          ElevatedButton(
            onPressed: () => provider.start(),
            child: Text('Start'),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => provider.stop(),
                child: Text('Stop'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => provider.reset(),
                child: Text('Reset'),
              ),
            ],
          ),
      ],
    );
  }
}
