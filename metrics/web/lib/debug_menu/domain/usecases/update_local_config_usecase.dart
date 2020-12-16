import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';
import 'package:metrics/debug_menu/domain/usecases/parameters/local_config_param.dart';

/// A [UseCase] that provides an ability to update the local config.
class UpdateLocalConfigUseCase extends UseCase<Future<void>, LocalConfigParam> {
  /// A [LocalConfigRepository] that provides an ability to interact
  /// with the persistent storage.
  final LocalConfigRepository _repository;

  /// Creates a new instance of the [UpdateLocalConfigUseCase]
  /// with the given [LocalConfigRepository].
  ///
  /// Throws an [ArgumenError] if the given [LocalConfigRepository] is `null`.
  UpdateLocalConfigUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Future<void> call(LocalConfigParam param) async {
    await _repository.updateConfig(
      isFpsMonitorEnabled: param.isFpsMonitorEnabled,
    );
  }
}
