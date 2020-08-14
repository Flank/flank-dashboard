import 'package:flutter/material.dart';

/// A class that stores the theme data
/// for the metrics placeholders with shimmer effect.
class ShimmerPlaceholderThemeData {
  /// A background [Color] of the placeholder.
  final Color backgroundColor;

  /// A [Color] of the shimmer animation.
  final Color shimmerColor;

  /// Creates an instance of the [ShimmerPlaceholderThemeData].
  const ShimmerPlaceholderThemeData({
    this.backgroundColor,
    this.shimmerColor,
  });
}
