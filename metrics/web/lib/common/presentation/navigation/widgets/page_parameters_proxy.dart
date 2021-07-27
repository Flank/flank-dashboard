import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:provider/provider.dart';

/// A [Widget] that purposes to handle a connection between
/// the [NavigationNotifier] and a specific [PageNotifier].
class PageParametersProxy extends StatefulWidget {
  /// The [PageNotifier] that provides an ability to handle page parameters.
  final PageNotifier pageNotifier;

  /// A [Widget] below the [PageParametersProxy] in the tree.
  final Widget child;

  /// Creates the [PageParametersProxy] with the given parameters.
  ///
  /// The [pageNotifier] must not be `null`.
  /// The [child] must not be `null`.
  const PageParametersProxy({
    Key key,
    @required this.pageNotifier,
    @required this.child,
  })  : assert(pageNotifier != null),
        assert(child != null),
        super(key: key);

  @override
  _PageParametersProxyState createState() => _PageParametersProxyState();
}

/// The logic and internal state for the [PageParametersProxy] widget.
class _PageParametersProxyState extends State<PageParametersProxy> {
  /// The [ChangeNotifier] that manages navigation.
  NavigationNotifier _navigationNotifier;

  @override
  void initState() {
    super.initState();

    _subscribeToNavigationNotifierUpdates();
    _subscribeToPageNotifierUpdates();
  }

  /// Subscribes to [NavigationNotifier]'s updates.
  void _subscribeToNavigationNotifierUpdates() {
    _navigationNotifier = Provider.of<NavigationNotifier>(
      context,
      listen: false,
    );

    _navigationNotifier.addListener(_navigationNotifierListener);
  }

  /// Updates the [PageParametersModel] of the [PageNotifier].
  void _navigationNotifierListener() {
    final pageParameters = _navigationNotifier.currentPageParameters;

    widget.pageNotifier.handlePageParameters(pageParameters);
  }

  /// Subscribes to [PageNotifier]'s updates.
  void _subscribeToPageNotifierUpdates() {
    widget.pageNotifier.addListener(_pageNotifierListener);
  }

  /// Handles the [PageParametersModel] updates using the [NavigationNotifier].
  void _pageNotifierListener() {
    _navigationNotifier.handlePageParametersUpdates(
      widget.pageNotifier.parameters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
