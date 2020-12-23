import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/usecases/close_local_config_storage_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/open_local_config_storage_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/parameters/local_config_param.dart';
import 'package:metrics/debug_menu/domain/usecases/read_local_config_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/update_local_config_usecase.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/local_config_fps_monitor_view_model.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("DebugMenuNotifier", () {
    final openUseCase = _OpenLocalConfigStorageUseCaseMock();
    final readUseCase = _ReadLocalConfigUseCaseMock();
    final updateUseCase = _UpdateLocalConfigUseCaseMock();
    final closeUseCase = _CloseLocalConfigStorageUseCaseMock();

    const isFpsMonitorEnabled = true;
    const localConfig = LocalConfig(
      isFpsMonitorEnabled: isFpsMonitorEnabled,
    );
    const fpsMonitorViewModel = LocalConfigFpsMonitorViewModel(
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
      ".initializeLocalConfig() sets the local config fps monitor view model",
      () async {
        when(readUseCase()).thenReturn(localConfig);

        await notifier.initializeLocalConfig();
        final viewModel = notifier.localConfigFpsMonitorViewModel;

        expect(viewModel, equals(fpsMonitorViewModel));
      },
    );

    test(
      ".initializeLocalConfig() initializes the local config with defaults if open local config storage use case throws",
      () async {
        const expectedViewModel = LocalConfigFpsMonitorViewModel(
          isEnabled: false,
        );
        when(openUseCase()).thenAnswer(
          (_) => Future.error(const PersistentStoreException()),
        );

        await notifier.initializeLocalConfig();
        final actualModel = notifier.localConfigFpsMonitorViewModel;

        expect(actualModel, equals(expectedViewModel));
      },
    );

    test(
      ".initializeLocalConfig() initializes the local config with defaults if read local config use case throws",
      () async {
        const expectedViewModel = LocalConfigFpsMonitorViewModel(
          isEnabled: false,
        );
        when(readUseCase()).thenThrow(const PersistentStoreException());

        await notifier.initializeLocalConfig();
        final actualModel = notifier.localConfigFpsMonitorViewModel;

        expect(actualModel, equals(expectedViewModel));
      },
    );

    test(
      ".initializeDefaults() sets the local config fps monitor view model with the default is enabled value",
      () {
        notifier.initializeDefaults();

        final viewModel = notifier.localConfigFpsMonitorViewModel;

        expect(viewModel.isEnabled, isFalse);
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
      ".toggleFpsMonitor() sets the is loading to true when called",
      () {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.localConfigFpsMonitorViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(LocalConfig(
            isFpsMonitorEnabled: !isFpsMonitorEnabled,
          )),
        );

        notifier.toggleFpsMonitor();

        expect(notifier.isLoading, isTrue);
      },
    );

    test(
      ".toggleFpsMonitor() sets the is loading to false when finished",
      () async {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.localConfigFpsMonitorViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(LocalConfig(
            isFpsMonitorEnabled: !isFpsMonitorEnabled,
          )),
        );

        await notifier.toggleFpsMonitor();

        expect(notifier.isLoading, isFalse);
      },
    );

    test(
      ".toggleFpsMonitor() calls the update local config use case",
      () {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.localConfigFpsMonitorViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(LocalConfig(
            isFpsMonitorEnabled: !isFpsMonitorEnabled,
          )),
        );

        notifier.toggleFpsMonitor();

        verify(updateUseCase(expectedParam)).called(1);
      },
    );

    test(
      ".toggleFpsMonitor() updates the local config fps monitor view model",
      () async {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.localConfigFpsMonitorViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );
        final expectedViewModel = LocalConfigFpsMonitorViewModel(
          isEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(LocalConfig(
            isFpsMonitorEnabled: !isFpsMonitorEnabled,
          )),
        );

        await notifier.toggleFpsMonitor();
        final viewModel = notifier.localConfigFpsMonitorViewModel;

        expect(viewModel, equals(expectedViewModel));
      },
    );

    test(
      ".toggleFpsMonitor() sets the .updateConfigError if the updating the local config throws",
      () async {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.localConfigFpsMonitorViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.error(const PersistentStoreException()),
        );

        await notifier.toggleFpsMonitor();

        expect(notifier.updateConfigError, isNotNull);
      },
    );

    test(
      ".toggleFpsMonitor() resets the .updateConfigError",
      () async {
        notifier.initializeDefaults();

        final isFpsMonitorEnabled =
            notifier.localConfigFpsMonitorViewModel.isEnabled;
        final expectedParam = LocalConfigParam(
          isFpsMonitorEnabled: !isFpsMonitorEnabled,
        );

        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.error(const PersistentStoreException()),
        );

        await notifier.toggleFpsMonitor();

        reset(updateUseCase);
        when(updateUseCase(expectedParam)).thenAnswer(
          (_) => Future.value(LocalConfig(
            isFpsMonitorEnabled: !isFpsMonitorEnabled,
          )),
        );

        await notifier.toggleFpsMonitor();

        expect(notifier.updateConfigError, isNull);
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

class _OpenLocalConfigStorageUseCaseMock extends Mock
    implements OpenLocalConfigStorageUseCase {}

class _ReadLocalConfigUseCaseMock extends Mock
    implements ReadLocalConfigUseCase {}

class _UpdateLocalConfigUseCaseMock extends Mock
    implements UpdateLocalConfigUseCase {}

class _CloseLocalConfigStorageUseCaseMock extends Mock
    implements CloseLocalConfigStorageUseCase {}
