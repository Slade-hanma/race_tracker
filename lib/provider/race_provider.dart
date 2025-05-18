// lib/providers/race_provider.dart

import 'package:flutter/material.dart';
import '../repository/race_repo.dart';
import '../model/race_model.dart';

class RaceProvider with ChangeNotifier {
  final RaceRepository  _repo;

  RaceProvider(this._repo);

  Future<List<Race>> get races => _repo.getRaces();

  void addRace(Race race) {
    _repo.addRace(race);
    notifyListeners();
  }
}
