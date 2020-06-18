import 'package:flutter/material.dart';

/// The widget that displays text placeholder.
class TextPlaceholder extends StatelessWidget {
  /// A text to display.
  final String text;

  /// A size of the given [text].
  final double size;

  /// A color of the given [text].
  final Color color;

  /// Creates a [TextPlaceholder] with the given [text].
  ///
  /// The [size] default value is 20.0.
  /// The [color] default value is [Colors.grey].
  ///
  /// The [text] argument must not be null.
  const TextPlaceholder({
    Key key,
    @required this.text,
    this.size = 20.0,
    this.color = Colors.grey,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: color,
        ),
      ),
    );
  }
}
