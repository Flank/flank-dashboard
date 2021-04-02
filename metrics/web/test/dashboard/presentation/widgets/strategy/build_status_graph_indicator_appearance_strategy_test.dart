// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/attention_level/graph_indicator_attention_level.dart';
import 'package:metrics/common/presentation/graph_indicator/theme/style/graph_indicator_style.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_status_graph_indicator_appearance_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildStatusGraphIndicatorAppearanceStrategy", () {
    const positiveStyle = GraphIndicatorStyle(innerColor: Colors.green);
    const negativeStyle = GraphIndicatorStyle(innerColor: Colors.red);
    const neutralStyle = GraphIndicatorStyle(innerColor: Colors.grey);
    const attentionLevel = GraphIndicatorAttentionLevel(
      positive: positiveStyle,
      negative: negativeStyle,
      neutral: neutralStyle,
    );

    const strategy = BuildStatusGraphIndicatorAppearanceStrategy();

    test(
      ".selectStyle() returns the positive style from the given attention level if the given build status is BuildStatus.successful",
      () {
        final result = strategy.selectStyle(
          attentionLevel,
          BuildStatus.successful,
        );

        expect(result, equals(positiveStyle));
      },
    );

    test(
      ".selectStyle() returns the negative style from the given attention level if the given build status is BuildStatus.failed",
      () {
        final result = strategy.selectStyle(
          attentionLevel,
          BuildStatus.failed,
        );

        expect(result, equals(negativeStyle));
      },
    );

    test(
      ".selectStyle() returns the neutral style from the given attention level if the given build status is BuildStatus.unknown",
      () {
        final result = strategy.selectStyle(
          attentionLevel,
          BuildStatus.unknown,
        );

        expect(result, equals(neutralStyle));
      },
    );

    test(
      ".selectStyle() returns the neutral style from the given attention level if the given build status is BuildStatus.inProgress",
      () {
        final result = strategy.selectStyle(
          attentionLevel,
          BuildStatus.inProgress,
        );

        expect(result, equals(neutralStyle));
      },
    );

    test(
      ".selectStyle() returns null if the given status is null",
      () {
        final result = strategy.selectStyle(attentionLevel, null);

        expect(result, isNull);
      },
    );
  });
}
