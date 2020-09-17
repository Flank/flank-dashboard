import 'package:flutter/material.dart';

/// A widget that displays a metrics styled checkbox.
class MetricsCheckbox extends StatelessWidget {
  /// Indicates whether this checkbox is checked.
  final bool value;

  /// The callback that is called when the checkbox has tapped.
  final ValueChanged<bool> onChanged;

  /// Creates a new metrics checkbox instance.
  ///
  /// The [value] must not be null.
  const MetricsCheckbox({
    Key key,
    @required this.value,
    @required this.onChanged,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = value ? CrossFadeState.showFirst : CrossFadeState.showSecond;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onTap: () => onChanged(!value),
      child: AnimatedCrossFade(
        crossFadeState: state,
        duration: const Duration(milliseconds: 100),
        firstChild: Image.network(
          'icons/check-box.svg',
          width: 20.0,
          height: 20.0,
          fit: BoxFit.contain,
        ),
        secondChild: Image.network(
          'icons/check-box-blank.svg',
          width: 20.0,
          height: 20.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
