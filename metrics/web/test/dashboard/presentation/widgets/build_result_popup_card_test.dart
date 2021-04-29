// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:metrics/common/presentation/metrics_theme/model/bar_graph_popup/theme_data/bar_graph_popup_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/build_status_view.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_popup_asset_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
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

    const duration = Duration(seconds: 30000);
    const buildStatus = BuildStatus.unknown;

    final date = DateTime.now();

    final buildResultPopupViewModel = BuildResultPopupViewModel(
      duration: duration,
      date: date,
      buildStatus: buildStatus,
    );

    final titleFinder = find.text(DateFormat('EEEE, MMM d').format(
      date,
    ));

    final subtitleFinder = find.text(CommonStrings.duration(
      duration,
    ));

    final buildStatusViewFinder = find.byType(BuildStatusView);

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
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });

        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the subtitle with the duration from the given view model",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });
        expect(subtitleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "does not display the duration subtitle if the duration is null",
      (tester) async {
        final buildResultPopupViewModel = BuildResultPopupViewModel(
          date: DateTime.now(),
          buildStatus: buildStatus,
          duration: null,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });

        expect(find.byType(Text), findsOneWidget);
        expect(titleFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the color to the card from the metrics theme to the card",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
              themeData: themeData,
            ),
          );
        });

        final card = tester.widget<Card>(find.byType(Card));

        expect(card.color, equals(color));
      },
    );

    testWidgets(
      "applies the shadow color from the metrics theme to the build result popup card",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
              themeData: themeData,
            ),
          );
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
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
              themeData: themeData,
            ),
          );
        });

        final textWidget = tester.widget<Text>(titleFinder);

        expect(textWidget.style, equals(titleTextStyle));
      },
    );

    testWidgets(
      "applies the subtitle text style from the metrics theme to the subtitle",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
              themeData: themeData,
            ),
          );
        });

        final textWidget = tester.widget<Text>(subtitleFinder);

        expect(textWidget.style, equals(subtitleTextStyle));
      },
    );

    testWidgets(
      "displays the BuildStatusView widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });

        expect(buildStatusViewFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the build status from the build result popup view model to the build status view widget",
      (tester) async {
        final expectedStatus = buildResultPopupViewModel.buildStatus;
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });

        final buildStatusView = FinderUtil.findBuildStatusView(tester);

        expect(buildStatusView.buildStatus, equals(expectedStatus));
      },
    );

    testWidgets(
      "applies the unknown build status if the given build result popup view model has a null build status",
      (tester) async {
        const expectedStatus = BuildStatus.unknown;
        final buildResultPopupViewModel = BuildResultPopupViewModel(
          date: date,
          buildStatus: null,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });

        final buildStatusView = FinderUtil.findBuildStatusView(tester);

        expect(buildStatusView.buildStatus, equals(expectedStatus));
      },
    );

    testWidgets(
      "applies the build result popup asset strategy to the build status view widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _BuildResultPopupCardTestbed(
              buildResultPopupViewModel: buildResultPopupViewModel,
            ),
          );
        });

        final buildStatusView = FinderUtil.findBuildStatusView(tester);

        expect(buildStatusView.strategy, isA<BuildResultPopupAssetStrategy>());
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
