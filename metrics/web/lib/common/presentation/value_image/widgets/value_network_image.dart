// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/asset/strategy/value_based_asset_strategy.dart';

/// A widget that displays an image from the [strategy] depending on
/// the given [value].
class ValueNetworkImage<T> extends StatelessWidget {
  /// A width of this image.
  final double width;

  /// A height of this image.
  final double height;

  /// A value the [strategy] uses to select an image asset to display.
  final T value;

  /// An asset strategy to apply to this widget.
  final ValueBasedAssetStrategy<T> strategy;

  /// Creates a new instance of the [ValueNetworkImage].
  const ValueNetworkImage({
    Key key,
    @required this.strategy,
    this.value,
    this.width,
    this.height,
  })  : assert(strategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconImage = strategy.getAsset(value);

    return SvgImage(
      iconImage,
      height: height,
      width: width,
    );
  }
}
