import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';

abstract class MetricsRepository {
  Future<Coverage> getCoverage(String projectId);

  Future<List<Build>> getProjectBuilds(String projectId);
}
