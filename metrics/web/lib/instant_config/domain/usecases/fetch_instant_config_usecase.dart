import 'dart:async';

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/instant_config/domain/entities/instant_config.dart';
import 'package:metrics/instant_config/domain/repositories/instant_config_repository.dart';
import 'package:metrics/instant_config/domain/usecases/parameters/instant_config_param.dart';

/// A [UseCase] that provides an ability to fetch the [InstantConfig].
class FetchInstantConfigUseCase
    extends UseCase<Future<InstantConfig>, InstantConfigParam> {
  /// An [InstantConfigRepository] that provides an ability to interact
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
  Future<InstantConfig> call(InstantConfigParam params) async {
    try {
      final config = await _repository.fetch();

      return InstantConfig(
        isLoginFormEnabled:
            config?.isLoginFormEnabled ?? params.isLoginFormEnabled,
        isFpsMonitorEnabled:
            config?.isFpsMonitorEnabled ?? params.isFpsMonitorEnabled,
        isRendererDisplayEnabled:
            config?.isRendererDisplayEnabled ?? params.isRendererDisplayEnabled,
      );
    } catch (_) {
      return InstantConfig(
        isLoginFormEnabled: params.isLoginFormEnabled,
        isFpsMonitorEnabled: params.isFpsMonitorEnabled,
        isRendererDisplayEnabled: params.isRendererDisplayEnabled,
      );
    }
  }
}
