import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_route.dart';

/// A class that holds a configuration for the [Route].
class MetricsPage<T> extends Page {
  /// A [Widget] to display as a content of this page.
  final Widget child;

  /// Whether this page should remain in memory when it is inactive.
  final bool maintainState;

  /// Whether this page is a full-screen dialog.
  final bool fullscreenDialog;

  /// Creates a new instance of the [MetricsPage].
  ///
  /// The [maintainState] default value is `true`.
  /// The [fullscreenDialog] default value is `false`.
  ///
  /// All the parameters must not be null.
  const MetricsPage({
    @required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
  })  : assert(child != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null);

  @override
  Route<T> createRoute(BuildContext context) {
    return MetricsPageRoute<T>(
      settings: this,
      builder: (context) => child,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }
}
