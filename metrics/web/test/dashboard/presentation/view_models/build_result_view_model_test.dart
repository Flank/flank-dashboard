import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultViewModel", () {
    test(
      "throws an AssertionError if the given buildResultPopupViewModel is null",
      () {
        expect(
          () => BuildResultViewModel(buildResultPopupViewModel: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "equals to another BuildResultViewModel with the same parameters",
      () {
        const buildStatus = BuildStatus.cancelled;
        const url = 'url';
        final buildResultPopupViewModel = BuildResultPopupViewModel(
          duration: const Duration(seconds: 10),
          date: DateTime.now(),
        );

        final expected = BuildResultViewModel(
          buildResultPopupViewModel: buildResultPopupViewModel,
          buildStatus: buildStatus,
          url: url,
        );

        final buildResult = BuildResultViewModel(
          buildResultPopupViewModel: buildResultPopupViewModel,
          buildStatus: buildStatus,
          url: url,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}
