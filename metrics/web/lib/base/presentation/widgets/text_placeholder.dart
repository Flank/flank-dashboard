import 'package:flutter/material.dart';

/// The widget that displays text placeholder.
class TextPlaceholder extends StatelessWidget {
  /// A text to display.
  final String text;

  /// A [TextStyle] of the given [text].
  final TextStyle style;

  /// Creates a [TextPlaceholder] with the given [text].
  ///
  /// The [text] argument must not be null.
  const TextPlaceholder({
    Key key,
    @required this.text,
    this.style,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}
