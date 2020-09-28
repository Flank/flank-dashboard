import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metrics/base/presentation/widgets/keyboard_shortcuts.dart';
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
  /// A combination of the keyboard keys to toggle the enabled status of the [StatsFl].
  final _keysToPress = LogicalKeySet(
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.keyF,
  );

  /// Indicates whether the [StatsFl] is enabled or not.
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      keysToPress: _keysToPress,
      onKeysPressed: () => setState(() => _isEnabled = !_isEnabled),
      child: StatsFl(
        maxFps: 90,
        isEnabled: _isEnabled,
        child: widget.child,
      ),
    );
  }
}
