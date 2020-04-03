import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/config/dashboard_widget_config.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';

/// Widget that displays the titles of the metrics.
class MetricsTitle extends StatelessWidget {
  const MetricsTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: DashboardWidgetConfig.leadingFlex,
            child: Container(),
          ),
          Flexible(
            flex: DashboardWidgetConfig.trailingFlex,
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.clip,
              maxLines: 1,
              child: Row(
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
            ),
          ),
        ],
      ),
    );
  }
}
