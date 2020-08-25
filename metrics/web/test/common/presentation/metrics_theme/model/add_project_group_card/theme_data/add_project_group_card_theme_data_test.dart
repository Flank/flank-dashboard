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
      "creates a theme with the default button styles if the parameters are not specified",
      () {
        const themeData = AddProjectGroupCardThemeData();

        expect(themeData.attentionLevel.positiveStyle, isNotNull);
        expect(themeData.attentionLevel.inactiveStyle, isNotNull);
      },
    );

    test("creates an instance with the given values", () {
      const positiveStyle = AddProjectGroupCardStyle(
        backgroundColor: Colors.red,
        iconColor: Colors.red,
        hoverColor: Colors.red,
        labelStyle: TextStyle(color: Colors.red),
      );

      const inactiveStyle = AddProjectGroupCardStyle(
        backgroundColor: Colors.grey,
        iconColor: Colors.grey,
        hoverColor: Colors.grey,
        labelStyle: TextStyle(color: Colors.grey),
      );

      final themeData = AddProjectGroupCardThemeData(
        attentionLevel: AddProjectGroupCardAttentionLevel(
          positiveStyle: positiveStyle,
          inactiveStyle: inactiveStyle,
        ),
      );

      expect(themeData.attentionLevel.positiveStyle, equals(positiveStyle));
      expect(themeData.attentionLevel.inactiveStyle, equals(inactiveStyle));
    });
  });
}
