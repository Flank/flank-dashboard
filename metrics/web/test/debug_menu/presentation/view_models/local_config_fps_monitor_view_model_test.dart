// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/presentation/view_models/local_config_fps_monitor_view_model.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("LocalConfigFpsMonitorViewModel", () {
    test(
      "throws an AssertionError if the given is enabled is null",
      () {
        expect(
          () => LocalConfigFpsMonitorViewModel(isEnabled: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given is enabled",
      () {
        const isEnabled = false;

        const viewModel = LocalConfigFpsMonitorViewModel(isEnabled: isEnabled);

        expect(viewModel.isEnabled, equals(isEnabled));
      },
    );
  });
}
