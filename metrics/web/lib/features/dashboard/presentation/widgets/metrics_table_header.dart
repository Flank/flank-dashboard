import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/metrics_table_tile.dart';

/// Widget that displays the header of the metrics table.
class MetricsTableHeader extends StatelessWidget {
  const MetricsTableHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).textTheme.subtitle1.color,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        child: MetricsTableTile(
          leading: Container(),
          trailing: Builder(builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Container()),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      DashboardStrings.performance,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    DashboardStrings.builds,
                  ),
                ),
                Expanded(
                  child: Text(
                    DashboardStrings.stability,
                  ),
                ),
                Expanded(
                  child: Text(
                    DashboardStrings.coverage,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
