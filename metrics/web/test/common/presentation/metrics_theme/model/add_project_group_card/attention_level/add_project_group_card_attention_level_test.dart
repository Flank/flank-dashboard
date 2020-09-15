import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("AddProjectGroupCardAttentionLevel", () {
    test(
      "creates an instance with default positive style",
      () {
        final attentionLevel = AddProjectGroupCardAttentionLevel();

        expect(attentionLevel.positive, isNotNull);
      },
    );

    test(
      "creates an instance with default inactive style",
      () {
        final attentionLevel = AddProjectGroupCardAttentionLevel();

        expect(attentionLevel.inactive, isNotNull);
      },
    );

    test(
      "creates an instance with default styles if the given parameters are null",
      () {
        final attentionLevel = AddProjectGroupCardAttentionLevel(
          positive: null,
          inactive: null,
        );

        expect(attentionLevel.positive, isNotNull);
        expect(attentionLevel.inactive, isNotNull);
      },
    );

    test(
      "creates an instance with the given styles",
      () {
        final positiveStyle = AddProjectGroupCardStyle(
          backgroundColor: Colors.red,
          iconColor: Colors.red,
          hoverColor: Colors.red,
          labelStyle: TextStyle(color: Colors.red),
        );

        final inactiveStyle = AddProjectGroupCardStyle(
          backgroundColor: Colors.grey,
          iconColor: Colors.grey,
          hoverColor: Colors.grey,
          labelStyle: TextStyle(color: Colors.grey),
        );

        final attentionLevel = AddProjectGroupCardAttentionLevel(
          positive: positiveStyle,
          inactive: inactiveStyle,
        );

        expect(attentionLevel.positive, equals(positiveStyle));
        expect(attentionLevel.inactive, equals(inactiveStyle));
      },
    );
  });
}
