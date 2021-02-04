// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';

/// A [UseCase] that provides an ability to read the local config.
class ReadLocalConfigUseCase extends UseCase<LocalConfig, void> {
  /// A [LocalConfigRepository] this usecase uses to interact with the
  /// persistent storage.
  final LocalConfigRepository _repository;

  /// Creates a new instance of the [ReadLocalConfigUseCase]
  /// with the given [LocalConfigRepository].
  ///
  /// Throws an [ArgumentError] if the given [LocalConfigRepository] is `null`.
  ReadLocalConfigUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  LocalConfig call([_]) {
    try {
      final config = _repository.readConfig();

      return LocalConfig(
        isFpsMonitorEnabled: config?.isFpsMonitorEnabled ?? false,
      );
    } catch (_) {
      return const LocalConfig(
        isFpsMonitorEnabled: false,
      );
    }
  }
}
