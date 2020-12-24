import 'package:metrics/analytics/domain/entities/page_name.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:test/test.dart';

void main() {
  group("PageName", () {
    test(".loginPage value equals to the login route name", () {
      const loginPage = PageName.loginPage;

      expect(loginPage.value, equals(RouteName.login));
    });

    test(".dashboardPage value equals to the dashboard route name", () {
      const dashboardPage = PageName.dashboardPage;

      expect(dashboardPage.value, equals(RouteName.dashboard));
    });

    test(".projectGroupPage value equals to the project groups route name", () {
      const projectGroupPage = PageName.projectGroupsPage;

      expect(projectGroupPage.value, equals(RouteName.projectGroup));
    });

    test(".debugMenuPage value equals to the debug menu route name", () {
      const debugMenuPage = PageName.debugMenuPage;

      expect(debugMenuPage.value, equals(RouteName.debugMenu));
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
