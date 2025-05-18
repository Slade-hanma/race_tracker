// lib/providers/participant_provider.dart

import 'package:flutter/material.dart';
import '../model/participant_model.dart'; // Make sure this import is correct
import '../repository/participant_repo.dart';

class ParticipantProvider with ChangeNotifier {
   final ParticipantRepository _repository;
  bool _disposed = false; // Track if the provider has been disposed

  List<Participant> _participants = [];

  ParticipantProvider(this._repository);

  List<Participant> get participants => _participants;

  @override
  void dispose() {
    _disposed = true;  // Set the flag when disposed
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  // Fetch participants from repository
  Future<void> fetchParticipants() async {
    _participants = await _repository.getParticipants();
    notifyListeners();
  }

  // Get next available ID (wrapper for repository method)
  int getNextId() {
    return _repository.getNextId();  // Delegates to the repository
  }

  // Add a new participant
  Future<void> addParticipant(Participant participant) async {
    await _repository.addParticipant(participant);
    _participants.add(participant);
    notifyListeners();
  }

  // Delete a participant
  Future<void> deleteParticipant(int participantId) async {  // Change String to int here
    await _repository.deleteParticipant(participantId);
    _participants.removeWhere((p) => p.id == participantId);  // Use int for comparison
    notifyListeners();
  }

  // Update a participant
  Future<void> updateParticipant(Participant updatedParticipant) async {
    await _repository.updateParticipant(updatedParticipant);

    // Update the participant in the list
    int index = _participants.indexWhere((p) => p.id == updatedParticipant.id);
    if (index != -1) {
      _participants[index] = updatedParticipant;
    }

    // Notify listeners to update the UI
    notifyListeners();
  }
}
