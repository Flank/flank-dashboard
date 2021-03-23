// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/domain/entities/build.dart';

/// An enum that represents the status of the [Build].
enum BuildStatus {
  /// A status for a successful result of the [Build].
  successful,

  /// A status for a failed result of the [Build].
  failed,

  /// A status for a [Build] that is in-progress.
  inProgress,

  /// A status for an unknown result of the [Build].
  unknown,
}
