import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/common/presentation/text_placeholder/widgets/text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';

/// A widget that displays a [DashboardStrings.noSearchResults] text inside a bordered container.
class NoSearchResultsPlaceholder extends StatelessWidget {
  const NoSearchResultsPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      width: 1140.0,
      height: 144.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: const Color(0xff0e0d0d)),
      ),
      child: Center(
        child: TextPlaceholder(text: DashboardStrings.noSearchResults),
      ),
    );
  }
}
