// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that represents theme data for the manufacturer banner widget.
class ManufacturerBannerThemeData {
  /// A background [Color] of the manufacturer banner widget.
  final Color backgroundColor;

  /// A [TextStyle] of the text in the manufacturer banner widget.
  final TextStyle textStyle;

  /// Creates a new instance of the [ManufacturerBannerThemeData] with the given
  /// parameters.
  const ManufacturerBannerThemeData({
    this.backgroundColor,
    this.textStyle,
  });
}
