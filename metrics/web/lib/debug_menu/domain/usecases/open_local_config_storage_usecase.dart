// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';

/// A [UseCase] that provides an ability to open the local config storage.
class OpenLocalConfigStorageUseCase extends UseCase<Future<void>, void> {
  /// A [LocalConfigRepository] this usecase uses to interact with the
  /// persistent storage.
  final LocalConfigRepository _repository;

  /// Creates a new instance of the [OpenLocalConfigStorageUseCase]
  /// with the given [LocalConfigRepository].
  ///
  /// Throws an [ArgumentError] if the given [LocalConfigRepository] is `null`.
  OpenLocalConfigStorageUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Future<void> call([_]) async {
    await _repository.open();
  }
}
