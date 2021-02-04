// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/src/domain/entities/build.dart';

/// Represents the status the [Build] has been finished with.
enum BuildStatus {
  /// Indicates a successful result of the [Build].
  successful,

  /// Indicates a failed result of the [Build].
  failed,

  /// Indicates an unknown result of the [Build].
  unknown,
}
