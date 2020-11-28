import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/common/domain/entities/remote_configuration.dart';
import 'package:metrics/common/domain/repositories/remote_configuration_repository.dart';

/// A [UseCase] that provides an ability to fetch the [RemoteConfiguration].
class FetchRemoteConfigurationUseCase
    extends UseCase<RemoteConfiguration, void> {
  final RemoteConfigurationRepository _repository;

  /// Default values for the [RemoteConfiguration].
  static const Map<String, bool> _remoteConfigDefaults = {
    'isLoginFormEnabled': true,
    'isFpsMonitorEnabled': false,
    'isRendererDisplayEnabled': false,
  };

  /// Creates the [FetchRemoteConfigurationUseCase] use case with
  /// the given [RemoteConfigurationRepository].
  ///
  /// Throws an [ArgumentError] if the [RemoteConfigurationRepository] is `null`.
  FetchRemoteConfigurationUseCase(this._repository) {
    ArgumentError.checkNotNull(_repository, 'repository');
  }

  @override
  RemoteConfiguration call([_]) {
    _repository.applyDefaults(_remoteConfigDefaults);
    _repository.fetch();
    _repository.activate();

    return _repository.getConfiguration();
  }
}
