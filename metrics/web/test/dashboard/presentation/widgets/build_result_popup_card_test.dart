// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_image_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

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
      buildStatus: BuildStatus.unknown,
    );
    final titleFinder = find.text(DateFormat('EEEE, MMM d').format(
      buildResultPopupViewModel.date,
    ));
    final subtitleFinder = find.text(CommonStrings.duration(
      buildResultPopupViewModel.duration,
    ));

    testWidgets(
      "throws an AssertionError if the given build result popup view model is null",
      (tester) async {
        await tester.pumpWidget(
          const _BuildResultPopupCardTestbed(
            buildResultPopupViewModel: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the title with the date from the given view model",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
          ));
        });

        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the subtitle with the duration from the given view model",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
          ));
        });
        expect(subtitleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the color to the card from the metrics theme to the card",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
            themeData: themeData,
          ));
        });

        final card = tester.widget<Card>(find.byType(Card));

        expect(card.color, equals(color));
      },
    );

    testWidgets(
      "applies the shadow color from the metrics theme to the build result popup card",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
            themeData: themeData,
          ));
        });

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
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
            themeData: themeData,
          ));
        });

        final textWidget = tester.widget<Text>(titleFinder);

        expect(textWidget.style, equals(titleTextStyle));
      },
    );

    testWidgets(
      "applies the subtitle text style from the metrics theme to the subtitle",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
            themeData: themeData,
          ));
        });

        final textWidget = tester.widget<Text>(subtitleFinder);

        expect(textWidget.style, equals(subtitleTextStyle));
      },
    );

    testWidgets(
      "displays the ValueImage with the build status from the given view model",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
            themeData: themeData,
          ));
        });

        final valueImage = tester.widget<ValueNetworkImage<BuildStatus>>(
          find.byWidgetPredicate(
              (widget) => widget is ValueNetworkImage<BuildStatus>),
        );

        expect(valueImage.value, equals(buildResultPopupViewModel.buildStatus));
      },
    );

    testWidgets(
      "displays the ValueImage with the BuildResultPopupImageStrategy",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_BuildResultPopupCardTestbed(
            buildResultPopupViewModel: buildResultPopupViewModel,
            themeData: themeData,
          ));
        });

        final valueImage = tester.widget<ValueNetworkImage<BuildStatus>>(
          find.byWidgetPredicate(
            (widget) => widget is ValueNetworkImage<BuildStatus>,
          ),
        );

        expect(valueImage.strategy, isA<BuildResultPopupImageStrategy>());
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
