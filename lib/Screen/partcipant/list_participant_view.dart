import 'package:flutter/material.dart';
import '../../model/participant_model.dart';
import 'widgets/participant_card.dart';
import 'widgets/participantform.dart';
import '../../provider/participant_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/participant_profile.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<void> _fetchParticipantsFuture;

  @override
  void initState() {
    super.initState();
    _fetchParticipantsFuture = Provider.of<ParticipantProvider>(context, listen: false).fetchParticipants();
  }

  void _confirmDelete(BuildContext context, Participant participant, ParticipantProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Participant"),
        content: Text("Are you sure you want to delete this participant?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteParticipant(participant.id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final participantProvider = Provider.of<ParticipantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Participants"),
      ),
      body: FutureBuilder<void>(
        future: _fetchParticipantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          final participants = participantProvider.participants;

          return Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ParticipantForm(
                      isEditing: false,
                      onSubmit: participantProvider.addParticipant,
                      participantProvider: participantProvider,
                    ),
                  ));
                },
                child: Text('Add New Participant'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return Dismissible(
                      key: Key(participant.id.toString()),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        _confirmDelete(context, participant, participantProvider);
                        return false; // Don't auto dismiss until confirmed manually
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final updatedParticipant = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ParticipantProfileScreen(participant: participant),
                            ),
                          );
                          if (updatedParticipant != null) {
                            participantProvider.updateParticipant(updatedParticipant);
                          }
                        },
                        child: ParticipantCard(participant: participant),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
