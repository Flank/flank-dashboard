import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart';

/// A class that displays a performance statistics of the app.
class FPSMonitor extends StatelessWidget {
  /// A [Widget] below the [FPSMonitor] in the tree.
  final Widget child;

  /// Indicates whether this widget is enabled or not.
  final bool isEnabled;

  /// A width of this widget.
  final double width;

  /// A height of this widget.
  final double height;

  /// Creates the [FPSMonitor] with the given [isEnabled] and [child].
  ///
  /// The [isEnabled] defaults to `false`.
  /// The [width] defaults to `120.0`.
  /// The [height] defaults to `40.0`.
  ///
  /// The [child], [width] and [height] must not be `null`.
  const FPSMonitor({
    Key key,
    @required this.child,
    this.isEnabled = false,
    this.width = 120.0,
    this.height = 40.0,
  })  : assert(child != null),
        assert(width != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Container(
          width: width,
          height: height,
          child: StatsFl(
            isEnabled: isEnabled,
            child: Container(),
          ),
        ),
      ],
    );
  }
}
