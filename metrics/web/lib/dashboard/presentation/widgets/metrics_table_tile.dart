import 'package:flutter/material.dart';

/// A widget that represents the dashboard table tile.
class MetricsTableTile extends StatelessWidget {
  /// A first column of this widget.
  final Widget leading;

  /// A column that displays an information about build results.
  final Widget buildResultsColumn;

  /// A column that displays an information about a performance metric.
  final Widget performanceColumn;

  /// A column that displays an information about a builds count.
  final Widget buildNumberColumn;

  /// A column that displays an information about a stability metric.
  final Widget stabilityColumn;

  /// A column that displays an information about a coverage metric.
  final Widget coverageColumn;

  /// Creates the [MetricsTableTile].
  ///
  /// Throws an [AssertionError] if at least one of the required parameters is null.
  const MetricsTableTile({
    Key key,
    @required this.leading,
    @required this.buildResultsColumn,
    @required this.performanceColumn,
    @required this.buildNumberColumn,
    @required this.stabilityColumn,
    @required this.coverageColumn,
  })  : assert(leading != null),
        assert(buildResultsColumn != null),
        assert(performanceColumn != null),
        assert(buildNumberColumn != null),
        assert(stabilityColumn != null),
        assert(coverageColumn != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 326.0,
              child: leading,
            ),
          ),
          Container(
            width: 750.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 276.0,
                  child: buildResultsColumn,
                ),
                Container(
                  width: 144.0,
                  child: performanceColumn,
                ),
                Container(
                  width: 74.0,
                  child: buildNumberColumn,
                ),
                Container(
                  width: 72.0,
                  child: stabilityColumn,
                ),
                Container(
                  width: 72.0,
                  child: coverageColumn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
