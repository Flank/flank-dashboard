// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';

/// A card that displays the given child with padding
/// and applies the given decoration.
class MetricsCard extends StatelessWidget {
  /// This card's decoration.
  final BoxDecoration decoration;

  /// A widget to display.
  final Widget child;

  /// Creates a new [MetricsCard] instance.
  ///
  /// The [child] parameter must not be null.
  ///
  /// [decoration] value defaults to an empty `BoxDecoration`.
  const MetricsCard({
    Key key,
    @required this.child,
    this.decoration = const BoxDecoration(),
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      width: 270.0,
      height: 156.0,
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}
