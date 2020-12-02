import 'dart:async';

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/common/domain/entities/instant_config.dart';
import 'package:metrics/common/domain/repositories/instant_config_repository.dart';
import 'package:metrics/common/domain/usecases/parameters/instant_config_param.dart';

/// A [UseCase] that provides an ability to fetch the [InstantConfig].
class FetchInstantConfigUseCase
    extends UseCase<FutureOr<InstantConfig>, InstantConfigParam> {
  /// A [InstantConfigRepository] that provides an ability to interact
  /// with the persistent store.
  final InstantConfigRepository _repository;

  /// Creates the [FetchInstantConfigUseCase] use case with
  /// the given [InstantConfigRepository].
  ///
  /// Throws an [ArgumentError] if the [InstantConfigRepository] is `null`.
  FetchInstantConfigUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  FutureOr<InstantConfig> call(InstantConfigParam params) async {
    try {
      return _repository.fetch();
    } catch (e) {
      return InstantConfig(
        isLoginFormEnabled: params.isLoginFormEnabled,
        isFpsMonitorEnabled: params.isFpsMonitorEnabled,
        isRendererDisplayEnabled: params.isRendererDisplayEnabled,
      );
    }
  }
}
