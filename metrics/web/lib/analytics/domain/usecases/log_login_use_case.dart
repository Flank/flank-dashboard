// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/analytics/domain/repositories/analytics_repository.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/common/domain/usecases/parameters/user_id_param.dart';

/// A [UseCase] that provides an ability to log user logins.
class LogLoginUseCase implements UseCase<Future<void>, UserIdParam> {
  /// An [AnalyticsRepository] that provides an ability to interact
  /// with the store.
  final AnalyticsRepository _repository;

  /// Creates a [LogLoginUseCase] with the given [AnalyticsRepository].
  ///
  /// The given [AnalyticsRepository] must not be `null`.
  LogLoginUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call(UserIdParam params) async {
    await _repository.setUserId(params.id);

    return _repository.logLogin();
  }
}
