import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/build.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';

/// Use case to load the build metrics
class GetBuildMetrics implements UseCase<List<Build>, ProjectIdParam> {
  final MetricsRepository _repository;

  GetBuildMetrics(this._repository);

  @override
  Future<List<Build>> call(ProjectIdParam param) {
    return _repository.getProjectBuilds(param.projectId);
  }
}
