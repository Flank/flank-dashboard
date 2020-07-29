import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectBuildStatusViewModel", () {
    test("can be created with null value", () {
      expect(
        () => ProjectBuildStatusViewModel(value: null),
        returnsNormally,
      );
    });

    test("creates an instance with the given value", () {
      const status = BuildStatus.failed;

      final statusViewModel = ProjectBuildStatusViewModel(
        value: BuildStatus.failed,
      );

      expect(
        statusViewModel.value,
        equals(status),
      );
    });

    test(
      "equals to another ProjectBuildStatusViewModel with the same value",
      () {
        final firstViewModel = ProjectBuildStatusViewModel(
          value: BuildStatus.cancelled,
        );

        final secondViewModel = ProjectBuildStatusViewModel(
          value: BuildStatus.cancelled,
        );

        expect(firstViewModel, equals(secondViewModel));
      },
    );
  });
}
