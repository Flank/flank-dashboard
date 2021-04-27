// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A class that provides a method for mapping [BuildStatus]
/// into the build day status field name.
class BuildDayStatusFieldNameMapper {
  /// A successful build day status.
  static const String successful = 'successful';

  /// A failed build day status.
  static const String failed = 'failed';

  /// An unknown build day status.
  static const String unknown = 'unknown';

  /// An inProgress build day status.
  static const String inProgress = 'inProgress';

  /// Creates a new instance of the [BuildDayStatusFieldNameMapper].
  const BuildDayStatusFieldNameMapper();

  /// Maps the given [buildStatus] to the build day status field name.
  String map(BuildStatus buildStatus) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return successful;
      case BuildStatus.failed:
        return failed;
      case BuildStatus.inProgress:
        return inProgress;
      case BuildStatus.unknown:
        return unknown;
      default:
        return null;
    }
  }
}
