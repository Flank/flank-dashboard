import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';

/// A specific for the metrics application [AppBar] widget.
class MetricsAppBar extends AppBar {
  MetricsAppBar({
    Key key,
  }) : super(
          key: key,
          title: const Text(CommonStrings.metrics),
          centerTitle: false,
          elevation: 0.0,
        );
}
