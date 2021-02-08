// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/value_image/widgets/value_network_image.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_image_strategy.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectBuildStatus", () {
    const successfulBuildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.successful,
    );

    testWidgets(
      "throws an AssertionError if the given build status is null",
      (tester) async {
        await tester.pumpWidget(const _ProjectBuildStatusTestbed(
          buildStatus: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (tester) async {
        await tester.pumpWidget(const _ProjectBuildStatusTestbed(
          strategy: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the background color from the theme provided by strategy",
      (tester) async {
        const backgroundColor = Colors.red;
        const widgetStyle = ProjectBuildStatusStyle(
          backgroundColor: backgroundColor,
        );

        final strategy = _BuildResultThemeStrategyStub(style: widgetStyle);

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
              buildStatus: successfulBuildStatus,
            ),
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration.color, equals(backgroundColor));
      },
    );

    testWidgets(
      "displays the ValueImage with the build status from the given view model",
      (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: successfulBuildStatus,
            ),
          ),
        );

        final valueImage = tester.widget<ValueNetworkImage<BuildStatus>>(
          find.byWidgetPredicate(
              (widget) => widget is ValueNetworkImage<BuildStatus>),
        );

        expect(valueImage.value, equals(successfulBuildStatus.value));
      },
    );

    testWidgets(
      "displays the ValueImage with the ProjectBuildStatusImageStrategy",
      (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: successfulBuildStatus,
            ),
          ),
        );

        final valueImage = tester.widget<ValueNetworkImage<BuildStatus>>(
          find.byWidgetPredicate(
            (widget) => widget is ValueNetworkImage<BuildStatus>,
          ),
        );

        expect(valueImage.strategy, isA<ProjectBuildStatusImageStrategy>());
      },
    );
  });
}

/// A testbed class required to test the [ProjectBuildStatus] widget.
class _ProjectBuildStatusTestbed extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] to display.
  final ProjectBuildStatusViewModel buildStatus;

  /// A class that represents the strategy of applying the [MetricsThemeData]
  /// based on the [BuildStatus] value.
  final ProjectBuildStatusStyleStrategy strategy;

  /// Creates an instance of this testbed.
  ///
  /// The [buildStatus] defaults to an empty [ProjectBuildStatusViewModel].
  /// The [strategy] defaults to [ProjectBuildStatusStyleStrategy].
  const _ProjectBuildStatusTestbed({
    Key key,
    this.buildStatus = const ProjectBuildStatusViewModel(),
    this.strategy = const ProjectBuildStatusStyleStrategy(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ProjectBuildStatus(
        buildStatusStyleStrategy: strategy,
        buildStatus: buildStatus,
      ),
    );
  }
}

/// A stub implementation of the [ProjectBuildStatusStyleStrategy].
class _BuildResultThemeStrategyStub implements ProjectBuildStatusStyleStrategy {
  /// A [ProjectBuildStatusStyle] used in stub implementation.
  final ProjectBuildStatusStyle _style;

  /// Creates a new instance of this stub.
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
