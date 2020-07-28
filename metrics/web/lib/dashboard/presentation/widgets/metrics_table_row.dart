import 'package:flutter/material.dart';

/// A widget that represents the metrics table row.
class MetricsTableRow extends StatelessWidget {
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
  /// The [name], [buildResults], [performance],
  /// [buildNumber], [stability], and [coverage] must not be null.
  const MetricsTableRow({
    Key key,
    @required this.name,
    @required this.buildResults,
    @required this.performance,
    @required this.buildNumber,
    @required this.stability,
    @required this.coverage,
  })  : assert(name != null),
        assert(buildResults != null),
        assert(performance != null),
        assert(buildNumber != null),
        assert(stability != null),
        assert(coverage != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 326.0,
              child: name,
            ),
          ),
          Container(
            width: 750.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 276.0,
                  child: buildResults,
                ),
                Container(
                  width: 144.0,
                  child: performance,
                ),
                Container(
                  width: 74.0,
                  child: buildNumber,
                ),
                Container(
                  width: 72.0,
                  child: stability,
                ),
                Container(
                  width: 72.0,
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
