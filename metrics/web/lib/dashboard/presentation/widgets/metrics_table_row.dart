// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A widget that represents the metrics table row.
class MetricsTableRow extends StatelessWidget {
  /// A [Widget] that displays a project status.
  final Widget status;

  /// A [Widget] that displays a project name.
  final Widget name;

  /// A [Widget] that displays an information about build results.
  final Widget buildResults;

  /// A [Widget] that displays an information about a performance metric.
  final Widget performance;

  /// A [Widget] that displays an information about a builds count.
  final Widget buildNumber;

  /// A [Widget] that displays an information about a stability metric.
  final Widget stability;

  /// A [Widget] that displays an information about a coverage metric.
  final Widget coverage;

  /// Creates the [MetricsTableRow].
  ///
  /// The [status], [name], [buildResults], [performance],
  /// [buildNumber], [stability], and [coverage] must not be null.
  const MetricsTableRow({
    Key key,
    @required this.status,
    @required this.name,
    @required this.buildResults,
    @required this.performance,
    @required this.buildNumber,
    @required this.stability,
    @required this.coverage,
  })  : assert(status != null),
        assert(name != null),
        assert(buildResults != null),
        assert(performance != null),
        assert(buildNumber != null),
        assert(stability != null),
        assert(coverage != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(right: 28.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: <Widget>[
          status,
          Expanded(
            child: SizedBox(
              width: 250.0,
              child: name,
            ),
          ),
          SizedBox(
            width: 743.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: padding,
                  child: SizedBox(
                    width: 268.0,
                    child: buildResults,
                  ),
                ),
                Padding(
                  padding: padding,
                  child: SizedBox(
                    width: 144.0,
                    child: performance,
                  ),
                ),
                Padding(
                  padding: padding,
                  child: SizedBox(
                    width: 74.0,
                    child: buildNumber,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 74.0,
                    child: stability,
                  ),
                ),
                SizedBox(
                  width: 83.0,
                  child: coverage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
