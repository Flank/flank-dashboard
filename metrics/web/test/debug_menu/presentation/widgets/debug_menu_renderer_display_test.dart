// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/debug_menu/presentation/strings/debug_menu_strings.dart';
import 'package:metrics/debug_menu/presentation/view_models/renderer_display_view_model.dart';
import 'package:metrics/debug_menu/presentation/widgets/debug_menu_renderer_display.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("DebugMenuRendererDisplay", () {
    const contentTextStyle = MetricsTextStyle(lineHeightInPixels: 10);

    const metricsTheme = MetricsThemeData(
      debugMenuTheme: DebugMenuThemeData(
        sectionContentTextStyle: contentTextStyle,
      ),
    );

    const renderer = DebugMenuStrings.skia;
    const rendererDisplayViewModel = RendererDisplayViewModel(
      currentRenderer: renderer,
    );

    testWidgets(
      "throws an AssertionError if the given renderer display view model is null",
      (WidgetTester tester) async {
        expect(
          () => DebugMenuRendererDisplay(rendererDisplayViewModel: null),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      "applies the section content text style from the metrics theme",
      (WidgetTester tester) async {
        final expectedText = DebugMenuStrings.getCurrentRenderer(renderer);

        await tester.pumpWidget(
          const _DebugMenuRendererDisplayTestbed(
            metricsThemeData: metricsTheme,
            rendererDisplayViewModel: rendererDisplayViewModel,
          ),
        );

        final content = tester.widget<Text>(
          find.text(expectedText),
        );

        expect(content.style, equals(contentTextStyle));
      },
    );

    testWidgets(
      "displays the renderer text from the given view model",
      (WidgetTester tester) async {
        const renderer = DebugMenuStrings.skia;
        const rendererViewModel = RendererDisplayViewModel(
          currentRenderer: renderer,
        );
        final expectedText = DebugMenuStrings.getCurrentRenderer(renderer);

        await tester.pumpWidget(
          const _DebugMenuRendererDisplayTestbed(
            rendererDisplayViewModel: rendererViewModel,
          ),
        );

        expect(find.text(expectedText), findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [DebugMenuRendererDisplay] widget.
class _DebugMenuRendererDisplayTestbed extends StatelessWidget {
  /// A [RendererDisplayViewModel] to use under tests.
  final RendererDisplayViewModel rendererDisplayViewModel;

  /// A [MetricsThemeData] to use under tests.
  final MetricsThemeData metricsThemeData;

  /// Creates a new instance of the [_DebugMenuRendererDisplayTestbed].
  ///
  /// A [metricsThemeData] defaults to the [MetricsThemeData] instance.
  const _DebugMenuRendererDisplayTestbed({
    Key key,
    this.rendererDisplayViewModel,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: DebugMenuRendererDisplay(
        rendererDisplayViewModel: rendererDisplayViewModel,
      ),
    );
  }
}
