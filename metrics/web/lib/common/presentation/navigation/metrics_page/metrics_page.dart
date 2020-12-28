import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_route.dart';

/// A class that represents a Metrics application page.
class MetricsPage<T> extends Page {
  /// A [Widget] to display as a content of this page.
  final Widget child;

  /// A flag that indicates whether this page should remain in memory
  /// when it is inactive.
  final bool maintainState;

  /// A flag that indicates whether this page is a full-screen dialog.
  final bool fullscreenDialog;

  /// Creates a new instance of the [MetricsPage].
  ///
  /// The [maintainState] defaults to `true`.
  /// The [fullscreenDialog] defaults to `false`.
  ///
  /// The [child], [fullscreenDialog], and [maintainState] must not be null.
  const MetricsPage({
    @required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    LocalKey key,
    String name,
    Object arguments,
  })  : assert(child != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(key: key, name: name, arguments: arguments);

  @override
  Route<T> createRoute(BuildContext context) {
    return MetricsPageRoute<T>(
      settings: this,
      builder: (_) => child,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }
}
