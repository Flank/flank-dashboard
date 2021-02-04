// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';

/// An abstract class representing the destination configurations.
abstract class DestinationConfig extends Config {
  /// Used to identify a project in a destination storage
  /// this config belongs to.
  String get destinationProjectId;
}
