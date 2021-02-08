// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/analytics/domain/entities/page_name.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:test/test.dart';

void main() {
  group("PageName", () {
    test(".loginPage value equals to the login route path", () {
      const loginPage = PageName.loginPage;

      expect(loginPage.value, equals(MetricsRoutes.login.path));
    });

    test(".dashboardPage value equals to the dashboard route path", () {
      const dashboardPage = PageName.dashboardPage;

      expect(dashboardPage.value, equals(MetricsRoutes.dashboard.path));
    });

    test(".projectGroupPage value equals to the project groups route path", () {
      const projectGroupPage = PageName.projectGroupsPage;

      expect(projectGroupPage.value, equals(MetricsRoutes.projectGroups.path));
    });

    test(".debugMenuPage value equals to the debug menu route path", () {
      const debugMenuPage = PageName.debugMenuPage;

      expect(debugMenuPage.value, equals(MetricsRoutes.debugMenu.path));
    });

    test(".values contains all page names", () {
      const expectedValues = {
        PageName.loginPage,
        PageName.dashboardPage,
        PageName.projectGroupsPage,
        PageName.debugMenuPage,
      };

      const values = PageName.values;

      expect(values, containsAll(expectedValues));
    });
  });
}
