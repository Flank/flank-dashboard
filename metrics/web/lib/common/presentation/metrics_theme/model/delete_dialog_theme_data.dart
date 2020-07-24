import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dialog_theme_data.dart';

/// A class that stores the theme data for the delete dialogues.
class DeleteDialogThemeData extends DialogThemeData {
  /// A [TextStyle] of the content text for the delete dialog.
  final TextStyle contentTextStyle;

  const DeleteDialogThemeData({
    Color backgroundColor,
    Color closeIconColor,
    TextStyle titleTextStyle,
    this.contentTextStyle,
  }) : super(
          backgroundColor: backgroundColor,
          closeIconColor: closeIconColor,
          titleTextStyle: titleTextStyle,
        );
}
