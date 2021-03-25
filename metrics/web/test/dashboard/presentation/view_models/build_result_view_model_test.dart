// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("BuildResultViewModel", () {
    const buildStatus = BuildStatus.unknown;
    const url = 'url';

    final date = DateTime.now();
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: Duration.zero,
      date: DateTime.now(),
    );

    test("throws an AssertionError if the given date is null", () {
      expect(
        () => _BuildResultViewModelFake(
          date: null,
          buildResultPopupViewModel: buildResultPopupViewModel,
        ),
        throwsAssertionError,
      );
    });

    test(
      "throws an AssertionError if the given build result popup view model is null",
      () {
        expect(
          () => _BuildResultViewModelFake(
            date: DateTime.now(),
            buildResultPopupViewModel: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final viewModel = _BuildResultViewModelFake(
          date: date,
          buildStatus: buildStatus,
          url: url,
          buildResultPopupViewModel: buildResultPopupViewModel,
        );

        expect(viewModel.date, equals(date));
        expect(viewModel.buildStatus, equals(buildStatus));
        expect(viewModel.url, equals(url));
        expect(
          viewModel.buildResultPopupViewModel,
          equals(buildResultPopupViewModel),
        );
      },
    );

    test(
      "equals to another BuildResultViewModel with the same parameters",
      () {
        final expected = _BuildResultViewModelFake(
          date: date,
          buildStatus: buildStatus,
          url: url,
          buildResultPopupViewModel: buildResultPopupViewModel,
        );

        final buildResult = _BuildResultViewModelFake(
          date: date,
          buildStatus: buildStatus,
          url: url,
          buildResultPopupViewModel: buildResultPopupViewModel,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}

/// A fake class needed to test the [BuildResultViewModel] abstract class.
class _BuildResultViewModelFake extends BuildResultViewModel {
  /// Creates a new instance of this fake with the given parameters.
  const _BuildResultViewModelFake({
    @required BuildResultPopupViewModel buildResultPopupViewModel,
    @required DateTime date,
    BuildStatus buildStatus,
    String url,
  }) : super(
          buildResultPopupViewModel: buildResultPopupViewModel,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );
}
