// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A view model that represents a local config FPS monitor feature.
class LocalConfigFpsMonitorViewModel extends Equatable {
  /// Indicates whether this fps monitor is enabled.
  final bool isEnabled;

  @override
  List<Object> get props => [isEnabled];

  /// Creates a new instance of the [LocalConfigFpsMonitorViewModel]
  /// with the given [isEnabled] value.
  ///
  /// Throws an [AssertionError] if the given [isEnabled] is null.
  const LocalConfigFpsMonitorViewModel({
    @required this.isEnabled,
  }) : assert(isEnabled != null);
}
