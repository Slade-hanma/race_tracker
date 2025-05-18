// lib/providers/stopwatch_provider.dart


import 'dart:async';
import 'package:flutter/foundation.dart';
import '../repository/stopwatch_repo.dart';

class StopwatchProvider with ChangeNotifier {
  final StopwatchRepository stopwatchRepository;
  // final FirebaseSwatchRepo stopwatchRepository;

  late Timer _timer;
  int _elapsedMilliseconds = 0;
  bool isRunning = false;

  // Get formatted time: HH:MM:SS.MS
  String get displayTime {
    final hours = (_elapsedMilliseconds ~/ 3600000).toString().padLeft(2, '0');
    final minutes = ((_elapsedMilliseconds ~/ 60000) % 60).toString().padLeft(2, '0');
    final seconds = ((_elapsedMilliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    final millis = (_elapsedMilliseconds % 1000).toString().padLeft(2, '0');

    final hundredths = (millis.substring(0, 2));  // Get first two digits for hundredths
    return "$hours:$minutes:$seconds.$hundredths"; // Display in format: HH:MM:SS.MS
  }

  StopwatchProvider(this.stopwatchRepository) {
    _listenToFirebase(); // Listen for real-time sync
  }

  void start() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(Duration(milliseconds: 10), (_) {
      _elapsedMilliseconds += 10;  // Update every 10 milliseconds
      _updateFirebase();
      notifyListeners();
    });
    notifyListeners();
  }

  void stop() {
    if (!isRunning) return;
    _timer.cancel();
    isRunning = false;
    notifyListeners();
  }

  void reset() {
    stop();
    _elapsedMilliseconds = 0;
    _updateFirebase();
    notifyListeners();
  }

  Future<void> _updateFirebase() async {
    await stopwatchRepository.updateStopwatchData(displayTime);
  }

  void _listenToFirebase() {
    Timer.periodic(Duration(seconds: 1), (_) async {
      if (!isRunning) {
        try {
          final timeString = await stopwatchRepository.fetchStopwatchData();
          final parts = timeString.split(':');
          if (parts.length == 3) {
            final secondsParts = parts[2].split('.');
            if (secondsParts.length == 2) {
              final hours = int.parse(parts[0]);
              final minutes = int.parse(parts[1]);
              final seconds = int.parse(secondsParts[0]);
              final millis = int.parse(secondsParts[1]);

              _elapsedMilliseconds = ((hours * 3600 + minutes * 60 + seconds) * 1000) + millis;
              notifyListeners();
            }
          }
        } catch (_) {}
      }
    });
  }
}
