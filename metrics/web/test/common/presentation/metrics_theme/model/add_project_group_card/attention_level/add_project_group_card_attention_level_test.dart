// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("AddProjectGroupCardAttentionLevel", () {
    test(
      "creates an instance with default positive style",
      () {
        const attentionLevel = AddProjectGroupCardAttentionLevel();

        expect(attentionLevel.positive, isNotNull);
      },
    );

    test(
      "creates an instance with default inactive style",
      () {
        const attentionLevel = AddProjectGroupCardAttentionLevel();

        expect(attentionLevel.inactive, isNotNull);
      },
    );

    test(
      "creates an instance with default styles if the given parameters are null",
      () {
        const attentionLevel = AddProjectGroupCardAttentionLevel(
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
          positive: positiveStyle,
          inactive: inactiveStyle,
        );

        expect(attentionLevel.positive, equals(positiveStyle));
        expect(attentionLevel.inactive, equals(inactiveStyle));
      },
    );
  });
}
