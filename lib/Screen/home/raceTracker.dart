// lib/screen/home/raceTracker.dart

import 'package:flutter/material.dart';
import '../tracking/participant_tracking_screen.dart';
import 'result_view.dart'; // Import your result view screen
import '../../model/race_model.dart'; // Import the Race model

class RaceTracker extends StatelessWidget {
  final Race race;

  const RaceTracker({Key? key, required this.race}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isManager = false; // or get the value dynamically
    return DefaultTabController(
      length: 2, // Only two tabs now
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF5C6BC0),
          title: const Text(
            "Race Tracker",
            style: TextStyle(color: Colors.white),
          ),

        ),
        body: TabBarView(
          children: [
            TrackingScreen(race: race),
            // Pass the isManager parameter here
            ResultsListView(isManager: isManager),
          ],
        ),
      ),
    );
  }
}
