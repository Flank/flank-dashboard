import 'dart:async';

import 'package:metrics/core/usecases/usecase.dart';
import 'package:metrics/features/dashboard/domain/entities/core/project.dart';
import 'package:metrics/features/dashboard/domain/repositories/metrics_repository.dart';

/// Provides an the ability to receive [Project]s updates.
class ReceiveProjectUpdates implements UseCase<Stream<List<Project>>, void> {
  final MetricsRepository _repository;

  /// Creates the [ReceiveProjectUpdates] use case with the given [MetricsRepository].
  const ReceiveProjectUpdates(this._repository);

  @override
  Stream<List<Project>> call([_]) {
    return _repository.projectsStream();
  }
}
