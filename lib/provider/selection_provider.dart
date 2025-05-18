import 'package:flutter/material.dart';
import '../Screen/tracking/participant_tracking_screen.dart';
import '../model/result_model.dart';

class SelectionProvider extends ChangeNotifier {
  // Map bibNumber to Result
  final Map<String, Result> _participantResults = {};

  List<Result> get selectedResults => _participantResults.values.toList();

  bool isSelected(String bibNumber, ActivityType activityType) {
    final result = _participantResults[bibNumber];
    switch (activityType) {
      case ActivityType.swimming:
        return result?.swimmingTime != "00:00:00.000";
      case ActivityType.biking:
        return result?.bikingTime != "00:00:00.000";
      case ActivityType.running:
        return result?.runningTime != "00:00:00.000";
    }
  }

  Result? getResult(String bibNumber) {
    return _participantResults[bibNumber];
  }

  void setResult(String bibNumber, Result result) {
    _participantResults[bibNumber] = result;
    notifyListeners();
  }

  void removeActivity(String bibNumber, ActivityType activityType) {
    final current = _participantResults[bibNumber];
    if (current == null) return;

    switch (activityType) {
      case ActivityType.swimming:
        current.swimmingTime = "00:00:00.000";
        break;
      case ActivityType.biking:
        current.bikingTime = "00:00:00.000";
        break;
      case ActivityType.running:
        current.runningTime = "00:00:00.000";
        break;
    }

    current.finishTime = _sumTimes(
      current.swimmingTime,
      current.bikingTime,
      current.runningTime,
    );

    notifyListeners();
  }

  void addActivity(String bibNumber, ActivityType activityType) {
    // Optional method: you can add custom logic here if needed.
    notifyListeners();
  }

  void toggleResult(Result result, ActivityType activityType) {
    final bib = result.participant.bibNumber;
    final current = _participantResults[bib];

    if (current != null) {
      switch (activityType) {
        case ActivityType.swimming:
          current.swimmingTime = result.swimmingTime;
          break;
        case ActivityType.biking:
          current.bikingTime = result.bikingTime;
          break;
        case ActivityType.running:
          current.runningTime = result.runningTime;
          break;
      }
      current.finishTime = _sumTimes(
        current.swimmingTime,
        current.bikingTime,
        current.runningTime,
      );
    } else {
      final newResult = Result(
        participant: result.participant,
        race: result.race,
        swimmingTime: activityType == ActivityType.swimming ? result.swimmingTime : "00:00:00.000",
        bikingTime: activityType == ActivityType.biking ? result.bikingTime : "00:00:00.000",
        runningTime: activityType == ActivityType.running ? result.runningTime : "00:00:00.000",
        finishTime: "00:00:00.000",
      );
      newResult.finishTime = _sumTimes(
        newResult.swimmingTime,
        newResult.bikingTime,
        newResult.runningTime,
      );
      _participantResults[bib] = newResult;
    }

    notifyListeners();
  }


  String _sumTimes(String s1, String s2, String s3) {
    final d1 = _parseDuration(s1);
    final d2 = _parseDuration(s2);
    final d3 = _parseDuration(s3);
    final total = d1 + d2 + d3;

    final h = total.inHours.toString().padLeft(2, '0');
    final m = (total.inMinutes % 60).toString().padLeft(2, '0');
    final s = (total.inSeconds % 60).toString().padLeft(2, '0');
    final ms = (total.inMilliseconds % 1000).toString().padLeft(3, '0');
    return "$h:$m:$s.$ms";
  }

  Duration _parseDuration(String time) {
    final parts = time.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final sAndMs = parts[2].split('.');
    final s = int.parse(sAndMs[0]);
    final ms = int.parse(sAndMs[1]);
    return Duration(hours: h, minutes: m, seconds: s, milliseconds: ms);
  }
}
