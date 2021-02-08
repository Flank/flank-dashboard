// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A [Container] widget that does not insets its child
/// by the widths of the borders.
class DecoratedContainer extends StatelessWidget {
  /// A [Decoration] of this container.
  final Decoration decoration;

  /// A widget below this container in the tree.
  final Widget child;

  /// A height of this container.
  final double height;

  /// A width of this container.
  final double width;

  /// An empty space surrounds the [child].
  final EdgeInsetsGeometry padding;

  /// An empty space to around the [decoration] and [child].
  final EdgeInsetsGeometry margin;

  /// A [BoxConstraints] of this container.
  final BoxConstraints constraints;

  /// Creates a new instance of the [DecoratedContainer].
  ///
  /// The [decoration] must not be null.
  const DecoratedContainer({
    Key key,
    @required this.decoration,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.constraints,
  })  : assert(decoration != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      constraints: constraints,
      child: DecoratedBox(
        decoration: decoration,
        child: child,
      ),
    );
  }
}
