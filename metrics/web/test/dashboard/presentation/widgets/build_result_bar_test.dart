// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/colored_bar/widgets/metrics_colored_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_appearance_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBar", () {
    final successfulBuildResult = FinishedBuildResultViewModel(
      buildResultPopupViewModel: BuildResultPopupViewModel(
        date: DateTime.now(),
        duration: Duration.zero,
        buildStatus: BuildStatus.successful,
      ),
      date: DateTime.now(),
      duration: const Duration(seconds: 20),
      buildStatus: BuildStatus.successful,
      url: 'url',
    );

    final metricsColoredBarFinder = find.byWidgetPredicate(
      (widget) => widget is MetricsColoredBar<BuildStatus>,
    );

    final mouseRegionFinder = find.ancestor(
      of: find.byType(GestureDetector),
      matching: find.byType(MouseRegion),
    );

    MetricsColoredBar getMetricsColoredBar(WidgetTester tester) {
      return tester.widget<MetricsColoredBar>(metricsColoredBarFinder);
    }

    Future<void> hoverBar(WidgetTester tester) async {
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
      mouseRegion.onEnter(const PointerEnterEvent());

      await mockNetworkImagesFor(() {
        return tester.pumpAndSettle();
      });
    }

    // const metricsTheme = MetricsThemeData(
    //   inactiveWidgetTheme: MetricsWidgetThemeData(
    //     primaryColor: Colors.red,
    //   ),
    // );

    // final placeholderFinder = find.byType(PlaceholderBar);

    // final urlLauncherMock = _UrlLauncherMock();
    // UrlLauncherPlatform.instance = urlLauncherMock;

    // tearDown(() {
    //   reset(urlLauncherMock);
    // });

    // testWidgets(
    //   "displays the PlaceholderBar if the given build result is null",
    //   (tester) async {
    //     await tester.pumpWidget(const _BuildResultBarTestbed(
    //       buildResult: null,
    //     ));

    //     expect(placeholderFinder, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   "applies the bar color from the inactive widget theme to the PlaceholderBar",
    //   (WidgetTester tester) async {
    //     final expectedColor = metricsTheme.inactiveWidgetTheme.primaryColor;

    //     await tester.pumpWidget(const _BuildResultBarTestbed(
    //       buildResult: null,
    //       themeData: metricsTheme,
    //     ));

    //     final placeholderBar = tester.widget<PlaceholderBar>(placeholderFinder);

    //     expect(placeholderBar.color, expectedColor);
    //   },
    // );

    // testWidgets(
    //   "applies the bar width from the dimension config to the PlaceholderBar",
    //   (WidgetTester tester) async {
    //     const expectedWidth = DimensionsConfig.graphBarWidth;

    //     await tester.pumpWidget(const _BuildResultBarTestbed(
    //       buildResult: null,
    //     ));

    //     final placeholderBar = tester.widget<PlaceholderBar>(placeholderFinder);

    //     expect(placeholderBar.width, expectedWidth);
    //   },
    // );

    // testWidgets(
    //   "opens the BuildResultPopupCard widget on hover",
    //   (WidgetTester tester) async {
    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: successfulBuildResult,
    //     ));

    //     await _hoverBar(tester);

    //     expect(find.byType(BuildResultPopupCard), findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   "closes the BuildResultPopupCard widget on exit",
    //   (WidgetTester tester) async {
    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: successfulBuildResult,
    //     ));

    //     await _hoverBar(tester);
    //     final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
    //     mouseRegion.onExit(const PointerExitEvent());
    //     await tester.pumpAndSettle();

    //     expect(find.byType(BuildResultPopupCard), findsNothing);
    //   },
    // );

    // testWidgets(
    //   "does not display the graph indicator if the popup is closed",
    //   (tester) async {
    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: successfulBuildResult,
    //     ));

    //     final graphIndicatorFinder = find.byWidgetPredicate(
    //       (widget) => widget is GraphIndicator,
    //     );

    //     expect(graphIndicatorFinder, findsNothing);
    //   },
    // );

    // testWidgets(
    //   "displays the positive graph indicator if the build status is successful and the popup is opened",
    //   (tester) async {
    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: successfulBuildResult,
    //     ));

    //     await _hoverBar(tester);

    //     final positiveIndicatorFinder = find.byType(PositiveGraphIndicator);

    //     expect(positiveIndicatorFinder, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   "displays the negative graph indicator if the build status is failed and the popup is opened",
    //   (tester) async {
    //     final buildResult = FinishedBuildResultViewModel(
    //       buildResultPopupViewModel: BuildResultPopupViewModel(
    //         date: DateTime.now(),
    //         duration: Duration.zero,
    //         buildStatus: BuildStatus.failed,
    //       ),
    //       date: DateTime.now(),
    //       duration: Duration.zero,
    //       buildStatus: BuildStatus.failed,
    //     );

    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: buildResult,
    //     ));

    //     await _hoverBar(tester);

    //     final negativeIndicatorFinder = find.byType(NegativeGraphIndicator);

    //     expect(negativeIndicatorFinder, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   "displays the neutral graph indicator if the build status is unknown and the popup is opened",
    //   (tester) async {
    //     final buildResult = FinishedBuildResultViewModel(
    //       buildResultPopupViewModel: BuildResultPopupViewModel(
    //         date: DateTime.now(),
    //         duration: Duration.zero,
    //         buildStatus: BuildStatus.unknown,
    //       ),
    //       date: DateTime.now(),
    //       duration: Duration.zero,
    //       buildStatus: BuildStatus.unknown,
    //     );

    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: buildResult,
    //     ));

    //     await _hoverBar(tester);

    //     final neutralIndicatorFinder = find.byType(NeutralGraphIndicator);

    //     expect(neutralIndicatorFinder, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   "displays the neutral graph indicator if the build status is in progress and the popup is opened",
    //   (tester) async {
    //     final buildResult = InProgressBuildResultViewModel(
    //       buildResultPopupViewModel: BuildResultPopupViewModel(
    //         date: DateTime.now(),
    //         duration: Duration.zero,
    //         buildStatus: BuildStatus.unknown,
    //       ),
    //       date: DateTime.now(),
    //     );

    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: buildResult,
    //     ));

    //     await _hoverBar(tester);

    //     final neutralIndicatorFinder = find.byType(NeutralGraphIndicator);

    //     expect(neutralIndicatorFinder, findsOneWidget);
    //   },
    // );

    // testWidgets(
    //   "applies the padding returned from the given build result bar strategy",
    //   (tester) async {
    //     final strategy = BuildResultBarPaddingStrategy(
    //       buildResults: [successfulBuildResult],
    //     );
    //     final expectedPadding = strategy.getBarPadding(successfulBuildResult);

    //     await tester.pumpWidget(_BuildResultBarTestbed(
    //       buildResult: successfulBuildResult,
    //       strategy: strategy,
    //     ));

    //     final paddingWidget = tester.widget<Padding>(find.byWidgetPredicate(
    //       (widget) => widget is Padding && widget.child is Stack,
    //     ));

    //     expect(paddingWidget.padding, equals(expectedPadding));
    //   },
    // );

    // testWidgets(
    //   "opens the build result url on tap if the url can be launched",
    //   (tester) async {
    //     await tester.pumpWidget(
    //       _BuildResultBarTestbed(
    //         buildResult: successfulBuildResult,
    //       ),
    //     );
    //     final url = successfulBuildResult.url;

    //     when(urlLauncherMock.canLaunch(url)).thenAnswer(
    //       (_) => Future.value(true),
    //     );
    //     await tester.tap(find.byType(BuildResultBar));

    //     verify(urlLauncherMock.launch(
    //       url,
    //       useSafariVC: anyNamed('useSafariVC'),
    //       useWebView: anyNamed('useWebView'),
    //       enableJavaScript: anyNamed('enableJavaScript'),
    //       enableDomStorage: anyNamed('enableDomStorage'),
    //       universalLinksOnly: anyNamed('universalLinksOnly'),
    //       headers: anyNamed('headers'),
    //     )).called(once);
    //   },
    // );

    // testWidgets(
    //   "does not open the build result url on tap if the url can't be launched",
    //   (tester) async {
    //     await tester.pumpWidget(
    //       _BuildResultBarTestbed(
    //         buildResult: successfulBuildResult,
    //       ),
    //     );
    //     final url = successfulBuildResult.url;

    //     when(urlLauncherMock.canLaunch(url)).thenAnswer(
    //       (_) => Future.value(false),
    //     );
    //     await tester.tap(find.byType(BuildResultBar));

    //     verifyNever(urlLauncherMock.launch(
    //       url,
    //       useSafariVC: anyNamed('useSafariVC'),
    //       useWebView: anyNamed('useWebView'),
    //       enableJavaScript: anyNamed('enableJavaScript'),
    //       enableDomStorage: anyNamed('enableDomStorage'),
    //       universalLinksOnly: anyNamed('universalLinksOnly'),
    //       headers: anyNamed('headers'),
    //     ));
    //   },
    // );

    testWidgets(
      "throws an AssertionError if the given build result view model is null",
      (tester) async {
        await tester.pumpWidget(const _BuildResultBarTestbed(
          buildResult: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the MetricsColoredBar with the BuildResultBarAppearanceStrategy",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        final bar = getMetricsColoredBar(tester);

        expect(bar.strategy, isA<BuildResultBarAppearanceStrategy>());
      },
    );

    testWidgets(
      "displays the MetricsColoredBar with the build status from the build result view model",
      (tester) async {
        final expectedStatus = successfulBuildResult.buildStatus;
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        final bar = getMetricsColoredBar(tester);

        expect(bar.value, equals(expectedStatus));
      },
    );

    testWidgets(
      "applies the tappable area",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        expect(find.byType(TappableArea), findsOneWidget);
      },
    );

    testWidgets(
      "hovers the metrics colored bar on hover",
      (tester) async {
        await tester.pumpWidget(_BuildResultBarTestbed(
          buildResult: successfulBuildResult,
        ));

        await hoverBar(tester);

        final bar = getMetricsColoredBar(tester);

        expect(bar.isHovered, isTrue);
      },
    );

    testWidgets(
      "applies the minimum height to the metrics colored bar from the constraints",
      (tester) async {
        const expectedHeight = 10.0;

        await tester.pumpWidget(
          _BuildResultBarTestbed(
            constraints: const BoxConstraints(minHeight: expectedHeight),
            buildResult: successfulBuildResult,
          ),
        );

        final bar = getMetricsColoredBar(tester);

        expect(bar.height, equals(expectedHeight));
      },
    );
  });
}

/// A testbed class required to test the [BuildResultBar].
class _BuildResultBarTestbed extends StatelessWidget {
  /// A [BuildResultViewModel] to display.
  final BuildResultViewModel buildResult;

  /// A [BoxConstraints] to apply to this bar in tests.
  final BoxConstraints constraints;

  /// Creates an instance of this testbed.
  ///
  /// The [themeData] default value is an empty [MetricsThemeData] instance.
  /// The [strategy] default value is an empty
  /// [BuildResultBarPaddingStrategy] instance.
  /// The [barHeight] default value is `20.0`.
  const _BuildResultBarTestbed({
    Key key,
    this.buildResult,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          constraints: constraints,
          child: BuildResultBar(
            buildResult: buildResult,
          ),
        ),
      ),
    );
  }
}

// class _UrlLauncherMock extends Mock
//     with MockPlatformInterfaceMixin
//     implements UrlLauncherPlatform {}
