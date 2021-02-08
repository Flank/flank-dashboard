// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/domain/usecases/parameters/local_config_param.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LocalConfigParam", () {
    test(
      "throws an ArgumentError if the given is fps monitor enabled is null",
      () {
        expect(
          () => LocalConfigParam(isFpsMonitorEnabled: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given is fps monitor enabled",
      () {
        const isFpsMonitorEnabled = true;

        final param =
            LocalConfigParam(isFpsMonitorEnabled: isFpsMonitorEnabled);

        expect(param.isFpsMonitorEnabled, equals(isFpsMonitorEnabled));
      },
    );
  });
}
