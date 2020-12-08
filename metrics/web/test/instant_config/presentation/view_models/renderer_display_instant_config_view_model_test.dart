import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/instant_config/presentation/view_models/renderer_display_instant_config_view_model.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: avoid_redundant_argument_values, prefer_const_constructors

void main() {
  group("RendererDisplayInstantConfigViewModel", () {
    test(
      "throws an AssertionError if the given is enabled is null",
      () {
        expect(
          () => RendererDisplayInstantConfigViewModel(isEnabled: null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given is enabled",
      () {
        const isEnabled = true;

        final viewModel = RendererDisplayInstantConfigViewModel(
          isEnabled: isEnabled,
        );

        expect(viewModel.isEnabled, equals(isEnabled));
      },
    );
  });
}
