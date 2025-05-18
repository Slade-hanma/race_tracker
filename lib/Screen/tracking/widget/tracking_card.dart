// lib/screen/tracking/widgets/tracking_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/participant_model.dart';
import '../../../model/race_model.dart';
import '../../../model/result_model.dart';
import 'time_display.dart';
import '../../../provider/stopwatch_provider.dart';
import '../../../provider/selection_provider.dart';

class ParticipantTrackingCard extends StatelessWidget {
  final Participant participant;
  final Race race;
  final StopwatchProvider stopwatchProvider;

  const ParticipantTrackingCard({
    Key? key,
    required this.participant,
    required this.race,
    required this.stopwatchProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = context.watch<StopwatchProvider>();
    final selectionProvider = context.watch<SelectionProvider>();
    final currentTime = stopwatchProvider.displayTime;

    final isSelected = selectionProvider.isSelected(participant.bibNumber);
    final result = selectionProvider.getResult(participant.bibNumber);

    return GestureDetector(

      onTap: () {
        final result = Result(
          participant: participant,
          race: race,
          finishTime: currentTime,
          swimmingTime: "00:00:00.000",
          bikingTime: "00:00:00.000",
          runningTime: "00:00:00.000",
        );
        context.read<SelectionProvider>().toggleResult(result);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 250,
        height: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF1E88E5) // Blue when selected
                  : const Color(0xFF5B6FC2), // Default background
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // keeps it compact
          children: [
            Text(
              '${participant.bibNumber}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: TimeDisplay(
                time:
                    isSelected && result != null
                        ? result.finishTime
                        : currentTime,
                                      ),
            ),
          ],
        ),
      ),
    );


  }
}
