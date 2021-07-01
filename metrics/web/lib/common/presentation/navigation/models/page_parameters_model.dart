// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// An abstract class, that represents the deserialized page's data
/// from query parameters.
abstract class PageParametersModel {
  /// Maps page's parameters to the [Map].
  Map<String, dynamic> toMap();
}
