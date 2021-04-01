// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/graphs/placeholder_bar.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/negative_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/neutral_graph_indicator.dart';
import 'package:metrics/common/presentation/graph_indicator/widgets/positive_graph_indicator.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_widget_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_popup_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/finished_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/view_models/in_progress_build_result_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_component.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_popup_card.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/build_result_bar_padding_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../test_utils/matchers.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildResultBarComponent", () {
    const metricsTheme = MetricsThemeData(
      inactiveWidgetTheme: MetricsWidgetThemeData(
        primaryColor: Colors.red,
      ),
    );

    final placeholderFinder = find.byType(PlaceholderBar);
    final graphIndicatorFinder = find.byType(GraphIndicator);

    final mouseRegionFinder = find.ancestor(
      of: find.byType(GestureDetector),
      matching: find.byType(MouseRegion),
    );

    Future<void> hoverBar(WidgetTester tester) async {
      final mouseRegion = tester.firstWidget<MouseRegion>(mouseRegionFinder);
      mouseRegion.onEnter(const PointerEnterEvent());

      await mockNetworkImagesFor(() {
        return tester.pumpAndSettle();
      });
    }

    final popupViewModel = BuildResultPopupViewModel(
      date: DateTime.now(),
      duration: Duration.zero,
      buildStatus: BuildStatus.successful,
    );

    BuildResultViewModel createBuildResult(BuildStatus status) {
      return FinishedBuildResultViewModel(
        buildResultPopupViewModel: popupViewModel,
        date: DateTime.now(),
        duration: const Duration(seconds: 20),
        buildStatus: status,
        url: 'url',
      );
    }

    final successfulBuildResult = createBuildResult(BuildStatus.successful);
    final failedBuildResult = createBuildResult(BuildStatus.failed);
    final unknownBuildResult = createBuildResult(BuildStatus.unknown);
    final inProgressBuildResult = InProgressBuildResultViewModel(
      buildResultPopupViewModel: popupViewModel,
      date: DateTime.now(),
    );

    final urlLauncherMock = _UrlLauncherMock();
    UrlLauncherPlatform.instance = urlLauncherMock;

    tearDown(() {
      reset(urlLauncherMock);
    });

    testWidgets(
      "displays the PlaceholderBar if the given build result is null",
      (tester) async {
        await tester.pumpWidget(
          const _BuildResultBarComponentTestbed(
            buildResult: null,
          ),
        );

        expect(placeholderFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the bar color from the inactive widget theme to the PlaceholderBar",
      (WidgetTester tester) async {
        final expectedColor = metricsTheme.inactiveWidgetTheme.primaryColor;

        await tester.pumpWidget(
          const _BuildResultBarComponentTestbed(
            buildResult: null,
            themeData: metricsTheme,
          ),
        );

        final placeholderBar = tester.widget<PlaceholderBar>(placeholderFinder);

        expect(placeholderBar.color, expectedColor);
      },
    );

    testWidgets(
      "applies the bar width from the dimension config to the PlaceholderBar",
      (WidgetTester tester) async {
        const expectedWidth = DimensionsConfig.graphBarWidth;

        await tester.pumpWidget(
          const _BuildResultBarComponentTestbed(
            buildResult: null,
          ),
        );

        final placeholderBar = tester.widget<PlaceholderBar>(placeholderFinder);

        expect(placeholderBar.width, expectedWidth);
      },
    );

    testWidgets(
      "displays the build result bar with the given build result",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );

        final buildResultBarFinder = find.byWidgetPredicate((widget) {
          return widget is BuildResultBar &&
              widget.buildResult == successfulBuildResult;
        });

        expect(buildResultBarFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the build result bar in a stack with a passthrough fit",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );

        final stackFinder = find.ancestor(
          of: find.byType(BuildResultBar),
          matching: find.byType(Stack),
        );
        final stack = tester.widget<Stack>(stackFinder);

        expect(stack.fit, equals(StackFit.passthrough));
      },
    );

    testWidgets(
      "opens the BuildResultPopupCard widget on hover",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );

        await hoverBar(tester);

        expect(find.byType(BuildResultPopupCard), findsOneWidget);
      },
    );

    testWidgets(
      "closes the BuildResultPopupCard widget on exit",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );

        await hoverBar(tester);

        final mouseRegion = tester.firstWidget<MouseRegion>(mouseRegionFinder);
        mouseRegion.onExit(const PointerExitEvent());

        await tester.pumpAndSettle();

        expect(find.byType(BuildResultPopupCard), findsNothing);
      },
    );

    testWidgets(
      "does not display the graph indicator if the popup is closed",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );

        expect(graphIndicatorFinder, findsNothing);
      },
    );

    testWidgets(
      "displays the positive graph indicator if the build status is successful and the popup is opened",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );

        await hoverBar(tester);

        expect(find.byType(PositiveGraphIndicator), findsOneWidget);
      },
    );

    testWidgets(
      "displays the negative graph indicator if the build status is failed and the popup is opened",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: failedBuildResult,
          ),
        );

        await hoverBar(tester);

        expect(find.byType(NegativeGraphIndicator), findsOneWidget);
      },
    );

    testWidgets(
      "displays the neutral graph indicator if the build status is unknown and the popup is opened",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: unknownBuildResult,
          ),
        );

        await hoverBar(tester);

        expect(find.byType(NeutralGraphIndicator), findsOneWidget);
      },
    );

    testWidgets(
      "displays the neutral graph indicator if the build status is in-progress and the popup is opened",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: inProgressBuildResult,
          ),
        );

        await hoverBar(tester);

        expect(find.byType(NeutralGraphIndicator), findsOneWidget);
      },
    );

    testWidgets(
      "applies the padding returned from the given build result bar strategy",
      (tester) async {
        final strategy = BuildResultBarPaddingStrategy(
          buildResults: [successfulBuildResult],
        );
        final expectedPadding = strategy.getBarPadding(successfulBuildResult);

        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
            paddingStrategy: strategy,
          ),
        );

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child is Stack,
          ),
        );

        expect(paddingWidget.padding, equals(expectedPadding));
      },
    );

    testWidgets(
      "opens the build result url on tap if the url can be launched",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );
        final url = successfulBuildResult.url;

        when(urlLauncherMock.canLaunch(url)).thenAnswer(
          (_) => Future.value(true),
        );
        await tester.tap(find.byType(BuildResultBarComponent));

        verify(urlLauncherMock.launch(
          url,
          useSafariVC: anyNamed('useSafariVC'),
          useWebView: anyNamed('useWebView'),
          enableJavaScript: anyNamed('enableJavaScript'),
          enableDomStorage: anyNamed('enableDomStorage'),
          universalLinksOnly: anyNamed('universalLinksOnly'),
          headers: anyNamed('headers'),
        )).called(once);
      },
    );

    testWidgets(
      "does not open the build result url on tap if the url can't be launched",
      (tester) async {
        await tester.pumpWidget(
          _BuildResultBarComponentTestbed(
            buildResult: successfulBuildResult,
          ),
        );
        final url = successfulBuildResult.url;

        when(urlLauncherMock.canLaunch(url)).thenAnswer(
          (_) => Future.value(false),
        );
        await tester.tap(find.byType(BuildResultBarComponent));

        verifyNever(urlLauncherMock.launch(
          url,
          useSafariVC: anyNamed('useSafariVC'),
          useWebView: anyNamed('useWebView'),
          enableJavaScript: anyNamed('enableJavaScript'),
          enableDomStorage: anyNamed('enableDomStorage'),
          universalLinksOnly: anyNamed('universalLinksOnly'),
          headers: anyNamed('headers'),
        ));
      },
    );
  });
}

/// A testbed class needed to test the [BuildResultBarComponent].
class _BuildResultBarComponentTestbed extends StatelessWidget {
  /// A [MetricsThemeData] to apply to this bar component in tests.
  final MetricsThemeData themeData;

  /// A [BuildResultViewModel] with data to display.
  final BuildResultViewModel buildResult;

  /// A [BuildResultBarPaddingStrategy] to apply to this bar component in tests.
  final BuildResultBarPaddingStrategy paddingStrategy;

  /// Creates an instance of this testbed.
  const _BuildResultBarComponentTestbed({
    this.buildResult,
    this.paddingStrategy = const BuildResultBarPaddingStrategy(),
    this.themeData = const MetricsThemeData(),
  });

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: themeData,
      body: BuildResultBarComponent(
        buildResult: buildResult,
        paddingStrategy: paddingStrategy,
      ),
    );
  }
}

class _UrlLauncherMock extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}
