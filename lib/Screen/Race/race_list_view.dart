import 'package:flutter/material.dart';
import '../../model/race_model.dart';
import '../home/raceManagement.dart';
import '../../provider/race_provider.dart';
import 'package:provider/provider.dart';
import '../home/raceTracker.dart';
import 'race_status.dart';

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
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return GestureDetector(
                onTap: () {
                  final destination = isManager
                      ? RaceScreen(race: race)
                      : RaceTracker(race: race);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => destination),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          race.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Type: ${race.raceType}'),
                        Text('Distance: ${race.distance} km'),
                        Text('Date & Time: ${race.date} ${race.Time}'),
                        SizedBox(height: 12),
                        RaceStatusWidget(
                          raceName: race.name,
                          isManager: isManager,
                        ),
                      ],
                    ),
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
