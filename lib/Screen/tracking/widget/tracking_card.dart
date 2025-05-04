// // widgets/participant_tracking_card.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../model/participant_model.dart';
// import '../../../model/race_model.dart';
// import '../../../model/result_model.dart';
// import 'time_display.dart';
// import '../../../provider/stopwatch_provider.dart';
// import '../../../provider/selection_provider.dart';

// class ParticipantTrackingCard extends StatelessWidget {
//   final Participant participant;
//   final Race race;
//   final StopwatchProvider stopwatchProvider;

//   const ParticipantTrackingCard({
//     Key? key,
//     required this.participant,
//     required this.race,
//     required this.stopwatchProvider,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final stopwatchProvider = context.watch<StopwatchProvider>();
//     final selectionProvider = context.watch<SelectionProvider>();
//     final currentTime = stopwatchProvider.displayTime;

//     final isSelected = selectionProvider.isSelected(participant.bibNumber);
//     final result = selectionProvider.getResult(participant.bibNumber);

//     return GestureDetector(
//       onTap: () {
//         final result = Result(
//           participant: participant,
//           race: race,
//           finishTime: currentTime,
//         );
//         context.read<SelectionProvider>().toggleResult(result);
//       },

//       child: Card(
//         color: isSelected ? Colors.green.shade100 : null,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Text(
//                 'Bib #: ${participant.bibNumber}',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TimeDisplay(
//                 time:
//                     isSelected && result != null
//                         ? result.finishTime
//                         : currentTime,
//               ),
//               const SizedBox(height: 10),
//               if (isSelected && result != null)
//                 Text(
//                   'Selected Time:\n${result.finishTime}',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               const SizedBox(height: 10),
//               // Text(
//               //   isSelected ? 'Selected' : 'Tap to select',
//               //   style: TextStyle(
//               //     color: isSelected ? Colors.green.shade700 : Colors.black54,
//               //     fontWeight: FontWeight.w500,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// widgets/participant_tracking_card.dart
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
