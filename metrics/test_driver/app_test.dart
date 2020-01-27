// This is a Flutter Web Driver test
// https://github.com/flutter/flutter/pull/45951

import 'package:flutter_driver/flutter_driver.dart';
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

      test(
        'Loads the coverage data and shows the circle percentage widget',
        () async {
          await driver.waitFor(find.text("COVERAGE"));
          await driver.waitFor(find.text("20%"));
          await driver.waitFor(find.byType('CirclePercentage'));
        },
      );
    },
  );
}
