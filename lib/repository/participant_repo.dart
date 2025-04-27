import '../model/participant_model.dart';

abstract class ParticipantRepository {
  Future<List<Participant>> getParticipants();
  Future<void> addParticipant(Participant participant);
  Future<void> updateParticipant(Participant updated);
  Future<void> deleteParticipant(int id);  // Use int as ID
  int getNextId();
}
