import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A class that represents a color used in application.
class MetricsColor extends MaterialColor {
  /// A [Map] that holds shades of this color.
  ///
  /// A key of this [Map] stands for a shade, and a value holds a corresponding
  /// [Color].
  final Map<int, Color> _swatch;

  /// Provides a color swatch of this color.
  ///
  /// Throws an [UnsupportedError] if modifying operations are performed on this
  /// map.
  Map<int, Color> get swatch => UnmodifiableMapView(_swatch);

  /// Creates an instance of the [MetricsColor] with the given [primary] color
  /// and swatch.
  ///
  /// If this instance is used as a [Color], the [primary] value is passed to
  /// a [Color] constructor.
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
