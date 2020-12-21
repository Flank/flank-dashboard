import 'package:flutter/material.dart';
import 'package:metrics/base/domain/usecases/usecase.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/usecases/close_local_config_storage_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/open_local_config_storage_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/parameters/local_config_param.dart';
import 'package:metrics/debug_menu/domain/usecases/read_local_config_usecase.dart';
import 'package:metrics/debug_menu/domain/usecases/update_local_config_usecase.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';

/// The [ChangeNotifier] that holds and manages [LocalConfig]'s data.
class DebugMenuNotifier extends ChangeNotifier {
  /// A [UseCase] that provides an ability to open the [LocalConfig] storage.
  final OpenLocalConfigStorageUseCase _openLocalConfigStorageUseCase;

  /// A [UseCase] that provides an ability to read the [LocalConfig].
  final ReadLocalConfigUseCase _readLocalConfigUseCase;

  /// A [UseCase] that provides an ability to update the [LocalConfig].
  final UpdateLocalConfigUseCase _updateLocalConfigUseCase;

  /// A [UseCase] that provides an ability to close the [LocalConfig] storage.
  final CloseLocalConfigStorageUseCase _closeLocalConfigStorageUseCase;

  /// Indicates whether the [LocalConfig] is loading.
  bool _isLoading = false;

  /// A view model that holds the [LocalConfig] data
  /// for the FPS monitor feature.
  FpsMonitorLocalConfigViewModel _fpsMonitorLocalConfigViewModel;

  /// A [LocalConfig] containing the current configuration values.
  LocalConfig _localConfig;

  /// Holds the [PersistentStoreErrorMessage] that occurred
  /// during updating the [LocalConfig].
  PersistentStoreErrorMessage _updateConfigError;

  /// Returns `true` if the [LocalConfig] is loading.
  /// Otherwise, returns `false`.
  bool get isLoading => _isLoading;

  /// Returns `true` if current [LocalConfig] is not `null`.
  /// Otherwise, returns `false`.
  bool get isInitialized => _localConfig != null;

  /// A view model that provides the [LocalConfig] data
  /// for the FPS monitor feature.
  FpsMonitorLocalConfigViewModel get fpsMonitorLocalConfigViewModel =>
      _fpsMonitorLocalConfigViewModel;

  /// Provides an error description that occurred
  /// during updating the [LocalConfig].
  String get updateConfigError => _updateConfigError?.message;

  /// Creates a new instance of the [DebugMenuNotifier]
  /// with the given parameters.
  ///
  /// Throws an [AssertionError] if any of the given parameters is `null`.
  DebugMenuNotifier(
    this._openLocalConfigStorageUseCase,
    this._readLocalConfigUseCase,
    this._updateLocalConfigUseCase,
    this._closeLocalConfigStorageUseCase,
  )   : assert(_openLocalConfigStorageUseCase != null),
        assert(_readLocalConfigUseCase != null),
        assert(_updateLocalConfigUseCase != null),
        assert(_closeLocalConfigStorageUseCase != null);

  /// Initializes the [LocalConfig].
  ///
  /// If [OpenLocalConfigStorageUseCase] throws, delegates initializing
  /// to the [initializeDefaults] method.
  Future<void> initializeLocalConfig() async {
    try {
      _setIsLoading(true);

      await _openLocalConfigStorageUseCase();

      final config = _readLocalConfigUseCase();

      _setLocalConfig(config);
    } catch (_) {
      initializeDefaults();
    } finally {
      _setIsLoading(false);
    }
  }

  /// Initializes the [LocalConfig] with default values.
  void initializeDefaults() {
    _setLocalConfig(
      const LocalConfig(isFpsMonitorEnabled: false),
    );
  }

  /// Toggles the fps monitor feature and updates the [LocalConfig].
  Future<void> toggleFpsMonitor() async {
    _setIsLoading(true);

    final isFpsMonitorEnabled = _fpsMonitorLocalConfigViewModel.isEnabled;

    final configParam = LocalConfigParam(
      isFpsMonitorEnabled: !isFpsMonitorEnabled,
    );

    _resetLocalConfigUpdatingError();

    try {
      final newConfig = await _updateLocalConfigUseCase(configParam);

      _setLocalConfig(newConfig);
    } on PersistentStoreException catch (exception) {
      _localConfigUpdatingErrorHandler(exception);
    } finally {
      _setIsLoading(false);
    }
  }

  /// Sets the current [_localConfig] value to the given [config] and updates
  /// appropriate view models.
  void _setLocalConfig(LocalConfig config) {
    _localConfig = config;

    _fpsMonitorLocalConfigViewModel = FpsMonitorLocalConfigViewModel(
      isEnabled: config.isFpsMonitorEnabled,
    );
  }

  /// Sets the current [_isLoading] value to the given [value]
  /// and notifies listeners.
  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Handles an error occurred during updating the [LocalConfig].
  void _localConfigUpdatingErrorHandler(PersistentStoreException exception) {
    final code = exception.code;

    _updateConfigError = PersistentStoreErrorMessage(code);
    notifyListeners();
  }

  /// Resets the [updateConfigError].
  void _resetLocalConfigUpdatingError() {
    _updateConfigError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _closeLocalConfigStorage();
    super.dispose();
  }

  /// Closes the [LocalConfig] storage connection.
  Future<void> _closeLocalConfigStorage() async {
    try {
      await _closeLocalConfigStorageUseCase();
    } catch (_) {}
  }
}
