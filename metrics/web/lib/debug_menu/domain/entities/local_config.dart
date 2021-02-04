// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// An entity representing a local config.
class LocalConfig extends Equatable {
  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  @override
  List<Object> get props => [isFpsMonitorEnabled];

  /// Creates a new instance of the [LocalConfig]
  /// with the given [isFpsMonitorEnabled].
  const LocalConfig({
    this.isFpsMonitorEnabled,
  });
}
