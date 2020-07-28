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

    test(
      "successfully creates an instance on a valid input",
      () {
        expect(
          () => ProjectBuildStatusViewModel(value: BuildStatus.failed),
          returnsNormally,
        );
      },
    );

    test(
      "equals to another project build status view model instance with the same value",
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
