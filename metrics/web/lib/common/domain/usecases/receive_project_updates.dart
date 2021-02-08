// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:metrics/common/domain/repositories/project_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [UseCase] that provides an ability to receive [Project]s updates.
class ReceiveProjectUpdates implements UseCase<Stream<List<Project>>, void> {
  final ProjectRepository _repository;

  /// Creates the [ReceiveProjectUpdates] use case with
  /// the given [ProjectRepository].
  ///
  /// Throws an [ArgumentError] if the [ProjectRepository] is `null`.
  ReceiveProjectUpdates(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Stream<List<Project>> call([_]) {
    return _repository.projectsStream();
  }
}
