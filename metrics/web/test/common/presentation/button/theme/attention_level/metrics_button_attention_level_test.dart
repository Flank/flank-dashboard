// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsButtonAttentionLevel", () {
    test(
      "creates an instance with default styles if styles are not specified",
      () {
        const attentionLevel = MetricsButtonAttentionLevel();

        expect(attentionLevel.positive, isNotNull);
        expect(attentionLevel.neutral, isNotNull);
        expect(attentionLevel.negative, isNotNull);
        expect(attentionLevel.inactive, isNotNull);
      },
    );

    test("creates an instance with the given styles", () {
      const normal = MetricsButtonStyle(color: Colors.green);
      const secondary = MetricsButtonStyle(color: Colors.yellow);
      const negative = MetricsButtonStyle(color: Colors.red);
      const inactive = MetricsButtonStyle(color: Colors.grey);

      const attentionLevel = MetricsButtonAttentionLevel(
        positive: normal,
        neutral: secondary,
        negative: negative,
        inactive: inactive,
      );

      expect(attentionLevel.positive, equals(normal));
      expect(attentionLevel.neutral, equals(secondary));
      expect(attentionLevel.negative, equals(negative));
      expect(attentionLevel.inactive, equals(inactive));
    });
  });
}
