// lib/screen/participant/wodgets/participant_card.dart


import 'package:flutter/material.dart';
import '../../../../model/participant_model.dart';
import 'package:intl/intl.dart';

class ParticipantCard extends StatelessWidget {
  final Participant participant;

  const ParticipantCard({Key? key, required this.participant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dobFormatted = DateFormat('yyyy-MM-dd').format(participant.dateOfBirth);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5C6BC0), // Blue background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Yellow circular bib number
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              participant.bibNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Participant info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Sex: ${participant.sex}",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "DOB: $dobFormatted",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "School: ${participant.school}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
