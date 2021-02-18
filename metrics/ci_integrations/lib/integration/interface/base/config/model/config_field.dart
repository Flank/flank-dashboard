// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// An abstract class that represents a single [Config]'s field.
abstract class ConfigField extends Enum<String> with EquatableMixin {
  @override
  List<Object> get props => [value];

  /// Creates a new instance of the [ConfigField] with the given [value].
  ///
  /// Throws an [ArgumentError] if the given [value] is `null`.
  ConfigField(
    String value,
  ) : super(value) {
    ArgumentError.checkNotNull(value);
  }

  @override
  String toString() {
    return value;
  }
}
