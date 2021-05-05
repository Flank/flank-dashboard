// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/widgets/build_status_view.dart';
import 'package:metrics/common/presentation/widgets/theme_mode_builder.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_asset_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';
import '../../../test_utils/theme_notifier_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectBuildStatus", () {
    const backgroundColor = Colors.red;
    const widgetStyle = ProjectBuildStatusStyle(
      backgroundColor: backgroundColor,
    );

    final strategy = _BuildResultThemeStrategyStub(style: widgetStyle);

    final buildStatusViewFinder = find.byType(BuildStatusView);

    testWidgets(
      "throws an AssertionError if the given build status is null",
      (tester) async {
        await tester.pumpWidget(
          const _ProjectBuildStatusTestbed(
            buildStatus: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (tester) async {
        await tester.pumpWidget(
          const _ProjectBuildStatusTestbed(
            strategy: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the background color from the theme provided by strategy",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
            ),
          );
        });

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "displays a build status view widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
            ),
          );
        });

        expect(buildStatusViewFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays a theme mode builder to build the build status view widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
            ),
          );
        });

        final themeModeBuilderFinder = find.ancestor(
          of: find.byType(BuildStatusView),
          matching: find.byType(ThemeModeBuilder),
        );

        expect(themeModeBuilderFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a project build status asset strategy with the correct is dark theme mode value to the build status view",
      (tester) async {
        const expectedIsDarkMode = true;
        final themeNotifier = ThemeNotifierMock();
        when(themeNotifier.isDark).thenReturn(expectedIsDarkMode);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
              themeNotifier: themeNotifier,
            ),
          );
        });

        final buildStatusView = FinderUtil.findBuildStatusView(tester);
        final buildStatusAssetStrategy =
            buildStatusView.strategy as ProjectBuildStatusAssetStrategy;

        expect(buildStatusAssetStrategy.isDarkMode, equals(expectedIsDarkMode));
      },
    );

    testWidgets(
      "displays a build status view widget with the build status from the given project build status view model",
      (tester) async {
        const expectedBuildStatus = BuildStatus.failed;
        const projectBuildStatusViewModel = ProjectBuildStatusViewModel(
          value: expectedBuildStatus,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
              buildStatus: projectBuildStatusViewModel,
            ),
          );
        });

        final buildStatusView = FinderUtil.findBuildStatusView(tester);

        expect(buildStatusView.buildStatus, equals(expectedBuildStatus));
      },
    );

    testWidgets(
      "displays a build status view widget with the unknown build status if the given project build status view model has a null build status",
      (tester) async {
        const expectedBuildStatus = BuildStatus.unknown;
        const projectBuildStatusViewModel = ProjectBuildStatusViewModel(
          value: null,
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
              buildStatus: projectBuildStatusViewModel,
            ),
          );
        });

        final buildStatusView = FinderUtil.findBuildStatusView(tester);

        expect(buildStatusView.buildStatus, equals(expectedBuildStatus));
      },
    );
  });
}

/// A testbed class required to test the [ProjectBuildStatus] widget.
class _ProjectBuildStatusTestbed extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] to use in tests.
  final ProjectBuildStatusViewModel buildStatus;

  /// A [ProjectBuildStatusStyleStrategy] to use in tests.
  final ProjectBuildStatusStyleStrategy strategy;

  /// A [ThemeNotifier] to use in tests.
  final ThemeNotifier themeNotifier;

  /// Creates an instance of the [_ProjectBuildStatusTestbed] with the
  /// given parameters.
  ///
  /// The [buildStatus] defaults to an empty [ProjectBuildStatusViewModel].
  /// The [strategy] defaults to a [ProjectBuildStatusStyleStrategy].
  const _ProjectBuildStatusTestbed({
    Key key,
    this.buildStatus = const ProjectBuildStatusViewModel(),
    this.strategy = const ProjectBuildStatusStyleStrategy(),
    this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: TestInjectionContainer(
        themeNotifier: themeNotifier,
        child: ProjectBuildStatus(
          buildStatusStyleStrategy: strategy,
          buildStatus: buildStatus,
        ),
      ),
    );
  }
}

/// A stub implementation of the [ProjectBuildStatusStyleStrategy].
class _BuildResultThemeStrategyStub implements ProjectBuildStatusStyleStrategy {
  /// A [ProjectBuildStatusStyle] used in stub implementation.
  final ProjectBuildStatusStyle _style;

  /// Creates a new instance of the [_BuildResultThemeStrategyStub].
  ///
  /// If the [style] is null, the [ProjectBuildStatusStyle] used.
  _BuildResultThemeStrategyStub({
    ProjectBuildStatusStyle style,
  }) : _style = style ?? const ProjectBuildStatusStyle();

  @override
  ProjectBuildStatusStyle getWidgetAppearance(
    MetricsThemeData themeData,
    BuildStatus value,
  ) {
    return _style;
  }
}
