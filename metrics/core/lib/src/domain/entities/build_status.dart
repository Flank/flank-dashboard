// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/domain/entities/build.dart';

/// An enum that represents the status of the [Build].
enum BuildStatus {
  /// A status that represents a successful result of the [Build].
  successful,

  /// A status that represents a failed result of the [Build].
  failed,

  /// A status that represents a [Build] that is in-progress.
  inProgress,

  /// A status that represents an unknown result of the [Build].
  unknown,
}
