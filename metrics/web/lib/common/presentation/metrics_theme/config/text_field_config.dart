// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/config/metrics_colors.dart';

/// A class that holds the common text field styles for application themes.
class TextFieldConfig {
  /// A [TextStyle] of the text field error messages.
  static final TextStyle errorStyle = TextStyle(
    color: MetricsColors.orange[500],
    fontSize: 16.0,
    height: 1.0,
  );

  /// A default [OutlineInputBorder] of the text field.
  static const border = OutlineInputBorder(
    borderSide: BorderSide.none,
  );

  /// An [OutlineInputBorder] to display when
  /// the text filed is showing an error.
  static final errorBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MetricsColors.orange[500],
    ),
  );
}
