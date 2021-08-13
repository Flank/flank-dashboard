// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:metrics/feature_config/presentation/models/public_dashboard_feature_config_model.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/feature_config/presentation/view_models/debug_menu_feature_config_view_model.dart';
import 'package:metrics/feature_config/presentation/view_models/password_sign_in_option_feature_config_view_model.dart';

/// Stub implementation of the [FeatureConfigNotifier].
///
/// Provides test implementation of the [FeatureConfigNotifier] methods.
class FeatureConfigNotifierStub extends ChangeNotifier
    implements FeatureConfigNotifier {
  @override
  PasswordSignInOptionFeatureConfigViewModel
      get passwordSignInOptionFeatureConfigViewModel =>
          const PasswordSignInOptionFeatureConfigViewModel(isEnabled: true);

  @override
  DebugMenuFeatureConfigViewModel get debugMenuFeatureConfigViewModel =>
      const DebugMenuFeatureConfigViewModel(isEnabled: true);

  @override
  PublicDashboardFeatureConfigModel get publicDashboardFeatureConfigModel =>
      const PublicDashboardFeatureConfigModel(isEnabled: true);

  @override
  Future<void> initializeConfig() async {}

  @override
  bool get isLoading => false;

  @override
  bool get isInitialized => true;

  @override
  void setDefaults({
    bool isPasswordSignInOptionEnabled = false,
    bool isDebugMenuEnabled = false,
    bool isPublicDashboardEnabled = false,
  }) {}
}
