import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/theme_data/add_project_group_card_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("AddProjectGroupThemeData", () {
    test(
      "creates a theme with the default attention level if it is not specified",
      () {
        final themeData = AddProjectGroupCardThemeData();

        expect(themeData.attentionLevel, isNotNull);
      },
    );

    test("creates an instance with the given attention level", () {
      final addProjectGroupCardStyle = AddProjectGroupCardStyle(
        backgroundColor: Colors.green,
      );

      final attentionLevel = AddProjectGroupCardAttentionLevel(
        positive: addProjectGroupCardStyle,
        inactive: addProjectGroupCardStyle,
      );

      final themeData = AddProjectGroupCardThemeData(
        attentionLevel: attentionLevel,
      );

      expect(themeData.attentionLevel, equals(attentionLevel));
    });
  });
}
