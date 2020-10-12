import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultPopupCard", () {
    const color = Colors.green;
    const shadowColor = Colors.purple;
    const titleTextStyle = TextStyle(fontSize: 12.0);
    const subtitleTextStyle = TextStyle(fontSize: 8.0);
    const themeData = MetricsThemeData(
      barGraphPopupTheme: BarGraphPopupThemeData(
        color: color,
        shadowColor: shadowColor,
        titleTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
      ),
    );
    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: const Duration(seconds: 30000),
      date: DateTime.now(),
    );
    final expectedTitle = DateFormat('EEEE, MMM d').format(
      buildResultPopupViewModel.date,
    );
    final expectedSubTitle = CommonStrings.duration(
      buildResultPopupViewModel.duration,
    );
    final titleFinder = find.text(expectedTitle);
    final subTitleFinder = find.text(expectedSubTitle);

    testWidgets(
      "throws an AssertionError if the given build result popup view model is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _BuildResultPopupCardTestbed(
            buildResultPopupViewModel: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the title as a date of view model",
      (tester) async {
        await tester.pumpWidget(_BuildResultPopupCardTestbed(
          buildResultPopupViewModel: buildResultPopupViewModel,
        ));

        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the subtitle as a duration of view model",
      (tester) async {
        await tester.pumpWidget(_BuildResultPopupCardTestbed(
          buildResultPopupViewModel: buildResultPopupViewModel,
        ));

        expect(subTitleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the color from the metrics theme to the card",
      (tester) async {
        await tester.pumpWidget(_BuildResultPopupCardTestbed(
          buildResultPopupViewModel: buildResultPopupViewModel,
          themeData: themeData,
        ));

        final card = tester.widget<Card>(find.byType(Card));

        expect(card.color, equals(color));
      },
    );

    testWidgets(
      "applies the shadow color from the metrics theme to the build result popup card",
      (tester) async {
        await tester.pumpWidget(_BuildResultPopupCardTestbed(
          buildResultPopupViewModel: buildResultPopupViewModel,
          themeData: themeData,
        ));

        final container = tester.widget<Container>(
          find.ancestor(
            of: find.byType(Card),
            matching: find.byType(Container),
          ),
        );
        final decoration = container.decoration as BoxDecoration;
        final boxShadow = decoration.boxShadow.first;

        expect(boxShadow.color, equals(shadowColor));
      },
    );

    testWidgets(
      "applies the title text style from the metrics theme to the title",
      (tester) async {
        await tester.pumpWidget(_BuildResultPopupCardTestbed(
          buildResultPopupViewModel: buildResultPopupViewModel,
          themeData: themeData,
        ));

        final textWidget = tester.widget<Text>(titleFinder);

        expect(textWidget.style, equals(titleTextStyle));
      },
    );

    testWidgets(
      "applies the subtitle text style from the metrics theme to the subtitle",
      (tester) async {
        await tester.pumpWidget(_BuildResultPopupCardTestbed(
          buildResultPopupViewModel: buildResultPopupViewModel,
          themeData: themeData,
        ));

        final textWidget = tester.widget<Text>(subTitleFinder);

        expect(textWidget.style, equals(subtitleTextStyle));
      },
    );
  });
}

/// A testbed class required to test the [BuildResultPopupCard].
class _BuildResultPopupCardTestbed extends StatelessWidget {
  /// A [BuildResultPopupViewModel] with data to display.
  final BuildResultPopupViewModel buildResultPopupViewModel;

  /// A [MetricsThemeData] used in tests.
  final MetricsThemeData themeData;

  /// Creates an instance of this testbed.
  ///
  /// The [themeData] defaults to an empty [MetricsThemeData] instance.
  const _BuildResultPopupCardTestbed({
    Key key,
    this.themeData = const MetricsThemeData(),
    this.buildResultPopupViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: BuildResultPopupCard(
        buildResultPopupViewModel: buildResultPopupViewModel,
      ),
    );
  }
}
