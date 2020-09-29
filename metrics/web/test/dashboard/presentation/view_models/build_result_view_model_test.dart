import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/dashboard_popup_card_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BuildResultViewModel", () {
    test(
      "throws an AssertionError if the given dashboardPopupCardViewModel is null",
      () {
        expect(
          () => BuildResultViewModel(dashboardPopupCardViewModel: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "equals to another BuildResultViewModel with the same parameters",
      () {
        const buildStatus = BuildStatus.cancelled;
        const url = 'url';
        final dashboardPopupCardViewModel = DashboardPopupCardViewModel(
          value: 10,
          startDate: DateTime.now(),
        );
        final expected = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
          buildStatus: buildStatus,
          url: url,
        );

        final buildResult = BuildResultViewModel(
          dashboardPopupCardViewModel: dashboardPopupCardViewModel,
          buildStatus: buildStatus,
          url: url,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}
