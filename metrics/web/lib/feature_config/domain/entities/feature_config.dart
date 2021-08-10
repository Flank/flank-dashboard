// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// An entity representing a feature config.
class FeatureConfig extends Equatable {
  /// Indicates whether the password sign-in option is enabled.
  final bool isPasswordSignInOptionEnabled;

  /// Indicates whether the debug menu feature is enabled.
  final bool isDebugMenuEnabled;

  /// Indicates whether the public dashboard feature is enabled.
  final bool isPublicDashboardEnabled;

  @override
  List<Object> get props => [
        isPasswordSignInOptionEnabled,
        isDebugMenuEnabled,
        isPublicDashboardEnabled,
      ];

  /// Creates a new instance of the [FeatureConfig] with the given parameters.
  const FeatureConfig({
    this.isPasswordSignInOptionEnabled,
    this.isDebugMenuEnabled,
    this.isPublicDashboardEnabled,
  });
}
