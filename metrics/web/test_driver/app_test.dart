// This is a Flutter Web Driver test
// https://github.com/flutter/flutter/pull/45951

import 'package:flutter_driver/flutter_driver.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Flutter driver test",
    () {
      FlutterDriver driver;

      setUpAll(() async {
        driver = await WebFlutterDriver.connectWeb();
      });

      tearDownAll(() async {
        await driver?.close();
      });

      group("LoginPage", () {
        test("shows an authentication form", () async {
          await _authFormExists(driver);
        });

        test("can authenticate in the app using an email and a password",
            () async {
          await _authFormExists(driver);
          await _login(driver);
          await _authFormAbsent(driver);
          await driver.waitFor(find.byType('DashboardPage'));
        });

        test("can log out from the app", () async {
          await driver.waitUntilNoTransientCallbacks(
              timeout: const Duration(seconds: 2));
          await driver.tap(find.byTooltip('Open navigation menu'));
          await driver.waitFor(find.byValueKey('Logout'));
          await driver.tap(find.byValueKey('Logout'));
          await driver.waitUntilNoTransientCallbacks(
              timeout: const Duration(seconds: 2));
          await _authFormExists(driver);
        });
      });

      group("DashboardPage", () {
        test(
          "loads the projects and shows the project tiles",
          () async {
            await _authFormExists(driver);
            await _login(driver);
            await _authFormAbsent(driver);
            await driver.waitFor(find.byType('ProjectMetricsTile'));
          },
        );

        test(
          "loads the coverage data and shows the circle percentage widget",
          () async {
            await driver.waitFor(find.text(DashboardStrings.coverage));
            await driver.waitFor(find.byType('CirclePercentage'));
          },
        );

        test(
          "loads the build metrics and shows the sparkline graph widgets",
          () async {
            await driver.waitFor(find.text(DashboardStrings.performance));
            await driver.waitFor(find.text(DashboardStrings.builds));

            await driver.waitFor(find.byType('SparklineGraph'));
          },
        );

        test(
          "loads the build number metric and shows it with the title",
          () async {
            await driver.waitFor(find.text(DashboardStrings.builds));

            await driver.waitFor(find.byType('TextMetric'));
          },
        );

        test(
          "loads the build result metrics and shows the build results widget",
          () async {
            await driver.waitFor(find.text(DashboardStrings.buildTaskName));

            await driver.waitFor(find.byType('BuildResultBarGraph'));
          },
        );
      });
    },
  );
}

Future<void> _login(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('Email'));
  await driver.enterText('test@email.com');
  await driver.tap(find.byValueKey('Password'));
  await driver.enterText('testPassword');
  await driver.tap(find.byValueKey('Sign in'));
}

Future<void> _authFormExists(FlutterDriver driver) async {
  await driver.waitFor(find.byType('AuthForm'));
}

Future<void> _authFormAbsent(FlutterDriver driver) async {
  await driver.waitForAbsent(find.byType('AuthForm'));
}
