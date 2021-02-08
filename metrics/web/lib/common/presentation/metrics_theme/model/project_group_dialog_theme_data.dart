// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dialog_theme_data.dart';

/// A class that stores the theme data for the project group dialogues.
class ProjectGroupDialogThemeData extends DialogThemeData {
  /// A border [Color] of the project group dialog content.
  final Color contentBorderColor;

  /// A [TextStyle] of the unchecked project within the project group dialog.
  final TextStyle uncheckedProjectTextStyle;

  /// A [TextStyle] of the checked project within the project group dialog.
  final TextStyle checkedProjectTextStyle;

  /// A [TextStyle] of the counter text of selected projects within
  /// the project group dialog.
  final TextStyle counterTextStyle;

  /// Creates a new instance of the [ProjectGroupDialogThemeData].
  ///
  /// The [contentBorderColor] default value is [Colors.grey].
  const ProjectGroupDialogThemeData({
    Color primaryColor,
    Color backgroundColor,
    Color barrierColor,
    Color closeIconColor,
    TextStyle titleTextStyle,
    TextStyle errorTextStyle,
    this.contentBorderColor = Colors.grey,
    this.uncheckedProjectTextStyle,
    this.checkedProjectTextStyle,
    this.counterTextStyle,
  }) : super(
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
          barrierColor: barrierColor,
          closeIconColor: closeIconColor,
          titleTextStyle: titleTextStyle,
          errorTextStyle: errorTextStyle,
        );
}
