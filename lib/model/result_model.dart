// lib/result_model.dart
import 'participant_model.dart'; 
import 'race_model.dart'; 

class Result {
  final Participant participant; 
  final Race race; 
  final String finishTime; 

  Result({
    required this.participant,
    required this.race,
    required this.finishTime,
  });

   Duration get finishDuration {
    final parts = finishTime.split(':');
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
}
