// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';

/// A stub implementation of the [DestinationConfig] to use in tests.
class DestinationConfigStub implements DestinationConfig {
  @override
  String get destinationProjectId => null;
}
