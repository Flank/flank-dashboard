// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';

void main() {
  group("LocalConfig", () {
    test(
      "creates an instance with the given parameters",
      () {
        const isFpsMonitorEnabled = true;

        const localConfig = LocalConfig(
          isFpsMonitorEnabled: isFpsMonitorEnabled,
        );

        expect(localConfig.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
      },
    );
  });
}
