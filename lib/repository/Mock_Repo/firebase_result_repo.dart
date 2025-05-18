// lib/repositories/firebase_result_repo.dart


import 'dart:convert';
import '../../data/result_dto.dart';
import '../../model/result_model.dart';
import '../result_repo.dart';
import 'firebase_base_repo.dart';

class FirebaseResultRepo extends FirebaseBaseRepo implements ResultRepository {
  @override
  Future<List<Result>> getResults() async {
    final response = await get('results');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>?;

      if (data == null) return [];

      return data.values
          .map((r) => ResultDTO.fromJson(Map<String, dynamic>.from(r)).toModel())
          .toList();
    }
    throw Exception('Failed to load results');
  }

  @override
  Future<void> addResult(Result result) async {
    final response = await post('results', ResultDTO.toJson(result));
    if (response.statusCode != 200) {
      throw Exception('Failed to add result');
    }
  }

  @override
  Future<void> removeResult(String bibNumber) async {
    final response = await get('results');
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch results for deletion');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>?;

    if (data == null) return;

    // Find entry with matching participant.bibNumber
    final entry = data.entries.firstWhere(
      (entry) =>
          entry.value['participant']['bibNumber'] == bibNumber,
      orElse: () => throw Exception('Result not found'),
    );

    final key = entry.key;

    final deleteResponse = await delete('results/$key');
    if (deleteResponse.statusCode != 200) {
      throw Exception('Failed to delete result');
    }
  }

}
