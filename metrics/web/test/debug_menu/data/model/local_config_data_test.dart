// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/data/model/local_config_data.dart';

void main() {
  group("LocalConfigData", () {
    const isFpsMonitorEnabled = false;

    const configJson = {
      'isFpsMonitorEnabled': isFpsMonitorEnabled,
    };

    const config = LocalConfigData(isFpsMonitorEnabled: isFpsMonitorEnabled);

    test(
      "creates an instance with the given is fps monitor enabled",
      () {
        const config = LocalConfigData(
          isFpsMonitorEnabled: isFpsMonitorEnabled,
        );

        expect(config.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
      },
    );

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final config = LocalConfigData.fromJson(null);

        expect(config, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final actualConfig = LocalConfigData.fromJson(configJson);

        expect(actualConfig, equals(config));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        expect(config.toJson(), equals(configJson));
      },
    );
  });
}
