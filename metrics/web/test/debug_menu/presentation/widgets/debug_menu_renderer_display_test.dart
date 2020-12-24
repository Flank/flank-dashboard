import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/view_models/rendered_display_view_model.dart';
import 'package:metrics/debug_menu/presentation/widgets/debug_menu_renderer_display.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("DebugMenuRendererDisplay", () {
    const metricsTheme = MetricsThemeData(
      debugMenuTheme: DebugMenuThemeData(
        sectionContentTextStyle: MetricsTextStyle(
          lineHeightInPixels: 10,
        ),
      ),
    );

    const renderer = CommonStrings.skia;
    const rendererDisplayViewModel = RendererDisplayViewModel(
      currentRenderer: renderer,
    );

    testWidgets(
      "applies the section content text style from the metrics theme",
      (WidgetTester tester) async {
        final expectedText = CommonStrings.getCurrentRenderer(renderer);
        final expectedStyle =
            metricsTheme.debugMenuTheme.sectionContentTextStyle;

        await tester.pumpWidget(
          _DebugMenuRendererDisplayTestbed(
            metricsThemeData: metricsTheme,
            rendererDisplayViewModel: rendererDisplayViewModel,
          ),
        );

        final content = tester.widget<Text>(
          find.text(expectedText),
        );

        expect(content.style, equals(expectedStyle));
      },
    );

    testWidgets(
      "displays the SKIA renderer text if the application uses the Skia renderer",
      (WidgetTester tester) async {
        const renderer = CommonStrings.skia;
        final rendererViewModel = RendererDisplayViewModel(
          currentRenderer: renderer,
        );
        final expectedText = CommonStrings.getCurrentRenderer(renderer);

        await tester.pumpWidget(
          _DebugMenuRendererDisplayTestbed(
            rendererDisplayViewModel: rendererViewModel,
          ),
        );

        expect(find.text(expectedText), findsOneWidget);
      },
    );

    testWidgets(
      "displays the HTML renderer text if the application uses the HTML renderer",
      (WidgetTester tester) async {
        const renderer = CommonStrings.html;
        final rendererViewModel = RendererDisplayViewModel(
          currentRenderer: renderer,
        );
        final expectedText = CommonStrings.getCurrentRenderer(renderer);

        await tester.pumpWidget(
          _DebugMenuRendererDisplayTestbed(
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

  /// Creates a new instance of this testbed with the given [platform].
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
