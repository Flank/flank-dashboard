import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/text_placeholder/widgets/text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';

/// A widget that displays a placeholder, providing information
/// that the search has no results.
class NoSearchResultsPlaceholder extends StatelessWidget {
  /// Creates a new instance of the [NoSearchResultsPlaceholder].
  const NoSearchResultsPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context)
        .projectMetricsTableTheme
        .projectMetricsTileTheme;

    return DecoratedContainer(
      height: 144.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        border: Border.all(color: theme.borderColor),
        color: theme.backgroundColor,
      ),
      child: const Center(
        child: TextPlaceholder(text: DashboardStrings.noSearchResults),
      ),
    );
  }
}
