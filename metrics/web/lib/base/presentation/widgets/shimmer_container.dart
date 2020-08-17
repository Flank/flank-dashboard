import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

/// A widget that displays a [Container] with a shimmer effect.
class ShimmerContainer extends StatelessWidget {
  /// A width of this container.
  final double width;

  /// A height of this container.
  final double height;

  /// A [Decoration] of this container.
  final Decoration decoration;

  /// A [Color] of the shimmer animation.
  final Color shimmerColor;

  /// A [Color] of this container.
  final Color color;

  /// A [Widget] below this container in the widget tree.
  final Widget child;

  /// Indicates whether the shimmer animation is enabled or disabled.
  final bool enabled;

  /// A [ShimmerDirection] of the shimmer animation.
  final ShimmerDirection direction;

  /// A [Duration] of the shimmer animation.
  final Duration duration;

  /// An empty space surrounds this container.
  final EdgeInsetsGeometry padding;

  /// A [BorderRadius] of this container.
  final BorderRadius borderRadius;

  /// Creates a new instance of the [ShimmerContainer].
  ///
  /// The [enabled] defaults to `true`.
  /// The [direction] defaults to [ShimmerDirection.fromLTRB].
  /// The [duration] defaults to `const Duration(seconds: 3)`.
  /// The [padding] defaults to [EdgeInsets.zero].
  /// The [borderRadius] defaults to [BorderRadius.zero].
  ///
  /// The [padding], [duration], [direction], [borderRadius],
  /// and [enabled] must not be null.
  const ShimmerContainer({
    Key key,
    this.width,
    this.height,
    this.decoration,
    this.shimmerColor,
    this.color,
    this.child,
    this.enabled = true,
    this.direction = const ShimmerDirection.fromLTRB(),
    this.duration = const Duration(seconds: 3),
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  })  : assert(padding != null),
        assert(duration != null),
        assert(direction != null),
        assert(borderRadius != null),
        assert(enabled != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Shimmer(
          color: shimmerColor,
          enabled: enabled,
          duration: duration,
          direction: direction,
          child: Container(
            width: width,
            height: height,
            color: color,
            decoration: decoration,
            child: child,
          ),
        ),
      ),
    );
  }
}
