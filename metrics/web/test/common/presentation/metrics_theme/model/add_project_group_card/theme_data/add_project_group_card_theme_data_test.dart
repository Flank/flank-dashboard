// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/theme_data/add_project_group_card_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("AddProjectGroupThemeData", () {
    test(
      "creates a theme with the default attention level if it is not specified",
      () {
        const themeData = AddProjectGroupCardThemeData();

        expect(themeData.attentionLevel, isNotNull);
      },
    );

    test("creates an instance with the given attention level", () {
      const addProjectGroupCardStyle = AddProjectGroupCardStyle(
        backgroundColor: Colors.green,
      );

      const attentionLevel = AddProjectGroupCardAttentionLevel(
        positive: addProjectGroupCardStyle,
        inactive: addProjectGroupCardStyle,
      );

      const themeData = AddProjectGroupCardThemeData(
        attentionLevel: attentionLevel,
      );

      expect(themeData.attentionLevel, equals(attentionLevel));
    });
  });
}
