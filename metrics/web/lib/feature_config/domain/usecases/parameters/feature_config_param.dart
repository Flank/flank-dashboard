// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a feature config parameter.
class FeatureConfigParam extends Equatable {
  /// Indicates whether the password sign-in option is enabled.
  final bool isPasswordSignInOptionEnabled;

  /// Indicates whether the debug menu feature is enabled.
  final bool isDebugMenuEnabled;

  final bool isPublicDashboardFeatureEnabled;

  @override
  List<Object> get props => [
        isPasswordSignInOptionEnabled,
        isDebugMenuEnabled,
        isPublicDashboardFeatureEnabled,
      ];

  /// Creates a new instance of the [FeatureConfigParam]
  /// with the given config parameters.
  ///
  /// Throws an [ArgumentError] if one of the required parameters is `null`.
  FeatureConfigParam({
    @required this.isPasswordSignInOptionEnabled,
    @required this.isDebugMenuEnabled,
    @required this.isPublicDashboardFeatureEnabled,
  }) {
    ArgumentError.checkNotNull(
        isPasswordSignInOptionEnabled, 'isPasswordSignInOptionEnabled');
    ArgumentError.checkNotNull(isDebugMenuEnabled, 'isDebugMenuEnabled');
    ArgumentError.checkNotNull(
        isPublicDashboardFeatureEnabled, 'isPublicDashboardFeatureEnabled');
  }
}
