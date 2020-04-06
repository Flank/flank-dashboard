import 'package:flutter/material.dart';

/// Centers the given [text] on a page.
class PagePlaceholder extends StatelessWidget {
  final String text;

  /// Creates the [PagePlaceholder].
  ///
  /// [text] is the text, that aligned in the center on a page.
  const PagePlaceholder({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
