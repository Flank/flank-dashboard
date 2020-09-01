import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that used to toggle the on/off state of a single setting.
class Toggle extends StatefulWidget {
  /// Indicates whether this toggle is enabled or not.
  final bool value;

  /// A [ValueChanged] callback used to notify about [value] changed.
  final ValueChanged<bool> onToggle;

  /// Creates a new instance of the [Toggle].
  ///
  /// The [value] must not be null.
  const Toggle({
    Key key,
    @required this.value,
    this.onToggle,
  })  : assert(value != null),
        super(key: key);

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  /// Indicates whether this toggle is hovered.
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final toggleTheme = MetricsTheme.of(context).toggleTheme;
    final inactiveColor =
        _isHovered ? toggleTheme.inactiveHoverColor : toggleTheme.inactiveColor;
    final activeColor =
        _isHovered ? toggleTheme.activeHoverColor : toggleTheme.activeColor;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: FlutterSwitch(
        width: 35.0,
        height: 20.0,
        toggleSize: 16.0,
        padding: 2.0,
        onToggle: widget.onToggle,
        value: widget.value,
        inactiveColor: inactiveColor,
        activeColor: activeColor,
      ),
    );
  }

  /// Changes the [_isHovered] state to the given [isHovered] value.
  void _setHovered(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }
}
