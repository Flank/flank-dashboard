import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/coverage.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';

class GetProjectCoverage extends UseCase<Coverage, ProjectIdParam> {
  final MetricsRepository _repository;

  GetProjectCoverage(this._repository);

  @override
  Future<Coverage> call(params) {
    return _repository.getCoverage(params.projectId);
  }
}

class ProjectIdParam extends Equatable {
  final String projectId;

  ProjectIdParam({@required this.projectId});

  @override
  List<Object> get props => [projectId];
}
