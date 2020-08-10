import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
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
      "displays the status icon provided by the given strategy",
      (tester) async {
        const expectedIconImage = "icons/expected.svg";

        final strategy = _BuildResultThemeStrategyStub(
          iconImage: expectedIconImage,
        );

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            _ProjectBuildStatusTestbed(
              strategy: strategy,
              buildStatus: successfulBuildStatus,
            ),
          ),
        );

        final networkImage = FinderUtil.findNetworkImageWidget(tester);

        expect(networkImage.url, equals(expectedIconImage));
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
  /// A default test icon image.
  static const _testIconImage = "icons/test_icon.svg";

  /// A [ProjectBuildStatusStyle] used in stub implementation.
  final ProjectBuildStatusStyle _style;

  /// An icon image used in stub implementation.
  final String _iconImage;

  /// Creates a new instance of this stub.
  ///
  /// If the [style] is null, the [ProjectBuildStatusStyle] used.
  /// If the [iconImage] is null, the `icons/test_icon.svg` value used.
  _BuildResultThemeStrategyStub({
    ProjectBuildStatusStyle style,
    String iconImage,
  })  : _style = style ?? const ProjectBuildStatusStyle(),
        _iconImage = iconImage ?? _testIconImage;

  @override
  String getIconImage(BuildStatus value) => _iconImage;

  @override
  ProjectBuildStatusStyle getWidgetAppearance(
    MetricsThemeData themeData,
    BuildStatus value,
  ) {
    return _style;
  }
}
