import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';

class MetricsRepositoryImpl implements MetricsRepository {
  @override
  Future<Coverage> getCoverage(String projectId) {
    return Future.delayed(Duration(seconds: 1), () => Coverage(percent: 0.2));
  }
}
