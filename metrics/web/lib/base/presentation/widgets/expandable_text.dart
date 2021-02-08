// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// The widget that expands [text] to fill all available space if
/// wrapped by [Flexible] widgets.
class ExpandableText extends StatelessWidget {
  /// A [String] to display.
  final String text;

  /// A [TextStyle] used to display the [text].
  final TextStyle style;

  /// Creates the [ExpandableText] with the given [text] and [style].
  const ExpandableText(
    this.text, {
    Key key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
