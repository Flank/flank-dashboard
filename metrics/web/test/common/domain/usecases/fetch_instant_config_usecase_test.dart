import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/instant_config.dart';
import 'package:metrics/common/domain/repositories/instant_config_repository.dart';
import 'package:metrics/common/domain/usecases/fetch_instant_config_usecase.dart';
import 'package:metrics/common/domain/usecases/parameters/instant_config_param.dart';
import 'package:mockito/mockito.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FetchInstantConfigUseCase", () {
    const isFpsMonitorEnabled = true;
    const isLoginFormEnabled = false;
    const isRendererDisplayEnabled = false;

    final repository = _RemoteConfigurationRepositoryMock();
    final useCase = FetchInstantConfigUseCase(repository);
    final param = InstantConfigParam(
      isLoginFormEnabled: isLoginFormEnabled,
      isFpsMonitorEnabled: isFpsMonitorEnabled,
      isRendererDisplayEnabled: isRendererDisplayEnabled,
    );

    tearDown(() {
      reset(repository);
    });

    test(
      "throws an ArgumentError if the given repository is null",
      () {
        expect(
          () => FetchInstantConfigUseCase(null),
          throwsArgumentError,
        );
      },
    );

    test("creates an instance with the given repository", () {
      expect(
        () => FetchInstantConfigUseCase(repository),
        returnsNormally,
      );
    });

    test(
      ".call() uses the .fetch() method of the instant config repository",
      () {
        useCase(param);

        verify(repository.fetch()).called(1);
      },
    );

    test(
      ".call() returns an instant config with the given param values if the fetched instant config contains null values",
      () async {
        const nullConfig = InstantConfig(
          isFpsMonitorEnabled: null,
          isLoginFormEnabled: null,
          isRendererDisplayEnabled: null,
        );

        when(repository.fetch()).thenAnswer((_) => Future.value(nullConfig));

        final config = await useCase(param);

        expect(config.isLoginFormEnabled, equals(param.isLoginFormEnabled));
        expect(config.isFpsMonitorEnabled, equals(param.isFpsMonitorEnabled));
        expect(
          config.isRendererDisplayEnabled,
          equals(param.isRendererDisplayEnabled),
        );
      },
    );

    test(
      ".call() returns an instant config with the given param values if the fetched instant config is null",
      () async {
        when(repository.fetch()).thenAnswer((_) => Future.value(null));

        final config = await useCase(param);

        expect(config.isLoginFormEnabled, equals(param.isLoginFormEnabled));
        expect(config.isFpsMonitorEnabled, equals(param.isFpsMonitorEnabled));
        expect(
          config.isRendererDisplayEnabled,
          equals(param.isRendererDisplayEnabled),
        );
      },
    );

    test(
      ".call() returns an instant config with the given param values if fetching instant config fails",
      () async {
        when(repository.fetch()).thenAnswer(
          (_) => Future.error(Exception()),
        );

        final config = await useCase(param);

        expect(config.isLoginFormEnabled, equals(param.isLoginFormEnabled));
        expect(config.isFpsMonitorEnabled, equals(param.isFpsMonitorEnabled));
        expect(
          config.isRendererDisplayEnabled,
          equals(param.isRendererDisplayEnabled),
        );
      },
    );
  });
}

class _RemoteConfigurationRepositoryMock extends Mock
    implements InstantConfigRepository {}
