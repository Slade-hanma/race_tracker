import 'package:flutter/material.dart';

import '../../../model/activity_type.dart';
import '../../../model/participant_model.dart';
import '../../../model/race_model.dart';
import 'tracking_card.dart';


class ParticipantGrid extends StatelessWidget {
  final List<Participant> participants;
  final Race race;
  final ActivityType activityType;

  const ParticipantGrid({
    Key? key,
    required this.participants,
    required this.race,
    required this.activityType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: participants.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        return ParticipantTrackingCard(
          participant: participants[index],
          race: race,
          activityType: activityType,
        );
      },
    );
  }
}
