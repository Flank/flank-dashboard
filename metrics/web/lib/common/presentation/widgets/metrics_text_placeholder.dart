import 'package:flutter/material.dart';

/// The widget that represents metrics text placeholder.
class MetricsTextPlaceholder extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  /// Creates a placeholder widget with the given [text].
  /// 
  /// The [text] is a string, that widget displays.
  /// The text has the [size] with a default value of 20.0 and the [color] with
  /// a default value of [Colors.grey].
  /// 
  /// The [text] argument should not be null.
  const MetricsTextPlaceholder({
    Key key,
    @required this.text,
    this.size = 20.0,
    this.color = Colors.grey,
  }) : super(key: key);

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
