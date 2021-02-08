// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/analytics/domain/repositories/analytics_repository.dart';
import 'package:metrics/analytics/domain/usecases/parameters/page_name_param.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';

/// A [UseCase] that provides an ability to log page changes.
class LogPageViewUseCase implements UseCase<Future<void>, PageNameParam> {
  /// An [AnalyticsRepository] that provides an ability to interact
  /// with the store.
  final AnalyticsRepository _repository;

  /// Creates a [LogPageViewUseCase] with the given [AnalyticsRepository].
  ///
  /// The given [AnalyticsRepository] must not be `null`.
  LogPageViewUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, '_repository');
  }

  @override
  Future<void> call(PageNameParam params) {
    return _repository.logPageView(params.pageName.value);
  }
}
