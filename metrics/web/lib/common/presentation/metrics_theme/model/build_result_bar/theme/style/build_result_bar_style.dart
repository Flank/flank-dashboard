import 'package:flutter/material.dart';

/// A class that stores style data for build result bars.
@immutable
class BuildResultBarStyle {
  /// A [Color] of the bar.
  final Color color;

  /// A background [Color] of the bar.
  final Color backgroundColor;

  /// Creates a new instance of the [BuildResultBarStyle].
  const BuildResultBarStyle({
    this.color,
    this.backgroundColor,
  });
}
