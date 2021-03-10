// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A base class for CLIs that provides common methods for them.
abstract class Cli {
  /// Shows the version information of this CLI.
  Future<void> version();
}
