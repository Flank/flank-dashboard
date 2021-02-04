// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/analytics/domain/repositories/analytics_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// A [UseCase] that provides an ability to reset the analytics user identifier.
class ResetUserUseCase implements UseCase<Future<void>, void> {
  /// An [AnalyticsRepository] that provides an ability to interact
  /// with the store.
  final AnalyticsRepository _repository;

  /// Creates a [ResetUserUseCase] with the given [AnalyticsRepository].
  ///
  /// The given [AnalyticsRepository] must not be `null`.
  ResetUserUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call([_]) {
    return _repository.setUserId(null);
  }
}
