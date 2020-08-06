import 'package:flutter/material.dart';

/// A class that stores theme data for the scorecard widget.
class ScorecardThemeData {
  /// A [TextStyle] of the scorecard's description.
  final TextStyle descriptionTextStyle;

  /// A [TextStyle] of the scorecard's value.
  final TextStyle valueTextStyle;

  /// Creates the [ScorecardThemeData].
  const ScorecardThemeData({
    this.descriptionTextStyle,
    this.valueTextStyle
  });
}
