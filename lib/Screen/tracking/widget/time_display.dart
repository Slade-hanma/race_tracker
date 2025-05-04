import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final String time;

  const TimeDisplay({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: TextStyle(fontSize: 20),
    );
  }
}
