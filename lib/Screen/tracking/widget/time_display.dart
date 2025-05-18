// lib/screen/tracking/wodgets/time_display.dart

import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final String time;

  const TimeDisplay({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}
