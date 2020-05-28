import 'package:flutter/material.dart';

/// The widget that represents metrics text placeholder.
class MetricsTextPlaceholder extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  /// Creates a placeholder widget with the given [text].
  const MetricsTextPlaceholder({
    Key key,
    this.text,
    this.size = 20.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: size, color: color),
      ),
    );
  }
}
