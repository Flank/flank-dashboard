// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Displays the loading placeholder.
class LoadingPlaceholder extends StatelessWidget {
  /// Creates a [LoadingPlaceholder].
  const LoadingPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
