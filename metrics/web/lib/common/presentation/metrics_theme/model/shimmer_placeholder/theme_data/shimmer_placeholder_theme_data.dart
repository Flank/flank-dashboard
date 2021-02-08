// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A class that stores the theme data
/// for the placeholders with a shimmer effect.
class ShimmerPlaceholderThemeData {
  /// A background [Color] of the placeholder.
  final Color backgroundColor;

  /// A [Color] of the shimmer animation.
  final Color shimmerColor;

  /// Creates an instance of the [ShimmerPlaceholderThemeData].
  const ShimmerPlaceholderThemeData({
    Color backgroundColor,
    Color shimmerColor,
  })  : backgroundColor = backgroundColor ?? Colors.grey,
        shimmerColor = shimmerColor ?? Colors.blueGrey;
}
