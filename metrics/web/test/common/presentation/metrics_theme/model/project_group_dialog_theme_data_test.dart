import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/project_group_dialog_theme_data.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors

void main() {
  group("ProjectGroupDialogThemeData", () {
    test(
      "creates an instance with the default colors if the parameters are not specified",
      () {
        const themeData = ProjectGroupDialogThemeData();

        expect(themeData.primaryColor, isNotNull);
        expect(themeData.accentColor, isNotNull);
        expect(themeData.backgroundColor, isNotNull);
        expect(themeData.closeIconColor, isNotNull);
        expect(themeData.contentBorderColor, isNotNull);
      },
    );

    test(
      "creates an instance with null text styles if the parameters are not specified",
      () {
        const themeData = ProjectGroupDialogThemeData();

        expect(themeData.titleTextStyle, isNull);
        expect(themeData.groupNameTextStyle, isNull);
        expect(themeData.searchForProjectTextStyle, isNull);
        expect(themeData.uncheckedProjectTextStyle, isNull);
        expect(themeData.checkedProjectTextStyle, isNull);
        expect(themeData.counterTextStyle, isNull);
        expect(themeData.actionsTextStyle, isNull);
      },
    );

    test("creates an instance with the given values", () {
      const defaultTextStyle = TextStyle();

      const primaryColor = Colors.blue;
      const accentColor = Colors.red;
      const backgroundColor = Colors.white;
      const closeIconColor = Colors.black;
      const contentBorderColor = Colors.grey;

      const titleTextStyle = defaultTextStyle;
      const groupNameTextStyle = defaultTextStyle;
      const searchForProjectTextStyle = defaultTextStyle;
      const uncheckedProjectTextStyle = defaultTextStyle;
      const checkedProjectTextStyle = defaultTextStyle;
      const counterTextStyle = defaultTextStyle;
      const actionsTextStyle = defaultTextStyle;

      final themeData = ProjectGroupDialogThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        closeIconColor: closeIconColor,
        contentBorderColor: contentBorderColor,
        titleTextStyle: titleTextStyle,
        groupNameTextStyle: groupNameTextStyle,
        searchForProjectTextStyle: searchForProjectTextStyle,
        uncheckedProjectTextStyle: uncheckedProjectTextStyle,
        checkedProjectTextStyle: checkedProjectTextStyle,
        counterTextStyle: counterTextStyle,
        actionsTextStyle: actionsTextStyle,
      );

      expect(themeData.primaryColor, equals(primaryColor));
      expect(themeData.accentColor, equals(accentColor));
      expect(themeData.backgroundColor, equals(backgroundColor));
      expect(themeData.closeIconColor, equals(closeIconColor));
      expect(themeData.contentBorderColor, equals(contentBorderColor));
      expect(themeData.titleTextStyle, equals(titleTextStyle));
      expect(themeData.groupNameTextStyle, equals(groupNameTextStyle));
      expect(
        themeData.searchForProjectTextStyle,
        equals(searchForProjectTextStyle),
      );
      expect(
        themeData.uncheckedProjectTextStyle,
        equals(uncheckedProjectTextStyle),
      );
      expect(
        themeData.checkedProjectTextStyle,
        equals(checkedProjectTextStyle),
      );
      expect(themeData.counterTextStyle, equals(counterTextStyle));
      expect(themeData.actionsTextStyle, equals(actionsTextStyle));
    });
  });
}
