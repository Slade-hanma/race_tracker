abstract class StopwatchRepository {
  Future<String> fetchStopwatchData();
  Future<void> updateStopwatchData(String time);
}
