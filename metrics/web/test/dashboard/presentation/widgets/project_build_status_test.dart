import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/dashboard/presentation/view_models/project_build_status_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectBuildStatus", () {
    const unknownBuildStatus = ProjectBuildStatusViewModel(value: null);
    const successfulBuildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.successful,
    );
    const failedBuildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.failed,
    );
    const cancelledBuildStatus = ProjectBuildStatusViewModel(
      value: BuildStatus.cancelled,
    );

    testWidgets(
      "applies the primary translucent background color if the build status is successful",
      (tester) async {
        const expectedColor = ColorConfig.primaryTranslucentColor;

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: successfulBuildStatus,
            ),
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration.color, equals(expectedColor));
      },
    );

    testWidgets(
      "displays the successful status icon if the build status is successful",
      (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: successfulBuildStatus,
            ),
          ),
        );

        final networkImage = FinderUtil.findNetworkImageWidget(tester);

        expect(networkImage.url, equals('icons/successful_status.svg'));
      },
    );

    testWidgets(
      "applies the accent translucent background color if the build status is failed",
      (tester) async {
        const expectedColor = ColorConfig.accentTranslucentColor;

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(buildStatus: failedBuildStatus),
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration.color, equals(expectedColor));
      },
    );

    testWidgets(
      "displays the failed status icon if the build status is failed",
      (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: failedBuildStatus,
            ),
          ),
        );

        final networkImage = FinderUtil.findNetworkImageWidget(tester);

        expect(networkImage.url, equals('icons/failed_status.svg'));
      },
    );

    testWidgets(
      "applies the accent translucent background color if the build status is canceled",
      (tester) async {
        const expectedColor = ColorConfig.accentTranslucentColor;

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(buildStatus: cancelledBuildStatus),
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration.color, equals(expectedColor));
      },
    );

    testWidgets(
      "displays the failed status icon if the build status is canceled",
      (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: cancelledBuildStatus,
            ),
          ),
        );

        final networkImage = FinderUtil.findNetworkImageWidget(tester);

        expect(networkImage.url, equals('icons/failed_status.svg'));
      },
    );

    testWidgets(
      "applies the inactive background color if the build status is unknown",
      (tester) async {
        const expectedColor = ColorConfig.inactiveColor;

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: unknownBuildStatus,
            ),
          ),
        );

        final boxDecoration = FinderUtil.findBoxDecoration(tester);

        expect(boxDecoration.color, equals(expectedColor));
      },
    );

    testWidgets(
      "displays the unknown status icon if the build status is unknown",
      (tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            const _ProjectBuildStatusTestbed(
              buildStatus: unknownBuildStatus,
            ),
          ),
        );

        final networkImage = FinderUtil.findNetworkImageWidget(tester);

        expect(networkImage.url, equals('icons/unknown_status.svg'));
      },
    );
  });
}

/// A testbed class required to test the [ProjectBuildStatus] widget.
class _ProjectBuildStatusTestbed extends StatelessWidget {
  /// A [ProjectBuildStatusViewModel] to display.
  final ProjectBuildStatusViewModel buildStatus;

  /// Creates an instance of this testbed.
  ///
  /// The [buildStatus] defaults to the empty [ProjectBuildStatusViewModel].
  const _ProjectBuildStatusTestbed({
    Key key,
    this.buildStatus = const ProjectBuildStatusViewModel(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ProjectBuildStatus(
        buildStatus: buildStatus,
      ),
    );
  }
}
