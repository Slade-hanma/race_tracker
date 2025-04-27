import 'package:flutter/material.dart';
import '../repository/result_repo.dart';
import '../model/result_model.dart';

class ResultProvider extends ChangeNotifier {
  final ResultRepository resultRepo;

  List<Result> _results = [];
  List<Result> get results => _results;

  ResultProvider({required this.resultRepo});

  Future<List<Result>> getResults() async {
    _results = await resultRepo.getResults();
    return _results;
  }

  Future<void> addResult(Result result) async {
    await resultRepo.addResult(result);
    _results.add(result);
    notifyListeners();
  }

  // New method to remove result
  Future<void> removeResult(String resultId) async {
    await resultRepo.removeResult(resultId);
    _results.removeWhere((result) => result.participant.id == resultId); // Assuming participant ID is used as the result ID.
    notifyListeners();
  }
}
