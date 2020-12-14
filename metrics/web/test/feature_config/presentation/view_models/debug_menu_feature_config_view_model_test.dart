import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/feature_config/presentation/view_models/debug_menu_feature_config_view_model.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors

void main() {
  group("DebugMenuFeatureConfigViewModel", () {
    test(
      "throws an AssertionError if the given is enabled is null",
      () {
        expect(
          () => DebugMenuFeatureConfigViewModel(isEnabled: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given is enabled value",
      () {
        const isEnabled = false;

        final viewModel = DebugMenuFeatureConfigViewModel(
          isEnabled: isEnabled,
        );

        expect(viewModel.isEnabled, equals(isEnabled));
      },
    );
  });
}
