// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';
import 'package:metrics/feature_config/domain/usecases/fetch_feature_config_usecase.dart';
import 'package:metrics/feature_config/domain/usecases/parameters/feature_config_param.dart';
import 'package:metrics/feature_config/presentation/models/public_dashboard_feature_config_model.dart';
import 'package:metrics/feature_config/presentation/view_models/debug_menu_feature_config_view_model.dart';
import 'package:metrics/feature_config/presentation/view_models/password_sign_in_option_feature_config_view_model.dart';

/// The [ChangeNotifier] that holds [FeatureConfig]'s data.
class FeatureConfigNotifier extends ChangeNotifier {
  /// Indicates whether the [FeatureConfig] is loading.
  bool _isLoading = false;

  /// A [FetchFeatureConfigUseCase] that provides an ability to fetch
  /// the [FeatureConfig].
  final FetchFeatureConfigUseCase _fetchFeatureConfigUseCase;

  /// A [FeatureConfig] containing the default configuration values.
  FeatureConfig _defaultFeatureConfig;

  /// A [FeatureConfig] containing the current configuration values.
  FeatureConfig _featureConfig;

  /// A view model that holds the [FeatureConfig] data for the password
  /// sign-in option.
  PasswordSignInOptionFeatureConfigViewModel
      _passwordSignInOptionFeatureConfigViewModel;

  /// A view model that holds the [FeatureConfig] data for the debug menu.
  DebugMenuFeatureConfigViewModel _debugMenuFeatureConfigViewModel;

  /// A model that holds the config of the public dashboard feature.
  PublicDashboardFeatureConfigModel _publicDashboardFeatureConfigModel;

  /// Returns `true` if the [FeatureConfig] is loading.
  /// Otherwise, returns `false`.
  bool get isLoading => _isLoading;

  /// Returns `true` if current [FeatureConfig] is not `null`.
  /// Otherwise, returns `false`.
  bool get isInitialized => _featureConfig != null;

  /// A view model that provides the [FeatureConfig] data for the password
  /// sign-in option.
  PasswordSignInOptionFeatureConfigViewModel
      get passwordSignInOptionFeatureConfigViewModel =>
          _passwordSignInOptionFeatureConfigViewModel;

  /// A view model that provides the [FeatureConfig] data for the debug menu.
  DebugMenuFeatureConfigViewModel get debugMenuFeatureConfigViewModel =>
      _debugMenuFeatureConfigViewModel;

  /// A model that holds the config of the public dashboard feature.
  PublicDashboardFeatureConfigModel get publicDashboardFeatureConfigModel =>
      _publicDashboardFeatureConfigModel;

  /// Creates an instance of the [FeatureConfigNotifier]
  /// with the given [FetchFeatureConfigUseCase].
  ///
  /// Throws an [AssertionError] if the given [FetchFeatureConfigUseCase]
  /// is `null`.
  FeatureConfigNotifier(this._fetchFeatureConfigUseCase)
      : assert(_fetchFeatureConfigUseCase != null) {
    setDefaults();
  }

  /// Sets the default [FeatureConfig] from the given configuration values.
  ///
  /// Throws an [AssertionError] if one of the given parameters is `null`.
  void setDefaults({
    bool isPasswordSignInOptionEnabled = false,
    bool isDebugMenuEnabled = false,
    bool isPublicDashboardEnabled = false,
  }) {
    assert(isPasswordSignInOptionEnabled != null);
    assert(isDebugMenuEnabled != null);
    assert(isPublicDashboardEnabled != null);

    _defaultFeatureConfig = FeatureConfig(
      isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
      isDebugMenuEnabled: isDebugMenuEnabled,
      isPublicDashboardEnabled: isPublicDashboardEnabled,
    );
  }

  /// Initializes the [FeatureConfig].
  Future<void> initializeConfig() async {
    _setIsLoading(true);

    final params = FeatureConfigParam(
      isPasswordSignInOptionEnabled:
          _defaultFeatureConfig.isPasswordSignInOptionEnabled,
      isDebugMenuEnabled: _defaultFeatureConfig.isDebugMenuEnabled,
      isPublicDashboardEnabled: _defaultFeatureConfig.isPublicDashboardEnabled,
    );
    final config = await _fetchFeatureConfigUseCase(params);
    _setFeatureConfig(config);

    _setIsLoading(false);
  }

  /// Sets the current [_featureConfig] value to the given [config] and updates
  /// the view models.
  void _setFeatureConfig(FeatureConfig config) {
    _featureConfig = config;

    _passwordSignInOptionFeatureConfigViewModel =
        PasswordSignInOptionFeatureConfigViewModel(
      isEnabled: _featureConfig.isPasswordSignInOptionEnabled,
    );
    _debugMenuFeatureConfigViewModel = DebugMenuFeatureConfigViewModel(
      isEnabled: _featureConfig.isDebugMenuEnabled,
    );

    _publicDashboardFeatureConfigModel = PublicDashboardFeatureConfigModel(
        isEnabled: _featureConfig.isPublicDashboardEnabled);
  }

  /// Sets the current [_isLoading] value to the given [value]
  /// and notifies listeners.
  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
