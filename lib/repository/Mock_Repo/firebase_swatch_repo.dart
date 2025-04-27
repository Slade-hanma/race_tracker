// lib/repository/Mock_Repo/firebase_swatch_repo.dart
import 'dart:convert';
import '../stopwatch_repo.dart';
import 'firebase_base_repo.dart';

class FirebaseSwatchRepo implements StopwatchRepository {
  final FirebaseBaseRepo _baseRepo;

  FirebaseSwatchRepo(this._baseRepo);

  // Fetch stopwatch data from Firebase
  Future<String> fetchStopwatchData() async {
    final response = await _baseRepo.get('stopwatch/data');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['time'] ?? '00:00:00'; // Default to '00:00:00' if no time exists
    } else {
      throw Exception('Failed to load stopwatch data');
    }
  }

  // Update stopwatch data in Firebase
  Future<void> updateStopwatchData(String time) async {
    final data = {'time': time};
    await _baseRepo.put('stopwatch/data', data);
  }
}
