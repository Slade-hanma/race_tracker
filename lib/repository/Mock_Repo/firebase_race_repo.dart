// lib/repositories/firebase_race_repo.dart

import 'dart:convert';
import '../../data/race_dto.dart';
import '../../model/race_model.dart';
import '../race_repo.dart';
import 'firebase_base_repo.dart';

class FirebaseRaceRepo extends FirebaseBaseRepo implements RaceRepository {
  @override
  Future<List<Race>> getRaces() async {
  final response = await get('races');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];

    // Iterate over the keys (e.g., "racemarathon") and map each race to a Race model
    return data.entries.map((entry) {
      // entry.key will be the race ID (like "racemarathon")
      // entry.value will be the race details (like name, date, etc.)
      return RaceDTO.fromJson(Map<String, dynamic>.from(entry.value)).toModel();
    }).toList();
  }
  throw Exception('Failed to load races');
}


  @override
  Future<void> addRace(Race race) async {
  final response = await post('races', RaceDTO.toJson(race));
  if (response.statusCode != 200) {
    throw Exception('Failed to add race');
  }
}

  
}

