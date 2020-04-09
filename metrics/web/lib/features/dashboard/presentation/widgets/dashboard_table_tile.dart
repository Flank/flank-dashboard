import 'package:flutter/material.dart';

/// A widget that represents the dashboard table tile.
class DashboardTableTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;

  /// Creates the [DashboardTableTile] with the given [leading] and [trailing].
  ///
  /// Throws an [AssertionError] if either [leading] or [trailing] is null.
  const DashboardTableTile({
    Key key,
    @required this.leading,
    @required this.trailing,
  })  : assert(leading != null),
        assert(trailing != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: leading,
          ),
          Flexible(
            flex: 5,
            child: trailing,
          ),
        ],
      ),
    );
  }
}
