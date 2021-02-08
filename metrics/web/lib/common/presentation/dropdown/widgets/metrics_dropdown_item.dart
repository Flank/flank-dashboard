// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A widget that displays a metrics styled item within a dropdown.
class MetricsDropdownItem extends StatelessWidget {
  /// A text title to display.
  final String title;

  /// Creates the [MetricsDropdownItem] with the given [title].
  ///
  /// The [title] must not be null.
  const MetricsDropdownItem({
    Key key,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).dropdownItemTheme;

    return DropdownItem(
      height: 40.0,
      width: 210.0,
      alignment: Alignment.centerLeft,
      backgroundColor: theme.backgroundColor,
      hoverColor: theme.hoverColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      builder: (context, isHovered) {
        return isHovered
            ? Text(title, style: theme.hoverTextStyle)
            : Text(title, style: theme.textStyle);
      },
    );
  }
}
