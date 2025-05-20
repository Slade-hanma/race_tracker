import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/activity_type.dart';
import '../../model/race_model.dart';
import '../../provider/participant_provider.dart';
import '../../provider/selection_provider.dart';
import 'widget/tracking_footer.dart';
import 'widget/tracking_grid.dart';
import 'widget/timelogged_table.dart';

class TrackingScreen extends StatefulWidget {
  final Race race;
  const TrackingScreen({Key? key, required this.race}) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late Future<void> _fetchParticipantsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchParticipantsFuture =
        Provider.of<ParticipantProvider>(
          context,
          listen: false,
        ).fetchParticipants();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // update table when tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ActivityType get currentActivityType {
    switch (_tabController.index) {
      case 0:
        return ActivityType.swimming;
      case 1:
        return ActivityType.biking;
      case 2:
        return ActivityType.running;
      default:
        return ActivityType.swimming;
    }
  }

  Widget buildTab(ActivityType type) {
    IconData icon;
    switch (type) {
      case ActivityType.swimming:
        icon = Icons.pool;
        break;
      case ActivityType.biking:
        icon = Icons.directions_bike;
        break;
      case ActivityType.running:
        icon = Icons.directions_run;
        break;
    }
    return Tab(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[700],
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final participantProvider = context.watch<ParticipantProvider>();
    final selectionProvider = context.watch<SelectionProvider>();
    final selectedResults = selectionProvider.selectedResults;

    // Build table data based on the current activity
    List<Map<String, String>> tableData =
        selectedResults.map((result) {
          String time;
          switch (currentActivityType) {
            case ActivityType.swimming:
              time = result.swimmingTime;
              break;
            case ActivityType.biking:
              time = result.bikingTime;
              break;
            case ActivityType.running:
              time = result.runningTime;
              break;
          }
          return {'bib': 'BIB ${result.participant.bibNumber}', 'time': time};
        }).toList();

    return Scaffold(
      body: FutureBuilder<void>(
        future: _fetchParticipantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error loading participants: ${snapshot.error}"),
            );
          }
          final participants = participantProvider.participants;
          return Column(
            children: [
              const SizedBox(height: 40),
              TabBar(
                controller: _tabController,
                tabs: [
                  buildTab(ActivityType.swimming),
                  buildTab(ActivityType.biking),
                  buildTab(ActivityType.running),
                ],
                indicatorColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              // The participant grid takes all available space above the table/footer
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ParticipantGrid(
                      participants: participants,
                      race: widget.race,
                      activityType: ActivityType.swimming,
                    ),
                    ParticipantGrid(
                      participants: participants,
                      race: widget.race,
                      activityType: ActivityType.biking,
                    ),
                    ParticipantGrid(
                      participants: participants,
                      race: widget.race,
                      activityType: ActivityType.running,
                    ),
                  ],
                ),
              ),
              // Table area, fixed max height, scrollable if overflow
              if (selectedResults.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 260, // adjust as needed!
                  ),
                  width: double.infinity,
                  child: LoggedTimeTable(
                    data: tableData,
                    onUndo: (bib) {
                      final bibNumber = int.tryParse(
                        bib.replaceAll(RegExp(r'[^0-9]'), ''),
                      );
                      if (bibNumber != null) {
                        selectionProvider.removeActivity(
                          bibNumber.toString(),
                          currentActivityType,
                        );
                      }
                    },
                    onMark: (bib) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('$bib marked!')));
                    },
                  ),
                ),
              // Footer always at bottom
              const SubmitFooter(),
            ],
          );
        },
      ),
    );
  }
}
