// lib/result_model.dart
import 'participant_model.dart';
import 'race_model.dart';

class Result {
  final Participant participant;
  final Race race;
  String finishTime;
  String swimmingTime;
  String bikingTime;
  String runningTime;

  Result({
    required this.participant,
    required this.race,
    required this.finishTime,
    required this.swimmingTime,
    required this.bikingTime,
    required this.runningTime,
  });

  Duration _parseDuration(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secondsAndMillis = parts[2].split('.');
    final seconds = int.parse(secondsAndMillis[0]);
    final milliseconds = int.parse(secondsAndMillis[1]);
    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  Duration get finishDuration => _parseDuration(finishTime);
  Duration get swimmingDuration => _parseDuration(swimmingTime);
  Duration get bikingDuration => _parseDuration(bikingTime);
  Duration get runningDuration => _parseDuration(runningTime);
}
