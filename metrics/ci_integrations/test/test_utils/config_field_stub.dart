// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config_field.dart';

/// A stub class of the [ConfigField] class to use in tests.
class ConfigFieldStub extends ConfigField {
  /// Creates a new instance of the [ConfigFieldStub] with the given [value].
  ///
  /// Throws an [ArgumentError] if the given [value] is `null`.
  ConfigFieldStub(
    String value,
  ) : super(value);
}
