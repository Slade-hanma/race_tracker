// lib/models/race_status_enum.dart

import 'package:flutter/material.dart';

enum RaceStatus {
  pending('Pending', Color(0xFFD8D8D8), Colors.white),
  started('Started', Color(0xFF009688), Colors.white),
  finished('Finished', Colors.red, Colors.white);

  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RaceStatus(this.label, this.backgroundColor, this.textColor);
}

RaceStatus raceStatusFromString(String value) => RaceStatus.values.firstWhere(
  (e) => e.name == value,
  orElse: () => RaceStatus.pending,
);

String raceStatusToString(RaceStatus status) => status.name;
