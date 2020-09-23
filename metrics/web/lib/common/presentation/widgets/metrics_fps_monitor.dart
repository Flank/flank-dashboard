import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:metrics/base/presentation/widgets/fps_monitor.dart';

/// A class that displays the metrics performance.
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
  /// Combination of keyboard keys to press 
  /// that toggles an enable status of the [FPSMonitor].
  final _keysToPress = {
    LogicalKeyboardKey.keyF,
    LogicalKeyboardKey.keyP,
    LogicalKeyboardKey.keyS,
  };

  /// Indicates whether the [FPSMonitor] is enabled or not.
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: KeyBoardShortcuts(
        keysToPress: _keysToPress,
        onKeysPressed: () {
          setState(() => _isEnabled = !_isEnabled);
        },
        child: FPSMonitor(
          isEnabled: _isEnabled,
          child: widget.child,
        ),
      ),
    );
  }
}
