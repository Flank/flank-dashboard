// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
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
    final pageParameters = widget.pageNotifier.pageParameters;

    _navigationNotifier.handlePageParametersUpdates(pageParameters);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _navigationNotifier.removeListener(_navigationNotifierListener);
    widget.pageNotifier.removeListener(_pageNotifierListener);
    super.dispose();
  }
}
