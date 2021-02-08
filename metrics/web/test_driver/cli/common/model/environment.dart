// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

/// A class that represents the environment of the process.
abstract class Environment {
  /// Maps the [Environment] to the [Map] applicable to the [Process].
  Map<String, String> toMap();
}
