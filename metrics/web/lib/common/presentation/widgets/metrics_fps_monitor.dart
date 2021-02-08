// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:provider/provider.dart';
import 'package:statsfl/statsfl.dart';

/// A widget that displays the FPS counter.
///
/// The FPS counter appears above the given [child] on alt(option) + f shortcut.
class MetricsFPSMonitor extends StatefulWidget {
  /// A [Widget] below the [MetricsFPSMonitor] in the tree.
  final Widget child;

  /// Creates the [MetricsFPSMonitor] with the given [child].
  ///
  /// The [child] must not be `null`.
  const MetricsFPSMonitor({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _MetricsFPSMonitorState createState() => _MetricsFPSMonitorState();
}

class _MetricsFPSMonitorState extends State<MetricsFPSMonitor> {
  @override
  Widget build(BuildContext context) {
    return Selector<DebugMenuNotifier, bool>(
      selector: (_, notifier) {
        return notifier.fpsMonitorViewModel?.isEnabled ?? false;
      },
      builder: (_, isEnabled, __) {
        return StatsFl(
          maxFps: 90,
          isEnabled: isEnabled,
          child: widget.child,
        );
      },
    );
  }
}
