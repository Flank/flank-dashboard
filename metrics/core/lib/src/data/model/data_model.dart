// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// Base class for data models.
abstract class DataModel {
  /// Converts [DataModel] into the JSON encodable [Map].
  Map<String, dynamic> toJson();
}
