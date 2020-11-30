import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/repositories/remote_configuration_repository.dart';
import 'package:metrics/common/domain/usecases/parameters/remote_configuration_param.dart';
import 'package:metrics/common/domain/usecases/set_default_remote_configuration_usecase.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("SetDefaultRemoteConfigurationUseCase", () {
    final repository = RemoteConfigurationRepositoryMock();

    tearDown(() {
      reset(repository);
    });

    test(
      "throws an ArgumentError if the given repository is null",
      () {
        expect(
          () => SetDefaultRemoteConfigurationUseCase(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "successfully creates an instance on a valid input",
      () {
        expect(
          () => SetDefaultRemoteConfigurationUseCase(repository),
          returnsNormally,
        );
      },
    );

    test(
      ".call() uses the set defaults method of the remote configuration repository",
      () async {
        const isFpsMonitorEnabled = true;
        const isLoginFormEnabled = true;
        const isRendererDisplayEnabled = false;

        final useCase = SetDefaultRemoteConfigurationUseCase(repository);
        const remoteConfigurationParam = RemoteConfigurationParam(
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isLoginFormEnabled: isLoginFormEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

        useCase(remoteConfigurationParam);

        verify(repository.setDefaults(
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isLoginFormEnabled: isLoginFormEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        )).called(1);
      },
    );
  });
}

class RemoteConfigurationRepositoryMock extends Mock
    implements RemoteConfigurationRepository {}
