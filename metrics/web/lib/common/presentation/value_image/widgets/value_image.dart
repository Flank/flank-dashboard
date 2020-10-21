import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/value_image/strategy/value_based_image_strategy.dart';

class ValueImage<T> extends StatelessWidget {
  final double width;
  final double height;
  final T value;

  final ValueBasedImageStrategy<T> strategy;

  const ValueImage({
    Key key,
    this.value,
    this.strategy,
    this.width,
    this.height,
  }) : super(key: key);

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
