// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A base class for info services that provides common methods
/// for getting information about service.
abstract class InfoService {
  /// Shows the version information of this service.
  Future<void> version();
}
