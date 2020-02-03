import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics/features/dashboard/domain/usecases/parameters/project_id_param.dart';

/// Use case to load the project coverage.
class GetProjectCoverage extends UseCase<Coverage, ProjectIdParam> {
  final MetricsRepository _repository;

  GetProjectCoverage(this._repository);

  @override
  Future<Coverage> call(ProjectIdParam params) {
    return _repository.getCoverage(params.projectId);
  }
}
