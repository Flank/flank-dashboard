import 'package:metrics/instant_config/presentation/view_models/fps_monitor_instant_config_view_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors

void main() {
  group(
    "FpsMonitorInstantConfigViewModel",
    () {
      test(
        "throws an AssertionError if the given is enabled is null",
        () {
          expect(
            () => FpsMonitorInstantConfigViewModel(isEnabled: null),
            MatcherUtil.throwsAssertionError,
          );
        },
      );

      test(
        "creates an instance with the given is enabled",
        () {
          const isEnabled = false;

          final viewModel = FpsMonitorInstantConfigViewModel(
            isEnabled: isEnabled,
          );

          expect(viewModel.isEnabled, equals(isEnabled));
        },
      );
    },
  );
}
