// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultBarPaddingStrategy", () {
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: Duration.zero,
      date: DateTime.now(),
    );
    final buildResults = [
      FinishedBuildResultViewModel(
        duration: const Duration(),
        date: DateTime.now(),
        buildStatus: BuildStatus.successful,
        buildResultPopupViewModel: buildResultPopupViewModel,
      ),
      FinishedBuildResultViewModel(
        duration: const Duration(),
        date: DateTime.now(),
        buildStatus: BuildStatus.failed,
        buildResultPopupViewModel: buildResultPopupViewModel,
      ),
      FinishedBuildResultViewModel(
        duration: const Duration(),
        date: DateTime.now(),
        buildStatus: BuildStatus.unknown,
        buildResultPopupViewModel: buildResultPopupViewModel,
      ),
    ];

    final strategy = BuildResultBarPaddingStrategy(
      buildResults: buildResults,
    );

    test(
      ".getBarPadding() returns an edge insets only with right value if the given build result is the first in the list",
      () {
        const expectedInsets = EdgeInsets.only(right: 1.0);
        final buildResult = buildResults.first;

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );

    test(
      ".getBarPadding() returns an edge insets with right and left value if the given build result is not the first and last in the list",
      () {
        const expectedInsets = EdgeInsets.symmetric(horizontal: 1.0);
        final buildResult = buildResults[1];

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );

    test(
      ".getBarPadding() returns an edge insets only with left only if the given build result if the first in list",
      () {
        const expectedInsets = EdgeInsets.only(left: 1.0);
        final buildResult = buildResults.last;

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );

    test(
      ".getBarPadding() returns an edge insets only with left value if there is only one build result",
      () {
        const expectedInsets = EdgeInsets.only(left: 1.0);
        final buildResult = FinishedBuildResultViewModel(
          date: DateTime.now(),
          duration: Duration.zero,
          buildResultPopupViewModel: buildResultPopupViewModel,
        );
        final strategy = BuildResultBarPaddingStrategy(
          buildResults: [buildResult],
        );

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );
  });
}
