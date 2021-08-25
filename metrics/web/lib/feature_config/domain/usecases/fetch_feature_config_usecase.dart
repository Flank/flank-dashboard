// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';
import 'package:metrics/feature_config/domain/repositories/feature_config_repository.dart';
import 'package:metrics/feature_config/domain/usecases/parameters/feature_config_param.dart';

/// A [UseCase] that provides an ability to fetch the [FeatureConfig].
class FetchFeatureConfigUseCase
    extends UseCase<Future<FeatureConfig>, FeatureConfigParam> {
  /// A [FeatureConfigRepository] that provides an ability to interact
  /// with the persistent store.
  final FeatureConfigRepository _repository;

  /// Creates the [FetchFeatureConfigUseCase] use case with
  /// the given [FeatureConfigRepository].
  ///
  /// Throws an [ArgumentError] if the [FeatureConfigRepository] is `null`.
  FetchFeatureConfigUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Future<FeatureConfig> call(FeatureConfigParam params) async {
    try {
      final config = await _repository.fetch();

      return FeatureConfig(
        isPasswordSignInOptionEnabled: config?.isPasswordSignInOptionEnabled ??
            params.isPasswordSignInOptionEnabled,
        isDebugMenuEnabled:
            config?.isDebugMenuEnabled ?? params.isDebugMenuEnabled,
        isPublicDashboardEnabled:
            config?.isPublicDashboardEnabled ?? params.isPublicDashboardEnabled,
      );
    } catch (_) {
      return FeatureConfig(
        isPasswordSignInOptionEnabled: params.isPasswordSignInOptionEnabled,
        isDebugMenuEnabled: params.isDebugMenuEnabled,
        isPublicDashboardEnabled: params.isPublicDashboardEnabled,
      );
    }
  }
}
