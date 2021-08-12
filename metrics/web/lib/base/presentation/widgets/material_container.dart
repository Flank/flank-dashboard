// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A widget that represents the material container.
class MaterialContainer extends StatelessWidget {
  /// A [Widget] below this in the widget tree.
  final Widget child;

  /// An amount of space by which to inset the [child].
  final EdgeInsets padding;

  /// A [MaterialType] of this container.
  final MaterialType type;

  /// A z-coordinate at which to place this container related to its parents.
  final double elevation;

  /// A background [Color] of this container.
  final Color backgroundColor;

  /// A [Color] of this container's shadow.
  final Color shadowColor;

  /// A [BorderRadiusGeometry] of this container.
  final BorderRadiusGeometry borderRadius;

  /// Creates a new instance of the [MaterialContainer] with the given
  /// parameters.
  ///
  /// The [padding] defaults to [EdgeInsets.zero].
  /// The [type] defaults to [MaterialType.canvas].
  /// The [elevation] defaults to `0.0`.
  ///
  /// The [padding] and [type] must not be null.
  /// The [elevation] must be non-negative double value.
  const MaterialContainer({
    Key key,
    this.padding = EdgeInsets.zero,
    this.type = MaterialType.canvas,
    this.elevation = 0.0,
    this.backgroundColor,
    this.shadowColor,
    this.borderRadius,
    this.child,
  })  : assert(padding != null),
        assert(type != null),
        assert(elevation != null),
        assert(elevation >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      type: type,
      color: backgroundColor,
      shadowColor: shadowColor,
      borderRadius: borderRadius,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
