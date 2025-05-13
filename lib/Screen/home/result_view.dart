import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/result_provider.dart';
import '../../model/result_model.dart';

class ResultsListView extends StatelessWidget {
  final bool isManager;

  ResultsListView({required this.isManager});

  String _formatRank(int index, String finishTime) {
    if (finishTime == 'N/A') return 'N/A';
    switch (index + 1) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${index + 1}th';
    }
  }

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

        return Column(
          children: [
            const SizedBox(height: 8),
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Center(
                          child: Text('Rank',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600))),
                    ),
                    Expanded(
                      child: Center(
                          child: Text('Bib',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600))),
                    ),
                    Expanded(
                      child: Center(
                          child: Text('Participants Name',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600))),
                    ),
                    Expanded(
                      child: Center(
                          child: Text('Swim Time',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  final rank = _formatRank(index, result.finishTime);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7986CB),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(rank,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14))),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(result.participant.bibNumber,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14))),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(result.participant.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14))),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(result.finishTime,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14))),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
