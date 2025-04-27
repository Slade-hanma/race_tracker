import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/result_provider.dart';
import '../../model/result_model.dart';

class ResultsListView extends StatelessWidget {
  final bool isManager; // Passed to the constructor to determine if the user is a manager

  ResultsListView({required this.isManager});

  @override
  Widget build(BuildContext context) {
    final resultProvider = Provider.of<ResultProvider>(context, listen: false);

    return FutureBuilder<List<Result>>(
      future: resultProvider.getResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No results found."));
        }

        final results = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Expanded(child: Center(child: Text('Rank'))),
                  Expanded(child: Center(child: Text('BIB'))),
                  Expanded(child: Center(child: Text('Name'))),
                  Expanded(child: Center(child: Text('Race Name'))), // Race Name Column
                  Expanded(child: Center(child: Text('Race Date'))), // Race Date Column
                  Expanded(child: Center(child: Text('Finish Time'))),
                ],
              ),
              const Divider(),
              // Results List
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Center(child: Text('${index + 1}'))),
                          Expanded(child: Center(child: Text(result.participant.bibNumber))),
                          Expanded(child: Center(child: Text(result.participant.name))),
                          Expanded(child: Center(child: Text(result.race.name))), // Race Name
                          Expanded(child: Center(child: Text(result.race.date.toString()))), // Race Date
                          Expanded(child: Center(child: Text(result.finishTime))),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
