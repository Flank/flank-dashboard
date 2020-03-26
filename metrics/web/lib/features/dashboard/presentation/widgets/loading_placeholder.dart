import 'package:flutter/material.dart';

/// Displays the loading placeholder.
class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
