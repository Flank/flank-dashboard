import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildResultViewModel", () {
    test(
      "equals to another BuildResultViewModel with the same parameters",
      () {
        const duration = Duration.zero;
        const buildStatus = BuildStatus.unknown;
        const url = 'url';
        final date = DateTime.now();

        final expected = BuildResultViewModel(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        final buildResult = BuildResultViewModel(
          duration: duration,
          date: date,
          buildStatus: buildStatus,
          url: url,
        );

        expect(buildResult, equals(expected));
      },
    );
  });
}
