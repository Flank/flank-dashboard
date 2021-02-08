// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/domain/entities/metrics/build_result.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResult", () {
    final date = DateTime.utc(2020, 4, 10);
    const duration = Duration(minutes: 14);
    const buildStatus = BuildStatus.successful;
    const url = 'some url';

    test(
      "creates an instance with the given data",
      () {
        final buildResult = BuildResult(
          date: date,
          duration: duration,
          buildStatus: buildStatus,
          url: url,
        );

        expect(buildResult.date, equals(date));
        expect(buildResult.duration, equals(duration));
        expect(buildResult.buildStatus, equals(buildStatus));
        expect(buildResult.url, equals(url));
      },
    );

    test(
      "two instances with equal fields are identical",
      () {
        final firstBuildResult = BuildResult(
          date: date,
          duration: duration,
          buildStatus: buildStatus,
          url: url,
        );
        final secondBuildResult = BuildResult(
          date: date,
          duration: duration,
          buildStatus: buildStatus,
          url: url,
        );

        expect(firstBuildResult, equals(secondBuildResult));
      },
    );
  });
}
