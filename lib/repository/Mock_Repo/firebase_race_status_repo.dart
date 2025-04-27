import 'dart:convert';
import '../../data/race_status_dto.dart';
import '../../model/race_status_enum.dart';
import '../race_status_repo.dart';
import 'firebase_base_repo.dart';

class FirebaseRaceStatusRepo extends FirebaseBaseRepo implements RaceStatusRepository {
  @override
  Future<RaceStatus> getStatus(String raceId) async {
    final response = await get('statuses/$raceId');
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = jsonDecode(response.body);
      final dto = RaceStatusDTO.fromJson(jsonData);
      return dto.toModel();
    }
    return RaceStatus.pending;
  }

  @override
  Future<void> updateStatus(String raceId, RaceStatus status) async {
    final dto = RaceStatusDTO.fromModel(status);
    await put('statuses/$raceId', dto.toJson());
  }
}
