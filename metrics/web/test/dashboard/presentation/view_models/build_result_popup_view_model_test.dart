// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultPopupViewModel", () {
    const duration = Duration.zero;
    const buildStatus = BuildStatus.unknown;
    final date = DateTime.now();

    test("throws an AssertionError if the given date is null", () {
      expect(
        () => BuildResultPopupViewModel(
          date: null,
          duration: Duration.zero,
        ),
        throwsAssertionError,
      );
    });

    test("creates an instance with the given parameters", () {
      final viewModel = BuildResultPopupViewModel(
        date: date,
        duration: duration,
        buildStatus: buildStatus,
      );

      expect(viewModel.date, equals(date));
      expect(viewModel.duration, equals(duration));
      expect(viewModel.buildStatus, equals(buildStatus));
    });

    test(
      "equals to another BuildResultPopupViewModel with the same parameters",
      () {
        final expected = BuildResultPopupViewModel(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
        );

        final buildResult = BuildResultPopupViewModel(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}
