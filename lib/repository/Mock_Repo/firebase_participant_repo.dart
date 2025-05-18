// lib/repositories/firebase_participant_repo.dart

import 'dart:convert';
import '../../model/participant_model.dart';
import '../participant_repo.dart';
import '../../data/participant_dto.dart';
import 'firebase_base_repo.dart';

class FirebaseParticipantRepo extends FirebaseBaseRepo implements ParticipantRepository {
  int _lastId = 0;

  @override
  int getNextId() {
    _lastId++;
    return _lastId;
  }

  @override
@override
Future<List<Participant>> getParticipants() async {
  try {
    final response = await get('participants');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data == null) {
        return [];
      }

      if (data is Map<String, dynamic>) {
        final participants = data.entries
            .map((entry) {
              final participantData = Map<String, dynamic>.from(entry.value);
              return ParticipantDTO.fromJson(participantData).toModel();
            })
            .toList();

        return participants;
      } else if (data is List) {
        final participants = data
            .where((item) => item != null)
            .map((item) =>
                ParticipantDTO.fromJson(Map<String, dynamic>.from(item))
                    .toModel())
            .toList();

        return participants;
      } else {
        // Unrecognized format
        throw Exception("Unexpected data format");
      }
    } else {
      throw Exception('Failed to load participants: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching participants: $e');
    throw Exception('Failed to load participants');
  }
}





  @override
  Future<void> addParticipant(Participant participant) async {
    final response = await post('participants', ParticipantDTO.toJson(participant));
    if (response.statusCode != 200) {
      throw Exception('Failed to add participant');
    }
  }

  @override
  Future<void> updateParticipant(Participant updated) async {
    final response = await put('participants/${updated.id}', ParticipantDTO.toJson(updated));
    if (response.statusCode != 200) {
      throw Exception('Failed to update participant');
    }
  }

  @override
  Future<void> deleteParticipant(int id) async {
    final response = await delete('participants/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete participant');
    }
  }
}
