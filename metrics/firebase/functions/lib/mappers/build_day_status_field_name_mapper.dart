// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/models/build_day_status_field_name.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides a method for mapping [BuildStatus]
/// into the [BuildDayStatusFieldName].
class BuildDayStatusFieldNameMapper {
  /// Creates a new instance of the [BuildDayStatusFieldNameMapper].
  const BuildDayStatusFieldNameMapper();

  /// Maps the given [BuildStatus] to the [BuildDayStatusFieldName].
  BuildDayStatusFieldName map(BuildStatus buildStatus) {
    switch (buildStatus) {
      case BuildStatus.successful:
        return BuildDayStatusFieldName.successful;
      case BuildStatus.failed:
        return BuildDayStatusFieldName.failed;
      case BuildStatus.inProgress:
        return BuildDayStatusFieldName.inProgress;
      case BuildStatus.unknown:
        return BuildDayStatusFieldName.unknown;
      default:
        return null;
    }
  }
}
