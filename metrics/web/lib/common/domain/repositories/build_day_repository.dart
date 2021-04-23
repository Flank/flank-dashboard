// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/domain/entities/build_day.dart';

/// A base class for build days repositories.
///
/// Provides an ability to get the build day data.
abstract class BuildDayRepository {
  /// Provides the stream of [BuildDay]s.
  Stream<List<BuildDay>> projectBuildDaysInDateRangeStream(
    String projectId, {
    DateTime from,
    DateTime to,
  });
}
