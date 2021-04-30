// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/domain/repositories/build_day_repository.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_day_project_metrics.dart';
import 'package:metrics/dashboard/domain/usecases/parameters/project_id_param.dart';
import 'package:metrics/dashboard/domain/usecases/receive_build_day_project_metrics_updates.dart';

/// A stub implementation of the [ReceiveBuildDayProjectMetricsUpdates].
class ReceiveBuildDayProjectMetricsUpdatesStub
    implements ReceiveBuildDayProjectMetricsUpdates {
  /// A [BuildDayRepository] this stub uses.
  final BuildDayRepository _repository;

  /// Creates a new instance of the [ReceiveBuildDayProjectMetricsUpdatesStub]
  /// with given [BuildDayRepository].
  ///
  /// Throws an [ArgumentError] if the given [BuildDayRepository] is `null`.
  ReceiveBuildDayProjectMetricsUpdatesStub(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Stream<BuildDayProjectMetrics> call(ProjectIdParam params) {
    return const Stream<BuildDayProjectMetrics>.empty();
  }
}
