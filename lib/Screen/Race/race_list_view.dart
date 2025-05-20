// lib/screen/race/race_list_view.dart

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

    return Scaffold(

      body: FutureBuilder<List<Race>>(
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF5B6FC2),
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
                              race.Time,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              race.date,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: isManager
          ? FloatingActionButton(
              backgroundColor: Color(0xFF5B6FC2),
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddRaceDialog(),
                );
              },
            )
          : null,
    );
  }
}


class AddRaceDialog extends StatefulWidget {
  @override
  _AddRaceDialogState createState() => _AddRaceDialogState();
}

class _AddRaceDialogState extends State<AddRaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _distanceController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final raceProvider = Provider.of<RaceProvider>(context, listen: false);

    return AlertDialog(
      title: Text('Add New Race'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Race Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter race name' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Race Type'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter race type' : null,
              ),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(labelText: 'Distance (km)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter distance' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date (e.g. 2025-05-17)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time (e.g. 10:00 AM)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter time' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newRace = Race(
                name: _nameController.text,
                raceType: _typeController.text,
                distance: double.tryParse(_distanceController.text) ?? 0,
                date: _dateController.text,
                Time: _timeController.text,
              );
              raceProvider.addRace(newRace);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
