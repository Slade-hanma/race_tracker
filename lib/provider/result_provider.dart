// lib/providers/result_provider.dart


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

  Future<void> removeResult(String bibNumber) async {
    await resultRepo.removeResult(bibNumber);
    _results.removeWhere((result) => result.participant.bibNumber == bibNumber);
    notifyListeners();
  }

}
