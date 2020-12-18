import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/usecases/close_local_config_storage_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/open_local_config_storage_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/parameters/local_config_param.dart';
import 'package:metrics/debug_menu/domain/usecases/read_local_config_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/update_local_config_usecase.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("DebugMenuNotifier", () {
    final openUseCase = _OpenLocalConfigStorageUseCase();
    final readUseCase = _ReadLocalConfigUseCase();
    final updateUseCase = _UpdateLocalConfigUseCase();
    final closeUseCase = _CloseLocalConfigStorageUseCase();

    const isFpsMonitorEnabled = false;
    const localConfig = LocalConfig(
      isFpsMonitorEnabled: isFpsMonitorEnabled,
    );
    const fpsMonitorLocalConfigViewModel = FpsMonitorLocalConfigViewModel(
      isEnabled: isFpsMonitorEnabled,
    );

    DebugMenuNotifier notifier;

    setUp(() {
      notifier = DebugMenuNotifier(
        openUseCase,
        readUseCase,
        updateUseCase,
        closeUseCase,
      );
    });

    tearDown(() {
      reset(openUseCase);
      reset(readUseCase);
      reset(updateUseCase);
      reset(closeUseCase);
    });

    test(
      "throws an AssertionError if the given open local config storage use case is null",
      () {
        expect(
          () => DebugMenuNotifier(
            null,
            readUseCase,
            updateUseCase,
            closeUseCase,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given read local config use case is null",
      () {
        expect(
          () => DebugMenuNotifier(
            openUseCase,
            null,
            updateUseCase,
            closeUseCase,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given update local config use case is null",
      () {
        expect(
          () => DebugMenuNotifier(
            openUseCase,
            readUseCase,
            null,
            closeUseCase,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given close local config storage use case is null",
      () {
        expect(
          () => DebugMenuNotifier(
            openUseCase,
            readUseCase,
            updateUseCase,
            null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        expect(
          () => DebugMenuNotifier(
            openUseCase,
            readUseCase,
            updateUseCase,
            closeUseCase,
          ),
          returnsNormally,
        );
      },
    );

    test(
      ".initializeLocalConfig() sets the .isLoading to true when called",
      () {
        when(readUseCase()).thenReturn(localConfig);

        notifier.initializeLocalConfig();

        expect(notifier.isLoading, isTrue);
      },
    );

    test(
      ".initializeLocalConfig() sets the .isLoading to false when finished",
      () async {
        when(readUseCase()).thenReturn(localConfig);

        await notifier.initializeLocalConfig();

        expect(notifier.isLoading, isFalse);
      },
    );

    test(
      ".initializeLocalConfig() calls the open local config storage use case",
      () {
        when(readUseCase()).thenReturn(localConfig);

        notifier.initializeLocalConfig();

        verify(openUseCase()).called(1);
      },
    );

    test(
      ".initializeLocalConfig() calls the read local config use case",
      () async {
        when(readUseCase()).thenReturn(localConfig);

        await notifier.initializeLocalConfig();

        verify(readUseCase()).called(1);
      },
    );

    test(
      ".initializeLocalConfig() sets the fps monitor local config view model",
      () async {
        when(readUseCase()).thenReturn(localConfig);

        await notifier.initializeLocalConfig();

        expect(
          notifier.fpsMonitorLocalConfigViewModel,
          equals(fpsMonitorLocalConfigViewModel),
        );
      },
    );

    test(
      ".initializeLocalConfig() initializes the local config with defaults if initialialing local config fails when opening the local config persistent storage",
      () async {
        const expectedViewModel = FpsMonitorLocalConfigViewModel(
          isEnabled: false,
        );
        when(openUseCase()).thenAnswer(
          (_) => throw const PersistentStoreException(),
        );

        await notifier.initializeLocalConfig();

        final actualModel = notifier.fpsMonitorLocalConfigViewModel;

        expect(
          actualModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initializeLocalConfig() initializes the local config with defaults if initialialing local config fails when reading the local config from the persistent storage",
      () async {
        const expectedViewModel = FpsMonitorLocalConfigViewModel(
          isEnabled: false,
        );
        when(readUseCase()).thenAnswer(
          (_) => throw const PersistentStoreException(),
        );

        await notifier.initializeLocalConfig();

        final actualModel = notifier.fpsMonitorLocalConfigViewModel;

        expect(
          actualModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".initializeDefaults() sets the fps monitor local config view model with the default is enabled value",
      () {
        notifier.initializeDefaults();

        final fpsMonitorLocalConfigViewModel =
            notifier.fpsMonitorLocalConfigViewModel;

        expect(fpsMonitorLocalConfigViewModel.isEnabled, isFalse);
      },
    );

    test(
      ".isInitialized returns false if the local config is not initialized",
      () {
        expect(notifier.isInitialized, isFalse);
      },
    );

    test(
      ".isInitialized returns true if the local config is initialized using .initializeLocalConfig()",
      () async {
        when(readUseCase()).thenReturn(localConfig);

        await notifier.initializeLocalConfig();

        expect(notifier.isInitialized, isTrue);
      },
    );

    test(
      ".isInitialized returns true if the local config is initialized using .initializeDefaults()",
      () {
        notifier.initializeDefaults();

        expect(notifier.isInitialized, isTrue);
      },
    );

    test(
      ".toggleFpsMonitor() calls the update local config use case",
      () {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.fpsMonitorLocalConfigViewModel.isEnabled;

        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(
            LocalConfig(isFpsMonitorEnabled: !isFpsMonitorEnabled),
          ),
        );

        notifier.toggleFpsMonitor();

        verify(updateUseCase(expectedParam)).called(1);
      },
    );

    test(
      ".toggleFpsMonitor() updates the fps monitor local config view model",
      () async {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.fpsMonitorLocalConfigViewModel.isEnabled;

        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );
        final expectedViewModel = FpsMonitorLocalConfigViewModel(
          isEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(
            LocalConfig(isFpsMonitorEnabled: !isFpsMonitorEnabled),
          ),
        );

        await notifier.toggleFpsMonitor();

        expect(
          notifier.fpsMonitorLocalConfigViewModel,
          equals(expectedViewModel),
        );
      },
    );

    test(
      ".toggleFpsMonitor() does not update the fps monitor local config view model until the update local config use case finishes",
      () {
        notifier.initializeDefaults();

        final initialViewModel = notifier.fpsMonitorLocalConfigViewModel;

        final isFpsMonitorEnabled =
            notifier.fpsMonitorLocalConfigViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(
            LocalConfig(isFpsMonitorEnabled: !isFpsMonitorEnabled),
          ),
        );

        notifier.toggleFpsMonitor();

        expect(
          notifier.fpsMonitorLocalConfigViewModel,
          equals(initialViewModel),
        );
      },
    );

    test(
      ".toggleFpsMonitor() sets the .localConfigUpdatingErrorMessage if an error occured when updating the local config persistent store",
      () {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.fpsMonitorLocalConfigViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => throw const PersistentStoreException(),
        );

        notifier.toggleFpsMonitor();

        expect(
          notifier.localConfigUpdatingErrorMessage,
          isNotNull,
        );
      },
    );

    test(
      ".toggleFpsMonitor() resets the .localConfigUpdatingErrorMessage",
      () {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.fpsMonitorLocalConfigViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => throw const PersistentStoreException(),
        );

        notifier.toggleFpsMonitor();

        reset(updateUseCase);
        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(
            LocalConfig(isFpsMonitorEnabled: !isFpsMonitorEnabled),
          ),
        );

        notifier.toggleFpsMonitor();

        expect(
          notifier.localConfigUpdatingErrorMessage,
          isNull,
        );
      },
    );

    test(
      ".dispose() calls the close local config storage use case",
      () {
        notifier.dispose();

        verify(closeUseCase()).called(1);
      },
    );
  });
}

class _OpenLocalConfigStorageUseCase extends Mock
    implements OpenLocalConfigStorageUseCase {}

class _ReadLocalConfigUseCase extends Mock implements ReadLocalConfigUseCase {}

class _UpdateLocalConfigUseCase extends Mock
    implements UpdateLocalConfigUseCase {}

class _CloseLocalConfigStorageUseCase extends Mock
    implements CloseLocalConfigStorageUseCase {}
