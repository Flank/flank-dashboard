// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/domain/entities/metrics/build_performance.dart';

void main() {
  group("BuildPerformance", () {
    const duration = Duration(seconds: 1);
    final date = DateTime(2020);

    test(
      "creates a new instance with the given parameters",
      () {
        final performance = BuildPerformance(duration: duration, date: date);

        expect(performance.duration, equals(duration));
        expect(performance.date, equals(date));
      },
    );

    test(
      "equals to another BuildPerformance instance with the same parameters",
      () {
        final performance = BuildPerformance(duration: duration, date: date);
        final anotherPerformance = BuildPerformance(
          duration: duration,
          date: date,
        );

        expect(performance, equals(anotherPerformance));
      },
    );
  });
}
