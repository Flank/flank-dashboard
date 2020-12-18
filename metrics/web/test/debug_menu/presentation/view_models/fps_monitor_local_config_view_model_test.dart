import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';

// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("FpsMonitorLocalConfigViewModel", () {
    test(
      "throws an AssertionError if the given is enabled is null",
      () {
        expect(
          () => FpsMonitorLocalConfigViewModel(isEnabled: null),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given is enabled",
      () {
        const isEnabled = false;

        final viewModel = FpsMonitorLocalConfigViewModel(isEnabled: isEnabled);

        expect(viewModel.isEnabled, equals(isEnabled));
      },
    );
  });
}
