import '../../data/model/params.dart';

abstract class WebsparkRepo {
  Future<ApiResponse?> getInputParameters();
  Future<void> sendAnswers(List<List<List<int>>> paths);
}
