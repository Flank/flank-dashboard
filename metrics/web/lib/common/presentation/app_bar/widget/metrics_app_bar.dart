import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// A common for the metrics application [AppBar] widget.
class MetricsAppBar extends AppBar {
  /// Creates a [MetricsAppBar].
  MetricsAppBar({
    Key key,
  }) : super(
          key: key,
          title: const Text(CommonStrings.metrics),
          centerTitle: false,
          elevation: 0.0,
        );
}
