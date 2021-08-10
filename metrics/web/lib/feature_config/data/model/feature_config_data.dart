// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/feature_config/domain/entities/feature_config.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [FeatureConfig] entity.
class FeatureConfigData extends FeatureConfig implements DataModel {
  /// A name of the [isPasswordSignInOptionEnabled] field in the configs JSON.
  static const String _passwordSignInOptionFieldName =
      'isPasswordSignInOptionEnabled';

  /// A name of the [isDebugMenuEnabled] field in the configs JSON
  static const String _debugMenuEnabledFieldName = 'isDebugMenuEnabled';

  /// A name of the [isPublicDashboardFeatureEnabled] field in the configs JSON
  static const String _publicDashboardFeatureFieldName =
      'isPublicDashboardEnabled';

  /// Creates a new instance of the [FeatureConfigData]
  /// with the given config parameters.
  const FeatureConfigData(
      {bool isPasswordSignInOptionEnabled,
      bool isDebugMenuEnabled,
      bool isPublicDashboardFeatureEnabled})
      : super(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardFeatureEnabled: isPublicDashboardFeatureEnabled);

  /// Creates the [FeatureConfigData] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory FeatureConfigData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return FeatureConfigData(
        isPasswordSignInOptionEnabled:
            json[_passwordSignInOptionFieldName] as bool,
        isDebugMenuEnabled: json[_debugMenuEnabledFieldName] as bool,
        isPublicDashboardFeatureEnabled:
            json[_publicDashboardFeatureFieldName] as bool);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      _passwordSignInOptionFieldName: isPasswordSignInOptionEnabled,
      _debugMenuEnabledFieldName: isDebugMenuEnabled,
      _publicDashboardFeatureFieldName: isPublicDashboardFeatureEnabled
    };
  }
}
