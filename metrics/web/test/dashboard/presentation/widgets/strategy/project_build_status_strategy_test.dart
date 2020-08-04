import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/theme_data/project_build_status_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusStrategy", () {
    const positiveStyle = ProjectBuildStatusStyle(
      backgroundColor: Colors.green,
    );
    const negativeStyle = ProjectBuildStatusStyle(backgroundColor: Colors.red);
    const inactiveStyle = ProjectBuildStatusStyle(backgroundColor: Colors.grey);

    const theme = MetricsThemeData(
      projectBuildStatusTheme: ProjectBuildStatusThemeData(
        attentionLevel: ProjectBuildStatusAttentionLevel(
          positive: positiveStyle,
          negative: negativeStyle,
          inactive: inactiveStyle,
        ),
      ),
    );

    const themeStrategy = ProjectBuildStatusStrategy();

    test(
      ".getWidgetStyle() returns the positive style if the given build status is successful",
      () {
        final actualStyle = themeStrategy.getWidgetStyle(
          theme,
          BuildStatus.successful,
        );

        expect(actualStyle, equals(positiveStyle));
      },
    );

    test(
      ".getWidgetStyle() returns the negative style if the given build status is failed",
      () {
        final actualStyle = themeStrategy.getWidgetStyle(
          theme,
          BuildStatus.failed,
        );

        expect(actualStyle, equals(negativeStyle));
      },
    );

    test(
      ".getWidgetStyle() returns the negative style if the given build status is cancelled",
      () {
        final actualStyle = themeStrategy.getWidgetStyle(
          theme,
          BuildStatus.cancelled,
        );

        expect(actualStyle, equals(negativeStyle));
      },
    );

    test(
      ".getWidgetStyle() returns the inactive style if the given build status is null",
      () {
        final actualStyle = themeStrategy.getWidgetStyle(theme, null);

        expect(actualStyle, equals(inactiveStyle));
      },
    );

    test(
      ".getIconImage() returns a path to the successful status icon if the given build status is null",
      () {
        const expectedIconPath = 'icons/successful_status.svg';

        final actualIconPath = themeStrategy.getIconImage(
          BuildStatus.successful,
        );

        expect(actualIconPath, equals(expectedIconPath));
      },
    );

    test(
      ".getIconImage() returns a path to the failed status icon if the given build status is cancelled",
      () {
        const expectedIconPath = 'icons/failed_status.svg';

        final actualIconPath = themeStrategy.getIconImage(
          BuildStatus.cancelled,
        );

        expect(actualIconPath, equals(expectedIconPath));
      },
    );

    test(
      ".getIconImage() returns a path to the failed status icon if the given build status is failed",
      () {
        const expectedIconPath = 'icons/failed_status.svg';

        final actualIconPath = themeStrategy.getIconImage(
          BuildStatus.failed,
        );

        expect(actualIconPath, equals(expectedIconPath));
      },
    );

    test(
      ".getIconImage() returns a path to the unknown status icon if the given build status is null",
      () {
        const expectedIconPath = 'icons/unknown_status.svg';

        final actualIconPath = themeStrategy.getIconImage(null);

        expect(actualIconPath, equals(expectedIconPath));
      },
    );
  });
}
