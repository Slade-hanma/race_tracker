import 'package:flutter/material.dart';
import '../../../model/participant_model.dart';
import 'participantform.dart';
import '../../../provider/participant_provider.dart';
import 'package:provider/provider.dart';

class ParticipantProfileScreen extends StatelessWidget {
  final Participant participant;

  const ParticipantProfileScreen({Key? key, required this.participant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participantProvider = Provider.of<ParticipantProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedParticipant = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ParticipantForm(
                    isEditing: true,
                    onSubmit: participantProvider.updateParticipant,
                    participantProvider: participantProvider,
                    participant: participant,
                  ),
                ),
              );

              if (updatedParticipant != null) {
                Navigator.pop(context, updatedParticipant);
              }
            },
            child: Text("Edit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Name: ${participant.name}'),
            Text('Sex: ${participant.sex}'),
            Text('Date of Birth: ${participant.dateOfBirth.toLocal().toIso8601String().split('T')[0]}'),
            Text('School: ${participant.school}'),
            Text('Bib Number: ${participant.bibNumber}'),
          ],
        ),
      ),
    );
  }
}
