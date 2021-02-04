// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectBuildStatusViewModel", () {
    test("can be created with null value", () {
      expect(
        () => const ProjectBuildStatusViewModel(value: null),
        returnsNormally,
      );
    });

    test("creates an instance with the given value", () {
      const status = BuildStatus.failed;

      const statusViewModel = ProjectBuildStatusViewModel(
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
        const firstViewModel = ProjectBuildStatusViewModel(
          value: BuildStatus.unknown,
        );

        const secondViewModel = ProjectBuildStatusViewModel(
          value: BuildStatus.unknown,
        );

        expect(firstViewModel, equals(secondViewModel));
      },
    );
  });
}
