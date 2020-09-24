import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:statsfl/statsfl.dart';

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
  /// that toggles an enable status of the [StatsFl].
  final _keysToPress = LogicalKeySet(
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.keyF,
  );

  /// Indicates whether the [StatsFl] is enabled or not.
  bool _isEnabled = false;

  /// Provides an enable status of the [StatsFl].
  ///
  /// This feature should work only in the release mode.
  bool get isEnabled => kReleaseMode && _isEnabled;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        _keysToPress: const ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction(
            onInvoke: (_) {
              setState(() => _isEnabled = !_isEnabled);
              return null;
            },
          ),
        },
        child: StatsFl(
          isEnabled: isEnabled,
          child: widget.child,
        ),
      ),
    );
  }
}
