import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that used to toggle the on/off state of a single setting.
class MetricsSwitch extends StatefulWidget {
  /// Indicates whether this switch is on or off.
  final bool value;

  /// A callback that is called when the user toggles this switch.
  final ValueChanged<bool> onToggle;

  /// Creates a new instance of the [MetricsSwitch].
  ///
  /// The [value] must not be null.
  const MetricsSwitch({
    Key key,
    @required this.value,
    this.onToggle,
  })  : assert(value != null),
        super(key: key);

  @override
  _MetricsSwitchState createState() => _MetricsSwitchState();
}

class _MetricsSwitchState extends State<MetricsSwitch> {
  /// Indicates whether this switch is hovered.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final toggleTheme = MetricsTheme.of(context).toggleTheme;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: FlutterSwitch(
        width: 35.0,
        height: 20.0,
        toggleSize: 15.0,
        padding: 2.0,
        onToggle: widget.onToggle,
        value: widget.value,
        inactiveColor: _isHovered
            ? toggleTheme.inactiveHoverColor
            : toggleTheme.inactiveColor,
        activeColor:
            _isHovered ? toggleTheme.activeHoverColor : toggleTheme.activeColor,
      ),
    );
  }

  /// Changes the [_isHovered] state to the given [isHovered] value.
  void _setHovered(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }
}
