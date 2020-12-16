import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';

/// A [UseCase] that provides an ability to close the local config storage.
class CloseLocalConfigStorageUseCase extends UseCase<Future<void>, void> {
  /// A [LocalConfigRepository] this usecase uses to interact with the
  /// persistent storage.
  final LocalConfigRepository _repository;

  /// Creates a new instance of the [CloseLocalConfigStorageUseCase]
  /// with the given [LocalConfigRepository].
  ///
  /// Throws an [ArgumentError] if the given [LocalConfigRepository] is `null`.
  CloseLocalConfigStorageUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  Future<void> call([_]) async {
    await _repository.close();
  }
}
