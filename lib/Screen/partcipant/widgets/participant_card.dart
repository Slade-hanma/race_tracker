import 'package:flutter/material.dart';
import '../../../model/participant_model.dart';
import 'package:intl/intl.dart';

class ParticipantCard extends StatelessWidget {
  final Participant participant;

  const ParticipantCard({Key? key, required this.participant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dobFormatted = DateFormat('yyyy-MM-dd').format(participant.dateOfBirth);
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      
      child: Container(
       // Set the width
        height: 150.0,
        child: ListTile(
          
          title: Text(participant.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sex: ${participant.sex}"),
              Text("DOB: $dobFormatted"),
              Text("School: ${participant.school}"),
              Text("Bib #: ${participant.bibNumber}"),
            ],
          ),
        ),
      ),
    );
  }
}
