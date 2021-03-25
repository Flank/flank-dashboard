// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';

void main() {
  group("InProgressBuildResultViewModel", () {
    const url = 'url';

    final date = DateTime.now();
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: Duration.zero,
      date: date,
    );

    test(
      "throws an AssertionErrror if the given build result popup view model is null",
      () {
        expect(
          () => InProgressBuildResultViewModel(
            buildResultPopupViewModel: null,
            date: date,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionErrror if the given date is null",
      () {
        expect(
          () => InProgressBuildResultViewModel(
            buildResultPopupViewModel: buildResultPopupViewModel,
            date: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the default in-progress build status",
      () {
        final viewModel = InProgressBuildResultViewModel(
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
        );

        expect(viewModel.buildStatus, equals(BuildStatus.inProgress));
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final viewModel = InProgressBuildResultViewModel(
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          url: url,
        );

        expect(
          viewModel.buildResultPopupViewModel,
          equals(buildResultPopupViewModel),
        );
        expect(viewModel.date, equals(date));
        expect(viewModel.url, equals(url));
      },
    );
  });
}
