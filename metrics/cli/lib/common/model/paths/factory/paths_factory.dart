// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/paths/paths.dart';

/// A class providing method for creating a [Paths] instance.
class PathsFactory {
  /// Creates a new instance of the [Paths] with the given [rootPath].
  Paths create(String rootPath) {
    return Paths(rootPath);
  }
}
