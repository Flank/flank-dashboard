import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';

/// A widget that displays a [DashboardStrings.noSearchResults] text in a center.
class NoSearchResultsPlaceholder extends StatelessWidget {
  const NoSearchResultsPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: DecoratedContainer(
        width: 1140.0,
        height: 144.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.0),
          border: Border.all(color: const Color(0xff0e0d0d)),
        ),
        child: const Center(
          child: Text(
            DashboardStrings.noSearchResults,
            style: TextStyle(
              color: Color(0xff51585c),
              fontFamily: 'Roboto',
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
