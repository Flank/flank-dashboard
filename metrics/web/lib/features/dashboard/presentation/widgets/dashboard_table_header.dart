import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/dashboard_table_tile.dart';

/// Widget that displays the header of the metrics table.
class DashboardTableHeader extends StatelessWidget {
  const DashboardTableHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardTableTile(
      leading: Container(),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Container()),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                DashboardStrings.performance,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Text(
              DashboardStrings.builds,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              DashboardStrings.stability,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              DashboardStrings.coverage,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
