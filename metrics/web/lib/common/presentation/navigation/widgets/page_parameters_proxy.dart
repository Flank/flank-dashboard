// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/checker/handle_page_parameters_checker.dart';
import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:provider/provider.dart';

/// A [Widget] that purposes to handle a connection between
/// the [NavigationNotifier] and a specific [PageNotifier].
class PageParametersProxy extends StatefulWidget {
  /// A [PageNotifier] that provides an ability to handle page parameters.
  final PageNotifier pageNotifier;

  /// A [Widget] below the [PageParametersProxy] in the tree.
  final Widget child;

  /// Creates a new instance of the [PageParametersProxy] with the given
  /// parameters.
  ///
  /// Throws an `AssertionError` if the given [pageNotifier] or [child]
  /// is `null`.
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

/// A class that contains the logic and internal state
/// of the [PageParametersProxy] widget.
class _PageParametersProxyState extends State<PageParametersProxy> {
  /// A [ChangeNotifier] that manages navigation.
  NavigationNotifier _navigationNotifier;

  /// A [PageNotifier] that provides an ability to handle page parameters.
  PageNotifier get _pageNotifier => widget.pageNotifier;

  /// A class that shows if page parameters can be handled by dashboard.
  HandlePageParametersChecker _handlePageParametersChecker;

  @override
  void initState() {
    super.initState();

    _handlePageParametersChecker = HandlePageParametersChecker();
    _subscribeToNavigationNotifierUpdates();
    _subscribeToPageNotifierUpdates();
  }

  /// Subscribes to [NavigationNotifier]'s updates.
  void _subscribeToNavigationNotifierUpdates() {
    _navigationNotifier = Provider.of<NavigationNotifier>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationNotifierListener();
    });

    _navigationNotifier.addListener(_navigationNotifierListener);
  }

  /// Updates the [PageParametersModel] of the [PageNotifier].
  void _navigationNotifierListener() {
    final pageParameters = _navigationNotifier.currentPageParameters;

    if (_handlePageParametersChecker.canHandle(
      configuration: _navigationNotifier.currentConfiguration,
      pageNotifier: _pageNotifier,
    )) {
      _pageNotifier.handlePageParameters(pageParameters);
    }
  }

  /// Subscribes to [PageNotifier]'s updates.
  void _subscribeToPageNotifierUpdates() {
    _pageNotifier.addListener(_pageNotifierListener);
  }

  /// Handles the [PageParametersModel] updates using the [NavigationNotifier].
  void _pageNotifierListener() {
    final pageParameters = _pageNotifier.pageParameters;

    _navigationNotifier.handlePageParametersUpdates(pageParameters);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _navigationNotifier.removeListener(_navigationNotifierListener);
    _pageNotifier.removeListener(_pageNotifierListener);
    super.dispose();
  }
}
