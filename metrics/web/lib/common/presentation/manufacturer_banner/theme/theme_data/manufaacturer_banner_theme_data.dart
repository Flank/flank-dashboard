import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/manufacturer_banner/widget/manufacturer_banner.dart';

/// A class that represents the theme data for the [ManufacturerBanner] widget.
class ManufacturerBannerThemeData {
  /// A [Color] of the background of the [ManufacturerBanner] widget.
  final Color backgroundColor;

  /// A [TextStyle] of the text in the [ManufacturerBanner] widget.
  final TextStyle textStyle;

  /// Creates a new instance of the [ManufacturerBannerThemeData] with the given
  /// parameters.
  const ManufacturerBannerThemeData({
    this.backgroundColor,
    this.textStyle,
  });
}
