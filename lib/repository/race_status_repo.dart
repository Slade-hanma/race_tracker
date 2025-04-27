// lib/repository/race_status_repo.dart

import '../../model/race_status_enum.dart';

abstract class RaceStatusRepository {
  Future<RaceStatus> getStatus(String raceId);
  Future<void> updateStatus(String raceId, RaceStatus status);
}
