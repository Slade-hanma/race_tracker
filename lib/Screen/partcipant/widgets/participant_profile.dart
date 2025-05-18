// lib/screen/participant/wodgets/participant_profile.dart


import 'package:flutter/material.dart';
import '../../../model/participant_model.dart';
import 'participantform.dart';
import '../../../provider/participant_provider.dart';
import 'package:provider/provider.dart';

class ParticipantProfileScreen extends StatelessWidget {
  final Participant participant;

  const ParticipantProfileScreen({Key? key, required this.participant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participantProvider =
        Provider.of<ParticipantProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom top bar
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 12),
            color: const Color(0xFF5C6BC0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Aquathons",
                  style: TextStyle(
                    color: Colors.white, // changed to white
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.white, // changed to white
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Participant info layout
          Expanded(
            child: Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField("Name*", participant.name),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            "Date of Birth",
                            "${participant.dateOfBirth.day.toString().padLeft(2, '0')}/"
                            "${participant.dateOfBirth.month.toString().padLeft(2, '0')}/"
                            "${participant.dateOfBirth.year}",
                            icon: Icons.calendar_today,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField("Gender*", participant.sex),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildField("School", participant.school),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildField("BIB Number", participant.bibNumber),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C6BC0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // changed to white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black, // changed to black for readability
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
