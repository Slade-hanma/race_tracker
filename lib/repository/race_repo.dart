import '../model/race_model.dart';

abstract class RaceRepository {
  Future<List<Race>> getRaces();
  Future<void> addRace(Race race);
}
