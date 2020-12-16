import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';

/// A [UseCase] that provides an ability to read the local config.
class ReadLocalConfigUseCase extends UseCase<LocalConfig, void> {
  /// A [LocalConfigRepository] that provides an ability to interact
  /// with the persistent storage.
  final LocalConfigRepository _repository;

  /// Creates a new instance of the [ReadLocalConfigUseCase]
  /// with the given [LocalConfigRepository].
  ///
  /// Throws an [ArgumenError] if the given [LocalConfigRepository] is `null`.
  ReadLocalConfigUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  LocalConfig call([_]) {
    final config = _repository.readConfig();

    return LocalConfig(
      isFpsMonitorEnabled: config?.isFpsMonitorEnabled ?? false,
    );
  }
}
