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
      padding: const EdgeInsets.only(left: 32.0, right: 26.0),
      child: Row(
        children: <Widget>[
          status,
          Flexible(
            child: SizedBox(
              width: 304.0,
              child: name,
            ),
          ),
          SizedBox(
            width: 778.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: padding,
                  child: SizedBox(
                    width: 298.0,
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
                  padding: const EdgeInsets.only(right: 27.0),
                  child: SizedBox(
                    width: 74.0,
                    child: buildNumber,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 22.0),
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
