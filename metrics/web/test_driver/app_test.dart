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
        "loads the projects and shows the project tiles",
        () async {
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
        "loads the performance metric and shows it on sparkline graph",
        () async {
          await driver.waitFor(find.text(DashboardStrings.performance));

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
          await driver.waitFor(find.byType('BuildResultBarGraph'));
        },
      );
    },
  );
}
