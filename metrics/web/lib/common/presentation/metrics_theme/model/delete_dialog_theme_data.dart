// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dialog_theme_data.dart';

/// A class that stores the theme data for the delete dialogues.
class DeleteDialogThemeData extends DialogThemeData {
  /// A [TextStyle] of the content text for the delete dialog.
  final TextStyle contentTextStyle;

  /// Creates a new instance of the [DeleteDialogThemeData].
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
