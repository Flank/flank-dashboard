import 'package:flutter/foundation.dart';
import 'package:metrics/instant_config/domain/entities/instant_config.dart';
import 'package:metrics/instant_config/domain/usecases/fetch_instant_config_usecase.dart';
import 'package:metrics/instant_config/domain/usecases/parameters/instant_config_param.dart';
import 'package:metrics/instant_config/presentation/view_models/fps_monitor_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/login_form_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/renderer_display_instant_config_view_model.dart';

/// The [ChangeNotifier] that holds [InstantConfig]'s data.
class InstantConfigNotifier extends ChangeNotifier {
  /// Indicates whether the [InstantConfig] is loading.
  bool _isLoading = false;

  /// A [FetchInstantConfigUseCase] that provides an ability to fetch
  /// the [InstantConfig].
  final FetchInstantConfigUseCase _fetchInstantConfigUseCase;

  /// An [InstantConfig] containing the default configuration values.
  InstantConfig _defaultInstantConfig;

  /// An [InstantConfig] containing the current configuration values.
  InstantConfig _instantConfig;

  /// A view model that holds the [InstantConfig] data for the login form.
  LoginFormInstantConfigViewModel _loginFormInstantConfigViewModel;

  /// A view model that holds the [InstantConfig] data for the FPS monitor.
  FpsMonitorInstantConfigViewModel _fpsMonitorInstantConfigViewModel;

  /// A view model that holds the [InstantConfig] data for the renderer display.
  RendererDisplayInstantConfigViewModel _rendererDisplayInstantConfigViewModel;

  /// Returns `true` if the [InstantConfig] is loading.
  /// Otherwise, returns `false`.
  bool get isLoading => _isLoading;

  /// Returns `true` if current [InstantConfig] is not `null`.
  /// Otherwise, returns `false`.
  bool get isInitialized => _instantConfig != null;

  /// A view model that provides the [InstantConfig] data for the login form.
  LoginFormInstantConfigViewModel get loginFormInstantConfigViewModel =>
      _loginFormInstantConfigViewModel;

  /// A view model that provides the [InstantConfig] data for the FPS monitor.
  FpsMonitorInstantConfigViewModel get fpsMonitorInstantConfigViewModel =>
      _fpsMonitorInstantConfigViewModel;

  /// A view model that provides the [InstantConfig] data for the renderer display.
  RendererDisplayInstantConfigViewModel
      get rendererDisplayInstantConfigViewModel =>
          _rendererDisplayInstantConfigViewModel;

  /// Creates an instance of the [InstantConfigNotifier]
  /// with the given [FetchInstantConfigUseCase].
  ///
  /// Throws an [AssertionError] if the given [FetchInstantConfigUseCase]
  /// is `null`.
  InstantConfigNotifier(this._fetchInstantConfigUseCase)
      : assert(_fetchInstantConfigUseCase != null) {
    setDefaults();
  }

  /// Sets the default [InstantConfig] from the given configuration values.
  ///
  /// Throws an [AssertionError] if one of the given parameters is `null`.
  void setDefaults({
    bool isLoginFormEnabled = false,
    bool isFpsMonitorEnabled = false,
    bool isRendererDisplayEnabled = false,
  }) {
    assert(isLoginFormEnabled != null);
    assert(isFpsMonitorEnabled != null);
    assert(isRendererDisplayEnabled != null);

    _defaultInstantConfig = InstantConfig(
      isLoginFormEnabled: isLoginFormEnabled,
      isFpsMonitorEnabled: isFpsMonitorEnabled,
      isRendererDisplayEnabled: isRendererDisplayEnabled,
    );
  }

  /// Initializes the [InstanceConfig].
  Future<void> initializeInstantConfig() async {
    _setIsLoading(true);

    final params = InstantConfigParam(
      isLoginFormEnabled: _defaultInstantConfig.isLoginFormEnabled,
      isFpsMonitorEnabled: _defaultInstantConfig.isFpsMonitorEnabled,
      isRendererDisplayEnabled: _defaultInstantConfig.isRendererDisplayEnabled,
    );
    final config = await _fetchInstantConfigUseCase(params);
    _setInstantConfig(config);

    _setIsLoading(false);
  }

  /// Sets the current [_instantConfig] value to the given [config] and updates
  /// the view models.
  void _setInstantConfig(InstantConfig config) {
    _instantConfig = config;

    _loginFormInstantConfigViewModel = LoginFormInstantConfigViewModel(
      isEnabled: _instantConfig.isLoginFormEnabled,
    );
    _fpsMonitorInstantConfigViewModel = FpsMonitorInstantConfigViewModel(
      isEnabled: _instantConfig.isFpsMonitorEnabled,
    );
    _rendererDisplayInstantConfigViewModel =
        RendererDisplayInstantConfigViewModel(
      isEnabled: _instantConfig.isRendererDisplayEnabled,
    );
  }

  /// Sets the current [_isLoading] value to the given [value]
  /// and notifies listeners.
  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
