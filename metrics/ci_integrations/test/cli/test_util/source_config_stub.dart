// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';

/// A stub implementation of the [SourceConfig] to use in tests.
class SourceConfigStub implements SourceConfig {
  @override
  String get sourceProjectId => null;
}
