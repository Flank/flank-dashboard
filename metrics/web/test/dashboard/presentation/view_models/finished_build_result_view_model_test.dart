// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

void main() {
  group("FinishedBuildResultViewModel", () {
    const buildStatus = BuildStatus.unknown;
    const url = 'url';
    const duration = Duration.zero;

    final date = DateTime.now();
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: duration,
      date: date,
    );

    test(
      "throws an AssertionError if the given duration is null",
      () {
        expect(
          () => FinishedBuildResultViewModel(
            duration: null,
            buildResultPopupViewModel: buildResultPopupViewModel,
            date: date,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given build result popup view model is null",
      () {
        expect(
          () => FinishedBuildResultViewModel(
            duration: duration,
            buildResultPopupViewModel: null,
            date: date,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given date is null",
      () {
        expect(
          () => FinishedBuildResultViewModel(
            duration: duration,
            buildResultPopupViewModel: buildResultPopupViewModel,
            date: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given build status is in-progress",
      () {
        expect(
          () => FinishedBuildResultViewModel(
            duration: duration,
            buildResultPopupViewModel: buildResultPopupViewModel,
            date: date,
            buildStatus: BuildStatus.inProgress,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final viewModel = FinishedBuildResultViewModel(
          duration: duration,
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        expect(viewModel.duration, equals(duration));
        expect(
          viewModel.buildResultPopupViewModel,
          equals(buildResultPopupViewModel),
        );
        expect(viewModel.date, equals(date));
        expect(viewModel.buildStatus, equals(buildStatus));
        expect(viewModel.url, equals(url));
      },
    );

    test(
      "equals to another BuildResultViewModel with the same parameters",
      () {
        final expectedViewModel = FinishedBuildResultViewModel(
          duration: duration,
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        final actualViewModel = FinishedBuildResultViewModel(
          duration: duration,
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        expect(actualViewModel, equals(expectedViewModel));
      },
    );
  });
}
