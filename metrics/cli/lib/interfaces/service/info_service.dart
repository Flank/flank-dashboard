// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A base class for services that provides common methods for them.
abstract class InfoService {
  /// Shows the version information of the tool used by the service.
  Future<void> version();
}
