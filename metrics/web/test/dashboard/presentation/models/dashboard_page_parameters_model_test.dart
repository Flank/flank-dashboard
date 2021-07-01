// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/presentation/models/dashboard_page_parameters_model.dart';
import 'package:test/test.dart';

void main() {
  group("DashboardPageParametersModel", () {
    const projectFilter = 'projectFilter';
    const projectGroupId = 'projectGroupId';
    const pageParametersMap = {
      'projectFilter': projectFilter,
      'projectGroupId': projectGroupId,
    };
    final pageParametersModel = DashboardPageParametersModel(
      projectFilter: projectFilter,
      projectGroupId: projectGroupId,
    );

    test(
      "creates an instance with the given parameters",
      () {
        final pageParametersModel = DashboardPageParametersModel(
          projectFilter: projectFilter,
          projectGroupId: projectGroupId,
        );

        expect(pageParametersModel.projectFilter, equals(projectFilter));
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

        expect(copiedPageParametersModel, equals(pageParametersModel));
      },
    );

    test(
      ".copyWith() creates a copy of an instance with the given fields replaced with the new values",
      () {
        const updatedProjectFilter = 'updatedProjectFilter';
        const updatedProjectGroupId = 'updatedProjectGroupId';

        final copiedPageParametersModel = pageParametersModel.copyWith(
          projectFilter: updatedProjectFilter,
          projectGroupId: updatedProjectGroupId,
        );

        expect(
          copiedPageParametersModel.projectFilter,
          equals(updatedProjectFilter),
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

        expect(actualPageParametersModel.projectFilter, equals(projectFilter));
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
