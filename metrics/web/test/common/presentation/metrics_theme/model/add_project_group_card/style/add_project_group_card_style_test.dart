import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
void main() {
  group("AddProjectGroupCardStyle", () {
    test(
      "creates an instance with the default background color",
      () {
        const style = AddProjectGroupCardStyle();

        expect(style.backgroundColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default icon color",
      () {
        const style = AddProjectGroupCardStyle();

        expect(style.iconColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default hover color",
      () {
        const style = AddProjectGroupCardStyle();

        expect(style.hoverColor, isNotNull);
      },
    );

    test(
      "creates an instance with the default label style",
      () {
        const style = AddProjectGroupCardStyle();

        expect(style.labelStyle, isNotNull);
      },
    );

    test(
      "creates an instance with the given values",
      () {
        const backgroundColor = Colors.red;
        const labelStyle = TextStyle(color: Colors.red);
        const iconColor = Colors.red;
        const hoverColor = Colors.red;

        const style = AddProjectGroupCardStyle(
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          hoverColor: hoverColor,
          labelStyle: labelStyle,
        );

        expect(style.backgroundColor, equals(backgroundColor));
        expect(style.labelStyle, equals(labelStyle));
        expect(style.iconColor, equals(iconColor));
        expect(style.hoverColor, equals(hoverColor));
      },
    );
  });
}
