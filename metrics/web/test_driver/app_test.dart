// This is a Flutter Web Driver test
// https://github.com/flutter/flutter/pull/45951

import 'package:flutter_driver/flutter_driver.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:test/test.dart';

void main() {
  group(
    "DashboardPage",
    () {
      FlutterDriver driver;

      setUpAll(() async {
        driver = await WebFlutterDriver.connectWeb();
      });

      tearDownAll(() async {
        await driver?.close();
      });

      test(
        "loads and shows the projects",
        () async {
          await driver.waitFor(find.byType('ProjectMetricsTile'));
        },
      );

      test(
        "loads and displays coverage metric",
        () async {
          await driver.waitFor(find.text(DashboardStrings.coverage));
          await driver.waitFor(find.byType('CirclePercentage'));
        },
      );

      test(
        "loads and displays the performance metric ",
        () async {
          await driver.waitFor(find.text(DashboardStrings.performance));

          await driver.waitFor(find.byType('SparklineGraph'));
        },
      );

      test(
        "loads and shows the build number metric",
        () async {
          await driver.waitFor(find.text(DashboardStrings.builds));

          await driver.waitFor(find.byType('BuildNumberTextMetric'));
        },
      );

      test(
        "loads and shows the build result metrics",
        () async {
          await driver.waitFor(find.byType('BuildResultBarGraph'));
        },
      );
    },
  );
}
