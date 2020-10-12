import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultPopupViewModel", () {
    const duration = Duration(minutes: 11);
    final date = DateTime.now();

    test("throws an AssertionError if the given duration is null", () {
      expect(
        () => BuildResultPopupViewModel(duration: null, date: date),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given date is null", () {
      expect(
        () => BuildResultPopupViewModel(duration: duration, date: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test(
      "equals to another BuildResultPopupViewModel with the same parameters",
      () {
        final expected = BuildResultPopupViewModel(
          duration: duration,
          date: date,
        );

        final buildResultPopupViewModel = BuildResultPopupViewModel(
          duration: duration,
          date: date,
        );

        expect(buildResultPopupViewModel, equals(expected));
      },
    );
  });
}
