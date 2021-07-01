// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/models/dashboard_page_parameters_model.dart';
import 'package:test/test.dart';

void main() {
  group("DashboardPageParametersModel", () {
    const projectName = 'projectName';
    const projectGroupId = 'projectGroupId';
    const pageParametersMap = {
      'projectName': projectName,
      'projectGroupId': projectGroupId,
    };
    const pageParametersModel = DashboardPageParametersModel(
      projectName: projectName,
      projectGroupId: projectGroupId,
    );

    test(
      "creates an instance with the given parameters",
      () {
        const pageParametersModel = DashboardPageParametersModel(
          projectName: projectName,
          projectGroupId: projectGroupId,
        );

        expect(pageParametersModel.projectName, equals(projectName));
        expect(
          pageParametersModel.projectGroupId,
          equals(projectGroupId),
        );
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without params",
      () {
        final copiedPageParametersModel = pageParametersModel.copyWith();

        expect(copiedPageParametersModel.projectName, equals(projectName));
        expect(
          copiedPageParametersModel.projectGroupId,
          equals(projectGroupId),
        );
      },
    );

    test(
      ".copyWith() creates a copy of an instance with the given fields replaced with the new values",
      () {
        const updatedProjectName = 'updatedProjectName';
        const updatedProjectGroupId = 'updatedProjectGroupId';

        final copiedPageParametersModel = pageParametersModel.copyWith(
          projectName: updatedProjectName,
          projectGroupId: updatedProjectGroupId,
        );

        expect(
          copiedPageParametersModel.projectName,
          equals(updatedProjectName),
        );
        expect(
          copiedPageParametersModel.projectGroupId,
          equals(updatedProjectGroupId),
        );
      },
    );

    test(
      ".fromMap() returns null if the given map is null",
      () {
        final pageParametersModel = DashboardPageParametersModel.fromMap(null);

        expect(pageParametersModel, isNull);
      },
    );

    test(
      ".fromMap() creates an instance from the given map",
      () {
        final actualPageParametersModel = DashboardPageParametersModel.fromMap(
          pageParametersMap,
        );

        expect(actualPageParametersModel.projectName, equals(projectName));
        expect(
          actualPageParametersModel.projectGroupId,
          equals(projectGroupId),
        );
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final actualMap = pageParametersModel.toMap();

        expect(actualMap, equals(pageParametersMap));
      },
    );
  });
}
