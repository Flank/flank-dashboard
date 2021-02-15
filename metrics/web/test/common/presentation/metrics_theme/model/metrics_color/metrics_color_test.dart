// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
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
      "creates an instance with the given swatch",
      () {
        const color = MetricsColor(primary, swatch);

        expect(color.swatch, equals(swatch));
      },
    );

    test(
      "uses the given primary value if this metrics color instance is used as a color",
      () {
        const expectedColor = Color(primary);

        const color = MetricsColor(primary, swatch);

        expect(color.value, equals(expectedColor.value));
      },
    );

    test(
      ".swatch is an UnmodifiableMap",
      () {
        expect(color.swatch, isA<UnmodifiableMapView>());
      },
    );

    test(
      "throws an UnsupportedError when trying to modify .swatch",
      () {
        expect(() => color.swatch[10] = null, throwsUnsupportedError);
      },
    );

    test(
      "[] throws an AssertionError when trying to get not existing shade",
      () {
        const notExistingShade = -1000;

        expect(() => color[notExistingShade], MatcherUtil.throwsAssertionError);
      },
    );

    test(
      "[] returns the corresponding color from the swatch",
      () {
        final expectedColor = swatch[existingShade];

        final actualColor = color[existingShade];

        expect(actualColor, equals(expectedColor));
      },
    );
  });
}
