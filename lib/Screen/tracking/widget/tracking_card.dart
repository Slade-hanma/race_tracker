import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/activity_type.dart';
import '../../../model/participant_model.dart';
import '../../../model/race_model.dart';
import '../../../model/result_model.dart';
import '../../../provider/selection_provider.dart';
import '../../../provider/stopwatch_provider.dart';

class ParticipantTrackingCard extends StatelessWidget {
  final Participant participant;
  final Race race;
  final ActivityType activityType;

  const ParticipantTrackingCard({
    Key? key,
    required this.participant,
    required this.race,
    required this.activityType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectionProvider = context.watch<SelectionProvider>();

    return Consumer<StopwatchProvider>(
      builder: (context, stopwatchProvider, _) {
        final savedResult = selectionProvider.getResult(participant.bibNumber);

        String savedTime;
        switch (activityType) {
          case ActivityType.swimming:
            savedTime = savedResult?.swimmingTime ?? "00:00:00.000";
            break;
          case ActivityType.biking:
            savedTime = savedResult?.bikingTime ?? "00:00:00.000";
            break;
          case ActivityType.running:
            savedTime = savedResult?.runningTime ?? "00:00:00.000";
            break;
        }

        final hasSavedTime = savedTime != "00:00:00.000";
        final displayTime = hasSavedTime ? savedTime : stopwatchProvider.displayTime;

        final isSelected = selectionProvider.isSelected(participant.bibNumber, activityType);

        return GestureDetector(
          onTap: () {
            final selectionProvider = context.read<SelectionProvider>();
            final stopwatchProvider = context.read<StopwatchProvider>();

            final oldResult = selectionProvider.getResult(participant.bibNumber);

            String swimming = oldResult?.swimmingTime ?? "00:00:00.000";
            String biking = oldResult?.bikingTime ?? "00:00:00.000";
            String running = oldResult?.runningTime ?? "00:00:00.000";

            final savedTimeForActivity = (() {
              switch (activityType) {
                case ActivityType.swimming:
                  return swimming;
                case ActivityType.biking:
                  return biking;
                case ActivityType.running:
                  return running;
              }
            })();

            final hasSavedTime = savedTimeForActivity != "00:00:00.000";
            final currentTime = stopwatchProvider.displayTime;

            if (!hasSavedTime) {
              switch (activityType) {
                case ActivityType.swimming:
                  swimming = currentTime;
                  break;
                case ActivityType.biking:
                  biking = currentTime;
                  break;
                case ActivityType.running:
                  running = currentTime;
                  break;
              }
            } else {
              switch (activityType) {
                case ActivityType.swimming:
                  swimming = "00:00:00.000";
                  break;
                case ActivityType.biking:
                  biking = "00:00:00.000";
                  break;
                case ActivityType.running:
                  running = "00:00:00.000";
                  break;
              }
            }

            final updatedResult = Result(
              participant: participant,
              race: race,
              swimmingTime: swimming,
              bikingTime: biking,
              runningTime: running,
              finishTime: "00:00:00.000", // Temporary, will be recalculated by SelectionProvider if needed
            );

            selectionProvider.setResult(participant.bibNumber, updatedResult);

            if (!hasSavedTime) {
              selectionProvider.addActivity(participant.bibNumber, activityType);
            } else {
              selectionProvider.removeActivity(participant.bibNumber, activityType);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 250,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1E88E5)
                  : const Color(0xFF5B6FC2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        participant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        participant.school,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontFamily: "RobotoMono",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
