// lib/screen/home/raceManagement.dart

import 'package:flutter/material.dart';
import '../stopwatch/stopwatch.dart';
import '../partcipant/list_participant_view.dart'; 
import 'result_view.dart'; 
import '../../model/race_model.dart'; 

class RaceScreen extends StatelessWidget {
  final Race race;

  const RaceScreen({Key? key, required this.race}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isManager = true;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5C6BC0), // Indigo color
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            race.raceType,
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Stop Watch"),
              Tab(text: "Participant"),
              Tab(text: "Result"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StopwatchWidget(),
            ListScreen(),
            ResultsListView(isManager: isManager),
          ],
        ),
      ),
    );
  }
}
