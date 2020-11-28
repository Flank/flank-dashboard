import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/repositories/remote_configuration_repository.dart';
import 'package:metrics/common/domain/usecases/fetch_remote_configuration_usecase.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("FetchRemoteConfigurationUseCase", () {
    final repository = RemoteConfigurationRepositoryMock();
    final useCase = FetchRemoteConfigurationUseCase(repository);

    tearDown(() {
      reset(repository);
    });

    test(
      "throws an ArgumentError if the given repository is null",
      () {
        expect(
          () => FetchRemoteConfigurationUseCase(null),
          throwsArgumentError,
        );
      },
    );

    test("successfully creates an instance on a valid input", () {
      expect(
        () => FetchRemoteConfigurationUseCase(repository),
        returnsNormally,
      );
    });

    test(
      ".call() uses the apply defaults method of the remote configuration repository",
      () async {
        useCase();

        verify(repository.applyDefaults(any)).called(1);
      },
    );

    test(
      ".call() uses the fetch method of the remote configuration repository",
      () async {
        useCase();

        verify(repository.fetch()).called(1);
      },
    );

    test(
      ".call() uses the activate method of the remote configuration repository",
      () async {
        useCase();

        verify(repository.activate()).called(1);
      },
    );

    test(
      ".call() uses the get configuration method of the remote configuration repository",
      () async {
        useCase();

        verify(repository.getConfiguration()).called(1);
      },
    );
  });
}

class RemoteConfigurationRepositoryMock extends Mock
    implements RemoteConfigurationRepository {}
