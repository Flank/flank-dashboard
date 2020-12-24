import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/debug_menu/presentation/view_models/renderer_display_view_model.dart';

// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("RendererDisplayViewModel", () {
    test(
      "throws an AssertionError if the given current renderer is null",
      () {
        expect(
          () => RendererDisplayViewModel(
            currentRenderer: null,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      "creates an instance with the given current renderer",
      () {
        const currentRenderer = 'Skia';

        final viewModel = RendererDisplayViewModel(
          currentRenderer: currentRenderer,
        );

        expect(viewModel.currentRenderer, equals(currentRenderer));
      },
    );
  });
}
