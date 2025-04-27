// lib/provider/selection_provider.dart

import 'package:flutter/material.dart';
import '../model/result_model.dart';

class SelectionProvider with ChangeNotifier {
final Map<String, Result> _selectedMap = {};

  List<Result> get selectedResults => _selectedMap.values.toList();

  bool isSelected(String bibNumber) => _selectedMap.containsKey(bibNumber);

  Result? getResult(String bibNumber) => _selectedMap[bibNumber];

  void toggleResult(Result result) {
    final bib = result.participant.bibNumber;
    if (_selectedMap.containsKey(bib)) {
      _selectedMap.remove(bib);
    } else {
      _selectedMap[bib] = result;
    }
    notifyListeners();
  }

  void clearSelections() {
    _selectedMap.clear();
    notifyListeners();
  }
}
