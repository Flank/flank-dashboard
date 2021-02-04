// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a local config parameter.
class LocalConfigParam extends Equatable {
  /// Indicates whether the FPS monitor feature is enabled.
  final bool isFpsMonitorEnabled;

  @override
  List<Object> get props => [isFpsMonitorEnabled];

  /// Creates a new instance of the [LocalConfigParam]
  /// with the given parameters.
  ///
  /// Throws an [ArgumentError] if one of the required parameters is `null`.
  LocalConfigParam({
    @required this.isFpsMonitorEnabled,
  }) {
    ArgumentError.checkNotNull(
      isFpsMonitorEnabled,
      'isPasswordSignInOptionEnabled',
    );
  }
}
