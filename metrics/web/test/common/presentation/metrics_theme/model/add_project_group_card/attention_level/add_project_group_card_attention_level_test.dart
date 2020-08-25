import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:test/test.dart';

void main() {
  group("AddProjectGroupCardAttentionLevel", () {
    test(
      "creates an instance with default styles if styles are not specified",
      () {
        const attentionLevel = AddProjectGroupCardAttentionLevel();

        expect(attentionLevel.positiveStyle, isNotNull);
        expect(attentionLevel.inactiveStyle, isNotNull);
      },
    );

    test(
      "creates an instance with the given styles",
      () {
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
        const attentionLevel = AddProjectGroupCardAttentionLevel(
          positiveStyle: positiveStyle,
          inactiveStyle: inactiveStyle,
        );

        expect(attentionLevel.positiveStyle, equals(positiveStyle));
        expect(attentionLevel.inactiveStyle, equals(inactiveStyle));
      },
    );
  });
}
