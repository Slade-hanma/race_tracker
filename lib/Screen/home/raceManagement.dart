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
    final bool isManager = true; // or get the value dynamically

    return DefaultTabController(
      length: 3, // Only 3 tabs now
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Race Management"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer), text: "Stopwatch"),
              Tab(icon: Icon(Icons.list), text: "Participants"),
              Tab(icon: Icon(Icons.list_alt), text: "Results"),
            ],
          ),
        ),
        body: TabBarView(
            children: [
              StopwatchWidget(),
              ListScreen(),
              // Pass the isManager parameter here
              ResultsListView(isManager: isManager),
            ],
          ),
      ),
    );
  }
}
