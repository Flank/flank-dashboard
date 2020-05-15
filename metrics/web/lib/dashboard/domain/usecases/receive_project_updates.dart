import 'dart:async';

import 'package:metrics/common/domain/usecases/usecase.dart';
import 'package:metrics/dashboard/domain/repositories/metrics_repository.dart';
import 'package:metrics_core/metrics_core.dart';

/// Provides an the ability to receive [Project]s updates.
class ReceiveProjectUpdates implements UseCase<Stream<List<Project>>, void> {
  final MetricsRepository _repository;

  /// Creates the [ReceiveProjectUpdates] use case with the given [MetricsRepository].
  ///
  /// [MetricsRepository] must not be null.
  const ReceiveProjectUpdates(this._repository) : assert(_repository != null);

  @override
  Stream<List<Project>> call([_]) {
    return _repository.projectsStream();
  }
}
