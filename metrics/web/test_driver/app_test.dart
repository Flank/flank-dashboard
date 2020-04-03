// This is a Flutter Web Driver test
// https://github.com/flutter/flutter/pull/45951

import 'package:flutter_driver/flutter_driver.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:test/test.dart';
void main() {
  group(
    'flutter driver test',
    () {
      FlutterDriver driver;

      setUpAll(() async {
        driver = await WebFlutterDriver.connectWeb();
      });

      tearDownAll(() async {
        await driver?.close();
      });

      group('Login page:', () {
        test('Shows an authentication form', () async  {
          await authFormExists(driver);
        });

        test('Can authenticate in the app using an email and a password', () async {
          await authFormExists(driver);
          await login(driver);
          await authFormAbsent(driver);
          await driver.waitFor(find.byType('DashboardPage'));
        });

        test('Can log out from the app', () async {
          await driver.waitUntilNoTransientCallbacks(timeout: const Duration(seconds: 2));
          await driver.tap(find.byTooltip('Open navigation menu'));
          await driver.waitFor(find.byValueKey('Logout'));
          await driver.tap(find.byValueKey('Logout'));
          await driver.waitUntilNoTransientCallbacks(timeout: const Duration(seconds: 2));
          await authFormExists(driver);
        });
      });

      group('Dashboard page:', () {
        test(
          'Loads the projects and shows the project tiles',
              () async {
            await authFormExists(driver);
            await login(driver);
            await authFormAbsent(driver);
            await driver.waitFor(find.byType('ProjectMetricsTile'));
          },
        );

        test(
          'Loads the coverage data and shows the circle percentage widget',
              () async {
            await driver.waitFor(find.text(DashboardStrings.coverage));
            await driver.waitFor(find.byType('CirclePercentage'));
          },
        );

        test(
          'Loads the build metrics and shows the sparkline graph widgets',
              () async {
            await driver.waitFor(find.text(DashboardStrings.performance));
            await driver.waitFor(find.text(DashboardStrings.builds));

            await driver.waitFor(find.byType('SparklineGraph'));
          },
        );

        test(
          'Loads the build result metrics and shows the build results widget',
              () async {
            await driver.waitFor(find.text(DashboardStrings.buildTaskName));

            await driver.waitFor(find.byType('BuildResultBarGraph'));
          },
        );
      });
    },
  );
}

Future<void> login(FlutterDriver driver) async {
  await driver.tap(find.byValueKey('Email'));
  await driver.enterText('test@email.com');
  await driver.tap(find.byValueKey('Password'));
  await driver.enterText('testPassword');
  await driver.tap(find.byValueKey('Sign in'));
}

Future<void> authFormExists(FlutterDriver driver) async {
  await driver.waitFor(find.byType('AuthForm'));
}

Future<void> authFormAbsent(FlutterDriver driver) async {
  await driver.waitForAbsent(find.byType('AuthForm'));
}