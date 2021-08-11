// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents a feature configuration state.
class PublicDashboardFeatureConfigModel extends Equatable {
  /// A flag that indicates whether the feature is enabled or disabled.
  final bool isEnabled;

  @override
  List<Object> get props => [isEnabled];

  /// Creates a new instance of the [PublicDashboardFeatureConfigModel]
  /// with the given parameters.
  ///
  /// Throws [AssertionError] if [isEnabled] parameter is `null`.
  const PublicDashboardFeatureConfigModel({
    @required this.isEnabled,
  }) : assert(isEnabled != null);
}
