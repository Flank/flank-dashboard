import 'package:flutter/material.dart';

class PagePlaceholder extends StatelessWidget {
  final String text;

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
