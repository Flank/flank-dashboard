import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/common/domain/entities/remote_configuration.dart';
import 'package:metrics/common/domain/repositories/remote_configuration_repository.dart';
import 'package:metrics/common/domain/usecases/parameters/remote_configuration_param.dart';

/// A [UseCase] that provides an ability to set the default
/// [RemoteConfiguration] parameters.
class SetDefaultRemoteConfigurationUseCase
    extends UseCase<void, RemoteConfigurationParam> {
  /// A [RemoteConfigurationRepository] that provides an ability to interact
  /// with the persistent store.
  final RemoteConfigurationRepository _repository;

  /// Creates the [SetDefaultRemoteConfigurationUseCase] use case with
  /// the given [RemoteConfigurationRepository].
  ///
  /// Throws an [ArgumentError] if the [RemoteConfigurationRepository] is `null`.
  SetDefaultRemoteConfigurationUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  void call(RemoteConfigurationParam params) {
    _repository.setDefaults(
      isLoginFormEnabled: params.isLoginFormEnabled,
      isFpsMonitorEnabled: params.isFpsMonitorEnabled,
      isRendererDisplayEnabled: params.isRendererDisplayEnabled,
    );
  }
}
