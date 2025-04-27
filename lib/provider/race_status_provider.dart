// lib/provider/race_status_provider.dart

import 'package:flutter/material.dart';
import '../repository/race_status_repo.dart';
import '../model/race_status_enum.dart';

class RaceStatusProvider with ChangeNotifier {
  final RaceStatusRepository _repo;

  final Map<String, RaceStatus> _statuses = {};

  RaceStatusProvider(this._repo);

  RaceStatus getStatus(String raceId) =>
      _statuses[raceId] ?? RaceStatus.pending;

  Future<void> fetchStatus(String raceId) async {
    final status = await _repo.getStatus(raceId);
    _statuses[raceId] = status;
    notifyListeners();
  }

  Future<void> updateStatus(String raceId, RaceStatus status) async {
    _statuses[raceId] = status;
    notifyListeners(); // Update UI instantly
    await _repo.updateStatus(raceId, status);
  }
}
