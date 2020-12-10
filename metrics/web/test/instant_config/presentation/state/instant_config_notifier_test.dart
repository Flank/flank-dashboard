import 'package:metrics/instant_config/domain/entities/instant_config.dart';
import 'package:metrics/instant_config/domain/usecases/fetch_instant_config_usecase.dart';
import 'package:metrics/instant_config/domain/usecases/parameters/instant_config_param.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:metrics/instant_config/presentation/view_models/debug_menu_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/fps_monitor_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/login_form_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/renderer_display_instant_config_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("InstantConfigNotifier", () {
    const isLoginFormEnabled = true;
    const isFpsMonitorEnabled = true;
    const isRendererDisplayEnabled = true;
    const isDebugMenuEnabled = true;

    final instantConfig = InstantConfig(
      isLoginFormEnabled: isLoginFormEnabled,
      isFpsMonitorEnabled: isFpsMonitorEnabled,
      isRendererDisplayEnabled: isRendererDisplayEnabled,
      isDebugMenuEnabled: isDebugMenuEnabled,
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
      ".setDefaults() throws an AssertionError if the given is login form enabled is null",
      () {
        expect(
          () => notifier.setDefaults(
            isLoginFormEnabled: null,
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
            isFpsMonitorEnabled: null,
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
            isRendererDisplayEnabled: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".setDefaults() throws an AssertionError if the given is debug menu enabled is null",
      () {
        expect(
          () => notifier.setDefaults(
            isDebugMenuEnabled: null,
          ),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".initializeInstantConfig() sets the .isLoading to true when called",
      () {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        notifier.setDefaults(isLoginFormEnabled: true);
        final param = InstantConfigParam(
          isLoginFormEnabled: true,
          isFpsMonitorEnabled: false,
          isRendererDisplayEnabled: false,
          isDebugMenuEnabled: false,
        );

        notifier.initializeInstantConfig();

        verify(_fetchInstantConfigUseCase(param)).called(1);
        expect(notifier.isLoading, isTrue);
      },
    );

    test(
      ".initializeInstantConfig() sets the .isLoading to false when finished",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        notifier.setDefaults(isLoginFormEnabled: true);
        final param = InstantConfigParam(
          isLoginFormEnabled: true,
          isFpsMonitorEnabled: false,
          isRendererDisplayEnabled: false,
          isDebugMenuEnabled: false,
        );

        await notifier.initializeInstantConfig();

        verify(_fetchInstantConfigUseCase(param)).called(1);
        expect(notifier.isLoading, isFalse);
      },
    );

    test(
      ".initializeInstantConfig() calls the fetch instant config use case",
      () {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        notifier.setDefaults(isLoginFormEnabled: true);
        final param = InstantConfigParam(
          isLoginFormEnabled: true,
          isFpsMonitorEnabled: false,
          isRendererDisplayEnabled: false,
          isDebugMenuEnabled: false,
        );

        notifier.initializeInstantConfig();

        verify(_fetchInstantConfigUseCase(param)).called(1);
      },
    );

    test(
      ".initializeInstantConfig() uses the given default values when fetching the instant config",
      () {
        final instantConfigParam = InstantConfigParam(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );
        when(_fetchInstantConfigUseCase(instantConfigParam)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        notifier.setDefaults(
          isLoginFormEnabled: isLoginFormEnabled,
          isFpsMonitorEnabled: isFpsMonitorEnabled,
          isRendererDisplayEnabled: isRendererDisplayEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );
        notifier.initializeInstantConfig();

        verify(_fetchInstantConfigUseCase(instantConfigParam)).called(1);
      },
    );

    test(
      ".initializeInstantConfig() sets the login form instant config view model",
      () async {
        const expectedViewModel = LoginFormInstantConfigViewModel(
          isEnabled: isLoginFormEnabled,
        );
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(
          notifier.loginFormInstantConfigViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initializeInstantConfig() sets the FPS monitor instant config view model",
      () async {
        const expectedViewModel = FpsMonitorInstantConfigViewModel(
          isEnabled: isFpsMonitorEnabled,
        );
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(
          notifier.fpsMonitorInstantConfigViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initializeInstantConfig() sets the renderer display instant config view model",
      () async {
        const expectedViewModel = RendererDisplayInstantConfigViewModel(
          isEnabled: isRendererDisplayEnabled,
        );
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(
          notifier.rendererDisplayInstantConfigViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initializeInstantConfig() sets the debug menu instant config view model",
      () async {
        const expectedViewModel = DebugMenuInstantConfigViewModel(
          isEnabled: isRendererDisplayEnabled,
        );
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(
          notifier.debugMenuInstantConfigViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initializeInstantConfig() sets the is loading value to false when initialization is completed",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(notifier.isLoading, isFalse);
      },
    );

    test(
      ".isInitialized returns true if the current config is initialized",
      () async {
        when(_fetchInstantConfigUseCase(any)).thenAnswer(
          (_) => Future.value(instantConfig),
        );

        await notifier.initializeInstantConfig();

        expect(notifier.isInitialized, isTrue);
      },
    );

    test(
      ".isInitialized returns false if the current config is not initialized",
      () async {
        expect(notifier.isInitialized, isFalse);
      },
    );
  });
}

class _FetchInstantConfigUseCaseMock extends Mock
    implements FetchInstantConfigUseCase {}
