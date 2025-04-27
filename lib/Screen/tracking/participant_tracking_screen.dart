import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/race_model.dart';
import '../../provider/participant_provider.dart';
import 'widget/tracking_card.dart';
import 'widget/tracking_footer.dart';
import '../../provider/stopwatch_provider.dart';

class TrackingScreen extends StatefulWidget {
  final Race race;

  const TrackingScreen({Key? key, required this.race}) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late Future<void> _fetchParticipantsFuture;

  @override
  void initState() {
    super.initState();
    // Load participants from the provider
    _fetchParticipantsFuture = Provider.of<ParticipantProvider>(context, listen: false).fetchParticipants();
  }

  @override
  Widget build(BuildContext context) {
    final stopwatchProvider = context.read<StopwatchProvider>();
    final participantProvider = context.watch<ParticipantProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Participants"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<void>(
        future: _fetchParticipantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading participants: ${snapshot.error}"));
          }

          final participants = participantProvider.participants;

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: participants.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    return ParticipantTrackingCard(
                      participant: participants[index],
                      race: widget.race,
                      stopwatchProvider: stopwatchProvider,
                    );
                  },
                ),
              ),
              SubmitFooter(stopwatchProvider: stopwatchProvider),
            ],
          );
        },
      ),
    );
  }
}
