// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/attention_level/project_build_status_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/style/project_build_status_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_build_status/theme_data/project_build_status_theme_data.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ProjectBuildStatusThemeData", () {
    test(
      "creates a theme with default attention level if the given attention level is null",
      () {
        const theme = ProjectBuildStatusThemeData(
          attentionLevel: null,
        );

        expect(theme.attentionLevel, isNotNull);
      },
    );

    test("creates a theme with the given attention level", () {
      const attentionLevel = ProjectBuildStatusAttentionLevel(
        positive: ProjectBuildStatusStyle(
          backgroundColor: Colors.red,
        ),
      );

      const theme = ProjectBuildStatusThemeData(attentionLevel: attentionLevel);

      expect(theme.attentionLevel, equals(attentionLevel));
    });
  });
}
