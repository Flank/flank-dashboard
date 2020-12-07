import 'package:metrics/common/domain/entities/instant_config.dart';
import 'package:metrics/common/domain/usecases/fetch_instant_config_usecase.dart';
import 'package:metrics/common/domain/usecases/parameters/instant_config_param.dart';
import 'package:metrics/common/presentation/state/instant_config_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("InstantConfigNotifier", () {
    const isLoginFormEnabled = true;
    const isFpsMonitorEnabled = true;
    const isRendererDisplayEnabled = true;

    final instantConfig = InstantConfig(
      isLoginFormEnabled: isLoginFormEnabled,
      isFpsMonitorEnabled: isFpsMonitorEnabled,
      isRendererDisplayEnabled: isRendererDisplayEnabled,
    );

    final _fetchInstantConfigUseCase = _FetchInstantConfigUseCaseMock();

    InstantConfigNotifier notifier;

    setUp(() {
      notifier = InstantConfigNotifier(_fetchInstantConfigUseCase);

      notifier.setDefaults(
        isLoginFormEnabled: isLoginFormEnabled,
        isFpsMonitorEnabled: isFpsMonitorEnabled,
        isRendererDisplayEnabled: isRendererDisplayEnabled,
      );
    });

    tearDown(() {
      reset(_fetchInstantConfigUseCase);
    });

    test(
      "throws an AssertionError if the given fetch instant config use case is null",
      () {
        expect(
          () => InstantConfigNotifier(null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given fetch instant config use case",
      () {
        expect(
          () => InstantConfigNotifier(_fetchInstantConfigUseCase),
          returnsNormally,
        );
      },
    );

    test(
      "creates an instance with the given fetch instant config use case",
      () {
        expect(
          () => InstantConfigNotifier(_fetchInstantConfigUseCase),
          returnsNormally,
        );
      },
    );

    test(
      ".setDefaults() throws an AssertionError if the given is login form enabled is null",
      () {
        expect(
          () => notifier.setDefaults(
            isLoginFormEnabled: null,
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".setDefaults() throws an AssertionError if the given is FPS monitor enabled is null",
      () {
        expect(
          () => notifier.setDefaults(
            isLoginFormEnabled: isLoginFormEnabled,
            isFpsMonitorEnabled: null,
            isRendererDisplayEnabled: isRendererDisplayEnabled,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".setDefaults() throws an AssertionError if the given is renderer display enabled is null",
      () {
        expect(
          () => notifier.setDefaults(
            isLoginFormEnabled: isLoginFormEnabled,
            isFpsMonitorEnabled: isFpsMonitorEnabled,
            isRendererDisplayEnabled: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".initializeInstantConfig() calls the fetch instant config use case",
      () {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        notifier.initializeInstantConfig();

        verify(_fetchInstantConfigUseCase(any)).called(1);
      },
    );

    test(
      ".initializeInstantConfig() uses the given default values when fetching the instant config",
      () {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        final instantConfigParam = InstantConfigParam(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
        );

        notifier.initializeInstantConfig();

        verify(_fetchInstantConfigUseCase(instantConfigParam)).called(1);
      },
    );

    test(
      ".initializeInstantConfig() sets the login form instant config view model",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(notifier.loginFormInstantConfigViewModel, isNotNull);
      },
    );

    test(
      ".initializeInstantConfig() sets the FPS monitor instant config view model",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(notifier.fpsMonitorInstantConfigViewModel, isNotNull);
      },
    );

    test(
      ".initializeInstantConfig() sets the renderer display instant config view model",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(notifier.rendererDisplayInstantConfigViewModel, isNotNull);
      },
    );

    test(
      ".initializeInstantConfig() sets the is loading value to false after initialization complete",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(notifier.isLoading, isFalse);
      },
    );
  });
}

class _FetchInstantConfigUseCaseMock extends Mock
    implements FetchInstantConfigUseCase {}
