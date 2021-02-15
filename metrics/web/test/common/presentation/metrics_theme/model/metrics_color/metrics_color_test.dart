// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_color/metrics_color.dart';

import '../../../../../test_utils/matcher_util.dart';

void main() {
  group("MetricsColor", () {
    const primary = 0xFF000000;
    const existingShade = 100;
    const swatch = <int, Color>{
      existingShade: Color(primary),
    };

    const color = MetricsColor(primary, swatch);

    test(
      "creates an instance with the given primary value",
      () {
        const color = MetricsColor(primary, swatch);

        expect(color.value, equals(primary));
      },
    );

    test(
      "operator [] throws an AssertionError if the given shade does not exist",
      () {
        const nonExistingShade = -1000;

        expect(() => color[nonExistingShade], MatcherUtil.throwsAssertionError);
      },
    );

    test(
      "operator [] returns the corresponding color from the swatch",
      () {
        final expectedColor = swatch[existingShade];

        final actualColor = color[existingShade];

        expect(actualColor, equals(expectedColor));
      },
    );
  });
}
