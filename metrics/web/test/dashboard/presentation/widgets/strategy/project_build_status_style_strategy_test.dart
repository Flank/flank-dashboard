// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/theme_data/project_build_status_theme_data.dart';
import 'package:metrics/dashboard/presentation/widgets/strategy/project_build_status_style_strategy.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ProjectBuildStatusStyleStrategy", () {
    const positiveStyle = ProjectBuildStatusStyle(
      backgroundColor: Colors.green,
    );
    const negativeStyle = ProjectBuildStatusStyle(backgroundColor: Colors.red);
    const unknownStyle = ProjectBuildStatusStyle(backgroundColor: Colors.grey);
    const inactiveStyle = ProjectBuildStatusStyle(
      backgroundColor: Colors.black,
    );

    const theme = MetricsThemeData(
      projectBuildStatusTheme: ProjectBuildStatusThemeData(
        attentionLevel: ProjectBuildStatusAttentionLevel(
          positive: positiveStyle,
          negative: negativeStyle,
          unknown: unknownStyle,
          inactive: inactiveStyle,
        ),
      ),
    );

    const themeStrategy = ProjectBuildStatusStyleStrategy();

    test(
      ".getWidgetAppearance() returns the positive style if the given build status is successful",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.successful,
        );

        expect(actualStyle, equals(positiveStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the negative style if the given build status is failed",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.failed,
        );

        expect(actualStyle, equals(negativeStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the unknown style if the given build status is unknown",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.unknown,
        );

        expect(actualStyle, equals(unknownStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the unknown style if the given build status is in progress",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(
          theme,
          BuildStatus.inProgress,
        );

        expect(actualStyle, equals(inactiveStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns null if the given build status is null",
      () {
        final actualStyle = themeStrategy.getWidgetAppearance(theme, null);

        expect(actualStyle, isNull);
      },
    );
  });
}
