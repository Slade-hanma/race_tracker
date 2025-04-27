import '../model/result_model.dart';

abstract class ResultRepository {
  Future<List<Result>> getResults();
  Future<void> addResult(Result result);
  
  // Add removeResult method to the interface
  Future<void> removeResult(String resultId); // resultId is the ID of the result you want to remove
}
