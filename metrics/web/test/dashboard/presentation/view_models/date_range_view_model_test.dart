// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.
import 'package:metrics/dashboard/presentation/view_models/date_range_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("DateRangeViewModel", () {
    final start = DateTime(2020);
    final end = DateTime(2021);

    test(
      "throws an AssertionError if the given start date is null",
      () {
        expect(
          () => DateRangeViewModel(start: null, end: end),
          throwsAssertionError,
        );
      },
    );

    test(
      "throws an AssertionError if the given end date is null",
      () {
        expect(
          () => DateRangeViewModel(start: start, end: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final viewModel = DateRangeViewModel(start: start, end: end);

        expect(viewModel.start, equals(start));
        expect(viewModel.end, equals(end));
      },
    );

    test(
      "equals to another date range view model with the same parameters",
      () {
        final viewModel = DateRangeViewModel(end: end, start: start);
        final anotherViewModel = DateRangeViewModel(end: end, start: start);

        expect(viewModel, equals(anotherViewModel));
      },
    );
  });
}
