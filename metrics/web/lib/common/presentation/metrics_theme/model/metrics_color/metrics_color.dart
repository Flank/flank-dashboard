// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that represents a color with a variety of shades for this color.
class MetricsColor extends MaterialColor {
  /// A [Map] that holds a variety of shades of this color.
  final Map<int, Color> _swatch;

  /// Creates an instance of the [MetricsColor] with the given [primary] color
  /// and a color swatch.
  const MetricsColor(
    int primary,
    this._swatch,
  ) : super(primary, _swatch);

  @override
  Color operator [](int index) {
    final color = _swatch[index];
    assert(color != null);

    return color;
  }
}
