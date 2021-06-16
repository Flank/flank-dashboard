// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/analytics/domain/entities/page_name.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:test/test.dart';

void main() {
  group("PageName", () {
    test(
      ".loginPage value equals to the login route path",
      () {
        final expected = DefaultRoutes.login.path;

        const loginPage = PageName.loginPage;

        expect(loginPage.value, equals(expected));
      },
    );

    test(
      ".dashboardPage value equals to the dashboard route path",
      () {
        final expected = DefaultRoutes.dashboard.path;

        const dashboardPage = PageName.dashboardPage;

        expect(dashboardPage.value, equals(expected));
      },
    );

    test(
      ".projectGroupPage value equals to the project groups route path",
      () {
        final expected = DefaultRoutes.projectGroups.path;

        const projectGroupPage = PageName.projectGroupsPage;

        expect(projectGroupPage.value, equals(expected));
      },
    );

    test(
      ".debugMenuPage value equals to the debug menu route path",
      () {
        final expected = DefaultRoutes.debugMenu.path;

        const debugMenuPage = PageName.debugMenuPage;

        expect(debugMenuPage.value, equals(expected));
      },
    );

    test(
      ".values contains all page names",
      () {
        const expectedValues = {
          PageName.loginPage,
          PageName.dashboardPage,
          PageName.projectGroupsPage,
          PageName.debugMenuPage,
        };

        const values = PageName.values;

        expect(values, containsAll(expectedValues));
      },
    );
  });
}
