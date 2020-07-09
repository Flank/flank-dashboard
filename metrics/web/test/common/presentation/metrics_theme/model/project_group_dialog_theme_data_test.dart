import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectGroupDialogThemeData", () {
    test(
      "creates an instance with the default colors and paddings if the parameters are not specified",
      () {
        const themeData = ProjectGroupDialogThemeData();

        expect(themeData.accentColor, isNotNull);
        expect(themeData.primaryColor, isNotNull);
        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.contentBorderColor, isNotNull);
        expect(themeData.padding, isNotNull);
        expect(themeData.contentPadding, isNotNull);
        expect(themeData.titlePadding, isNotNull);
        expect(themeData.actionsPadding, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles and text field decoration if the parameters are not specified",
      () {
        const themeData = ProjectGroupDialogThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.actionsTextStyle, isNull);
        expect(themeData.contentSecondaryTextStyle, isNull);
        expect(themeData.contentTextStyle, isNull);
        expect(themeData.textFieldTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const defaultPadding = EdgeInsets.zero;
      const defaultTextStyle = TextStyle();

      const primaryColor = Colors.blue;
      const accentColor = Colors.red;
      const backgroundColor = Colors.white;
      const contentBorderColor = Colors.grey;
      const padding = defaultPadding;
      const contentPadding = defaultPadding;
      const titlePadding = defaultPadding;
      const actionsPadding = defaultPadding;
      const titleTextStyle = defaultTextStyle;
      const actionsTextStyle = defaultTextStyle;
      const contentSecondaryTextStyle = defaultTextStyle;
      const contentTextStyle = defaultTextStyle;
      const textFieldTextStyle = defaultTextStyle;

      final themeData = ProjectGroupDialogThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        contentBorderColor: contentBorderColor,
        padding: padding,
        contentPadding: contentPadding,
        titlePadding: titlePadding,
        actionsPadding: actionsPadding,
        titleTextStyle: titleTextStyle,
        actionsTextStyle: actionsTextStyle,
        contentSecondaryTextStyle: contentSecondaryTextStyle,
        contentTextStyle: contentTextStyle,
        textFieldTextStyle: textFieldTextStyle,
      );

      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.accentColor, equals(accentColor));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.contentBorderColor, equals(contentBorderColor));
      expect(themeData.padding, equals(padding));
      expect(themeData.contentPadding, equals(contentPadding));
      expect(themeData.titlePadding, equals(titlePadding));
      expect(themeData.actionsPadding, equals(actionsPadding));
      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.actionsTextStyle, equals(actionsTextStyle));
      expect(
        themeData.contentSecondaryTextStyle,
        equals(contentSecondaryTextStyle),
      );
      expect(themeData.contentTextStyle, equals(contentTextStyle));
      expect(themeData.textFieldTextStyle, equals(textFieldTextStyle));
    });
  });
}
