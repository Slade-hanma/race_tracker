import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/race_model.dart';
import '../../model/participant_model.dart';
import '../../model/result_model.dart';

import '../../provider/participant_provider.dart';
import '../../provider/stopwatch_provider.dart';
import '../../provider/selection_provider.dart';
import '../../provider/result_provider.dart';
import '../../provider/notification_provider.dart';

enum ActivityType { swimming, biking, running }

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
    _fetchParticipantsFuture = Provider.of<ParticipantProvider>(
      context,
      listen: false,
    ).fetchParticipants();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              const SubmitFooter(),
            ],
          );
        },
      ),
    );
  }
}

class ParticipantGrid extends StatelessWidget {
  final List<Participant> participants;
  final Race race;
  final ActivityType activityType;

  const ParticipantGrid({
    Key? key,
    required this.participants,
    required this.race,
    required this.activityType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: participants.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemBuilder: (context, index) {
        return ParticipantTrackingCard(
          participant: participants[index],
          race: race,
          activityType: activityType,
        );
      },
    );
  }
}

class SubmitFooter extends StatelessWidget {
  const SubmitFooter({Key? key}) : super(key: key);

  void submitAll(BuildContext context) {
    final selectionProvider = context.read<SelectionProvider>();
    final resultProvider = context.read<ResultProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    for (final result in selectionProvider.selectedResults) {
      resultProvider.addResult(result); // Triggers notification internally
    }


    notificationProvider.addNotification('Race results have been submitted.');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Submitted to result list")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = context.watch<SelectionProvider>().selectedResults.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedCount > 0)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("$selectedCount participants selected"),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(color: Color(0xFF5B6FC2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<StopwatchProvider>(
                builder: (context, stopwatchProvider, _) {
                  final stopwatchTime = stopwatchProvider.displayTime;
                  return Text(
                    stopwatchTime,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: selectedCount > 0 ? () => submitAll(context) : null,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class ParticipantTrackingCard extends StatelessWidget {
  final Participant participant;
  final Race race;
  final ActivityType activityType;

  const ParticipantTrackingCard({
    Key? key,
    required this.participant,
    required this.race,
    required this.activityType,
  }) : super(key: key);

  Duration parseDuration(String time) {
    final parts = time.split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final sAndMs = parts[2].split('.');
    final s = int.parse(sAndMs[0]);
    final ms = int.parse(sAndMs[1]);
    return Duration(hours: h, minutes: m, seconds: s, milliseconds: ms);
  }

  String sumDurationsAsString(List<String> times) {
    final total = times.map(parseDuration).reduce((a, b) => a + b);
    final h = total.inHours.toString().padLeft(2, '0');
    final m = (total.inMinutes % 60).toString().padLeft(2, '0');
    final s = (total.inSeconds % 60).toString().padLeft(2, '0');
    final ms = (total.inMilliseconds % 1000).toString().padLeft(3, '0');
    return "$h:$m:$s.$ms";
  }

  @override
  Widget build(BuildContext context) {
    final selectionProvider = context.watch<SelectionProvider>();

    return Consumer<StopwatchProvider>(
      builder: (context, stopwatchProvider, _) {
        final savedResult = selectionProvider.getResult(participant.bibNumber);

        String savedTime;
        switch (activityType) {
          case ActivityType.swimming:
            savedTime = savedResult?.swimmingTime ?? "00:00:00.000";
            break;
          case ActivityType.biking:
            savedTime = savedResult?.bikingTime ?? "00:00:00.000";
            break;
          case ActivityType.running:
            savedTime = savedResult?.runningTime ?? "00:00:00.000";
            break;
        }

        final hasSavedTime = savedTime != "00:00:00.000";
        final displayTime = hasSavedTime ? savedTime : stopwatchProvider.displayTime;

        final isSelected = selectionProvider.isSelected(participant.bibNumber, activityType);

        return GestureDetector(
         onTap: () {
            final selectionProvider = context.read<SelectionProvider>();
            final stopwatchProvider = context.read<StopwatchProvider>();

            final oldResult = selectionProvider.getResult(participant.bibNumber);

            String swimming = oldResult?.swimmingTime ?? "00:00:00.000";
            String biking = oldResult?.bikingTime ?? "00:00:00.000";
            String running = oldResult?.runningTime ?? "00:00:00.000";

            // Check if saved time for this activity exists and is NOT "00:00:00.000"
            final savedTimeForActivity = (() {
              switch (activityType) {
                case ActivityType.swimming: return swimming;
                case ActivityType.biking: return biking;
                case ActivityType.running: return running;
              }
            })();

            final hasSavedTime = savedTimeForActivity != "00:00:00.000";
            final currentTime = stopwatchProvider.displayTime;

            if (!hasSavedTime) {
              // Save current stopwatch time
              switch (activityType) {
                case ActivityType.swimming:
                  swimming = currentTime;
                  break;
                case ActivityType.biking:
                  biking = currentTime;
                  break;
                case ActivityType.running:
                  running = currentTime;
                  break;
              }
            } else {
              // Clear saved time to revert to live stopwatch time
              switch (activityType) {
                case ActivityType.swimming:
                  swimming = "00:00:00.000";
                  break;
                case ActivityType.biking:
                  biking = "00:00:00.000";
                  break;
                case ActivityType.running:
                  running = "00:00:00.000";
                  break;
              }
            }

            final finish = sumDurationsAsString([swimming, biking, running]);

            final updatedResult = Result(
              participant: participant,
              race: race,
              swimmingTime: swimming,
              bikingTime: biking,
              runningTime: running,
              finishTime: finish,
            );

            selectionProvider.setResult(participant.bibNumber, updatedResult);

            // Also update selection state accordingly:
            if (!hasSavedTime) {
              selectionProvider.addActivity(participant.bibNumber, activityType);
            } else {
              selectionProvider.removeActivity(participant.bibNumber, activityType);
            }
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 250,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1E88E5)
                  : const Color(0xFF5B6FC2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        participant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        participant.school,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontFamily: "RobotoMono",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}






