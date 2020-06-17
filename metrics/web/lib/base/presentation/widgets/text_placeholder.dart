import 'package:flutter/material.dart';

/// The widget that represents text placeholder.
class TextPlaceholder extends StatelessWidget {
  /// A text that the widget displays.
  final String text;

  /// A size of the given [text].
  ///
  /// Has a default value of [20.0].
  final double size;

  /// A color of the given [text].
  ///
  /// Has a default value if [Colors.grey].
  final Color color;

  /// Creates a placeholder widget with the given [text].
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
