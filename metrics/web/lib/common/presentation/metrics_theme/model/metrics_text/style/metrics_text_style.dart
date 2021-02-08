// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

/// A metrics [TextStyle], that calculates the [TextStyle.height] using
/// the [lineHeightInPixels].
class MetricsTextStyle extends TextStyle {
  /// A height of the text in pixels.
  final double lineHeightInPixels;

  /// Creates a new instance of the [MetricsTextStyle].
  ///
  /// If the [fontSize] and [lineHeightInPixels] are not null,
  /// then the [TextStyle.height] equal to the [lineHeightInPixels]
  /// divided by the [fontSize].
  /// Otherwise, the [TextStyle.height] equal to the given [height].
  ///
  /// The [inherit] defaults to `true`.
  const MetricsTextStyle({
    this.lineHeightInPixels,
    bool inherit = true,
    Color color,
    Color backgroundColor,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    double letterSpacing,
    double wordSpacing,
    TextBaseline textBaseline,
    double height,
    Locale locale,
    Paint foreground,
    Paint background,
    List<Shadow> shadows,
    List<FontFeature> fontFeatures,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
    String debugLabel,
    String fontFamily,
    List<String> fontFamilyFallback,
    String package,
  })  : assert(
            fontSize == null || lineHeightInPixels == null || height == null),
        super(
          inherit: inherit,
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: lineHeightInPixels != null && fontSize != null
              ? lineHeightInPixels / fontSize
              : height,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          fontFeatures: fontFeatures,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          debugLabel: debugLabel,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          package: package,
        );
}
