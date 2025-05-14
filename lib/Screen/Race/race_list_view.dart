import 'package:flutter/material.dart';
import '../../model/race_model.dart';
import '../home/raceManagement.dart';
import '../../provider/race_provider.dart';
import 'package:provider/provider.dart';
import '../home/raceTracker.dart';
import '../home/race_status.dart';

class RacesListView extends StatelessWidget {
  final bool isManager;

  const RacesListView({Key? key, required this.isManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final raceProvider = Provider.of<RaceProvider>(context);

    return FutureBuilder<List<Race>>(
      future: raceProvider.races,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final races = snapshot.data ?? [];

        if (races.isEmpty) {
          return Center(child: Text("No races available"));
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              final raceDate = race.date; // Format if needed
              final raceTime = race.Time;

              return GestureDetector(
                onTap: () {
                  final destination =
                      isManager
                          ? RaceScreen(race: race)
                          : RaceTracker(race: race);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => destination),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF5B6FC2), // Blue-purple background
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              race.raceType,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: RaceStatusWidget(
                              raceName: race.name,
                              isManager: isManager,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${race.distance} km (${race.raceType})',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            raceTime,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            '$raceDate ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // RaceStatusWidget(
                      //   raceName: race.name,
                      //   isManager: isManager,
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
