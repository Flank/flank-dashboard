import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/value_image/strategy/value_based_image_strategy.dart';

/// A widget that applies a [strategy] and displays the image based on [value].
class ValueImage<T> extends StatelessWidget {
  /// A width of this image.
  final double width;

  /// A height of this image.
  final double height;

  /// A value used by [strategy].
  final T value;

  /// An image appearance strategy to apply to this widget.
  final ValueBasedImageStrategy<T> strategy;

  /// Creates a new instance of the [ValueImage].
  const ValueImage({
    Key key,
    @required this.strategy,
    this.value,
    this.width,
    this.height,
  })  : assert(strategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconImage = strategy.getIconImage(value);

    return Image.network(
      iconImage,
      height: height,
      width: width,
    );
  }
}
