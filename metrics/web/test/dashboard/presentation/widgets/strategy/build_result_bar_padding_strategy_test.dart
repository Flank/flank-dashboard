import 'package:flutter/material.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

// https://github.com/platform-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("BuildResultBarPaddingStrategy", () {
    final popupViewModel = BuildResultPopupViewModel(
      duration: Duration(),
      date: DateTime.now(),
    );
    final buildResults = [
      BuildResultViewModel(
        buildResultPopupViewModel: popupViewModel,
        buildStatus: BuildStatus.successful,
      ),
      BuildResultViewModel(
        buildResultPopupViewModel: popupViewModel,
        buildStatus: BuildStatus.cancelled,
      ),
      BuildResultViewModel(
        buildResultPopupViewModel: popupViewModel,
        buildStatus: BuildStatus.failed,
      ),
    ];

    final strategy = BuildResultBarPaddingStrategy(
      buildResults: buildResults,
    );

    test(
      ".getBarPadding() returns an edge insets only with right value if the given build result is the first in the list",
      () {
        const expectedInsets = EdgeInsets.only(right: 2.0);
        final buildResult = buildResults.first;

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );

    test(
      ".getBarPadding() returns an edge insets with right and left value if the given build result is not the first and last in the list",
      () {
        const expectedInsets = EdgeInsets.symmetric(horizontal: 2.0);
        final buildResult = buildResults[1];

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );

    test(
      ".getBarPadding() returns an edge insets only with left only if the given build result if the first in list",
      () {
        const expectedInsets = EdgeInsets.only(left: 2.0);
        final buildResult = buildResults.last;

        final edgeInsets = strategy.getBarPadding(buildResult);

        expect(edgeInsets, equals(expectedInsets));
      },
    );

    test(
      ".getBarPadding() returns an edge insets only with left value if there is only one build result",
      () {
        const expectedInsets = EdgeInsets.only(left: 2.0);
        final buildResult = BuildResultViewModel(
          buildResultPopupViewModel: popupViewModel,
          buildStatus: BuildStatus.cancelled,
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
