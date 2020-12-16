import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';
import 'package:metrics/debug_menu/domain/usecases/parameters/local_config_param.dart';

/// A [UseCase] that provides an ability to update the local config.
class UpdateLocalConfigUseCase extends UseCase<Future<void>, LocalConfigParam> {
  /// A [LocalConfigRepository] this usecase uses to interact with the
  /// persistent storage.
  final LocalConfigRepository _repository;

  /// Creates a new instance of the [UpdateLocalConfigUseCase]
  /// with the given [LocalConfigRepository].
  ///
  /// Throws an [ArgumentError] if the given [LocalConfigRepository] is `null`.
  UpdateLocalConfigUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Future<LocalConfig> call(LocalConfigParam param) async {
    final config = await _repository.updateConfig(
      isFpsMonitorEnabled: param.isFpsMonitorEnabled,
    );

    return LocalConfig(
      isFpsMonitorEnabled: config?.isFpsMonitorEnabled ?? false,
    );
  }
}
