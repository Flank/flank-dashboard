import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/debug_menu/theme_data/debug_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_text/style/metrics_text_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/widgets/metrics_renderer_display.dart';
import 'package:metrics/util/web_platform.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsRendererDisplay", () {
    const metricsTheme = MetricsThemeData(
      debugMenuTheme: DebugMenuThemeData(
        sectionContentTextStyle: MetricsTextStyle(
          lineHeightInPixels: 10,
        ),
      ),
    );

    final platform = _WebPlatformMock();

    final rendererDisplayFinder = find.byType(MetricsRendererDisplay);

    tearDown(() {
      reset(platform);
    });

    testWidgets(
      "applies the default platform if the given platform is null",
      (WidgetTester tester) async {
        when(platform.isSkia).thenReturn(true);

        await tester.pumpWidget(
          const _MetricsRendererDisplayTestbed(
            platform: null,
          ),
        );

        final rendererDisplay =
            tester.widget<MetricsRendererDisplay>(rendererDisplayFinder);

        expect(rendererDisplay.platform, isNotNull);
      },
    );

    testWidgets(
      "creates an instance with the given platform",
      (WidgetTester tester) async {
        when(platform.isSkia).thenReturn(true);

        await tester.pumpWidget(
          _MetricsRendererDisplayTestbed(
            platform: platform,
          ),
        );

        final rendererDisplay =
            tester.widget<MetricsRendererDisplay>(rendererDisplayFinder);

        expect(rendererDisplay.platform, equals(platform));
      },
    );

    testWidgets(
      "applies the section content text style from the metrics theme",
      (WidgetTester tester) async {
        when(platform.isSkia).thenReturn(true);

        await tester.pumpWidget(
          _MetricsRendererDisplayTestbed(
            metricsThemeData: metricsTheme,
            platform: platform,
          ),
        );

        final expectedText = CommonStrings.currentRenderer(isSkia: true);
        final content = tester.widget<Text>(
          find.text(expectedText),
        );

        final expectedStyle =
            metricsTheme.debugMenuTheme.sectionContentTextStyle;

        expect(content.style, equals(expectedStyle));
      },
    );

    testWidgets(
      "displays the SKIA renderer text if the application uses the Skia renderer",
      (WidgetTester tester) async {
        const isSkia = true;
        when(platform.isSkia).thenReturn(isSkia);

        await tester.pumpWidget(
          _MetricsRendererDisplayTestbed(
            platform: platform,
          ),
        );

        final expectedText = CommonStrings.currentRenderer(isSkia: isSkia);

        expect(find.text(expectedText), findsOneWidget);
      },
    );

    testWidgets(
      "displays the HTML renderer text if the application uses the HTML renderer",
      (WidgetTester tester) async {
        const isSkia = false;
        when(platform.isSkia).thenReturn(isSkia);

        await tester.pumpWidget(
          _MetricsRendererDisplayTestbed(
            platform: platform,
          ),
        );

        final expectedText = CommonStrings.currentRenderer(isSkia: isSkia);

        expect(find.text(expectedText), findsOneWidget);
      },
    );
  });
}

/// A testbed class needed to test the [MetricsRendererDisplay] widget.
class _MetricsRendererDisplayTestbed extends StatelessWidget {
  /// A [WebPlatform] to use under tests.
  final WebPlatform platform;

  /// A [MetricsThemeData] to use under tests.
  final MetricsThemeData metricsThemeData;

  /// Creates a new instance of this testbed with the given [platform].
  const _MetricsRendererDisplayTestbed({
    Key key,
    this.platform,
    this.metricsThemeData = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: metricsThemeData,
      body: MetricsRendererDisplay(
        platform: platform,
      ),
    );
  }
}

class _WebPlatformMock extends Mock implements WebPlatform {}
