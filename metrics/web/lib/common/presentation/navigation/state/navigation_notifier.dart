// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_state.dart';
import 'package:rxdart/rxdart.dart';

/// A signature for the function that tests the given [MetricsPage] for certain
/// conditions.
typedef MetricsPagePredicate = bool Function(MetricsPage);

///
abstract class PageParameters {
  ///
  const PageParameters();

  ///
  Map<String, dynamic> toQueryParameters();
}

///
class DashboardPageParameters implements PageParameters {
  ///
  final String selectedProjectGroup;

  ///
  const DashboardPageParameters({
    @required this.selectedProjectGroup,
  });

  ///
  factory DashboardPageParameters.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DashboardPageParameters(
      selectedProjectGroup: map['selectedProjectGroup'] as String,
    );
  }

  @override
  Map<String, dynamic> toQueryParameters() {
    return {
      if (selectedProjectGroup != null)
        'selectedProjectGroup': selectedProjectGroup,
    };
  }
}

/// A [ChangeNotifier] that manages navigation.
class NavigationNotifier extends ChangeNotifier {
  ///
  final BehaviorSubject<PageParameters> _pageParametersStream =
      BehaviorSubject();

  ///
  PageParameters _pendingPageParameters;

  ///
  Stream<PageParameters> get pageParametersStream => _pageParametersStream;

  /// A [NavigationState] used to interact with the current navigation state.
  final NavigationState _navigationState;

  /// A [MetricsPageFactory] that provides an ability to create a [MetricsPage]
  /// from [RouteConfiguration].
  final MetricsPageFactory _pageFactory;

  /// A stack of [MetricsPage]s to use by navigator.
  final List<MetricsPage> _pages = [];

  /// A [RouteConfiguration] that represents the current page route.
  RouteConfiguration _currentConfiguration;

  /// A [RouteConfiguration] redirect to when the application finishes
  /// initialization.
  RouteConfiguration _redirectRoute;

  /// A flag that indicates whether the user is logged in.
  bool _isUserLoggedIn = false;

  /// A flag that indicates whether the application is finished loading.
  bool _isAppInitialized = false;

  /// Provides an [UnmodifiableListView] of [MetricsPage]s to use in navigation.
  UnmodifiableListView<MetricsPage> get pages => UnmodifiableListView(_pages);

  /// Provides a [RouteConfiguration] that describes the navigation state.
  RouteConfiguration get currentConfiguration => _currentConfiguration;

  /// Creates a new instance of the [NavigationNotifier]
  /// with the given [MetricsPageFactory].
  ///
  /// Throws an [AssertionError] if the given [MetricsPageFactory] is `null`.
  NavigationNotifier(
    this._pageFactory,
    NavigationState navigationState,
  )   : assert(_pageFactory != null),
        assert(navigationState != null),
        _navigationState = navigationState;

  /// Handles the authentication update represented by the given [isLoggedIn].
  ///
  /// Clears the pages stack and pushes the [MetricsRoutes.login]
  /// after the user logs out.
  void handleAuthenticationUpdates({
    bool isLoggedIn,
  }) {
    if (_isUserLoggedIn == isLoggedIn) return;

    final currentPageName = currentConfiguration?.name;
    _isUserLoggedIn = isLoggedIn ?? false;

    if (!_isUserLoggedIn && currentPageName != MetricsRoutes.login.name) {
      _pages.clear();

      push(MetricsRoutes.login);
    }
  }

  /// Handles the application's initialization state update represented by the
  /// given [isAppInitialized].
  ///
  /// If the [isAppInitialized] is `true`, redirects to the redirect route.
  ///
  /// Throws an [ArgumentError] if the given [isAppInitialized] is `null`.
  void handleAppInitialized({
    @required bool isAppInitialized,
  }) {
    ArgumentError.checkNotNull(isAppInitialized, 'isAppInitialized');

    _isAppInitialized = isAppInitialized;

    if (_isAppInitialized) _redirect();
  }

  /// Removes the current page and navigates to the previous one.
  void pop() {
    if (_pages.length <= 1) return;

    _pages.removeLast();

    final currentPage = _pages.last;
    final newConfiguration = _getConfigurationFromPage(currentPage);

    _currentConfiguration = newConfiguration;

    _updatePageParameters();

    notifyListeners();
  }

  /// Pushes the route created from the given [configuration].
  void push(RouteConfiguration configuration) {
    _addNewPage(configuration);
    notifyListeners();
  }

  /// Replaces the current route with the route created from the given
  /// [configuration].
  void pushReplacement(RouteConfiguration configuration) {
    if (_pages.isNotEmpty) _pages.removeLast();

    push(configuration);
  }

  /// Replaces the current navigation state with the given parameters.
  void replaceState({
    dynamic data,
    String title = 'metrics',
    RouteConfiguration routeConfiguration,
  }) {
    _navigationState.replaceState(data, title, routeConfiguration.toLocation());
  }

  /// Removes all underlying pages until the [predicate] returns `true`
  /// or the stack of pages is empty and pushes the route created from the given
  /// [configuration].
  void pushAndRemoveUntil(
    RouteConfiguration configuration,
    MetricsPagePredicate predicate,
  ) {
    while (_pages.isNotEmpty) {
      final page = _pages.last;

      if (predicate(page)) break;

      _pages.removeLast();
    }

    push(configuration);
  }

  /// Replaces the current route with the route created from the given
  /// [configuration] and replaces the current state path with
  /// the path of the pushed route configuration.
  void pushStateReplacement(RouteConfiguration configuration) {
    if (_pages.isNotEmpty) _pages.removeLast();

    push(configuration);
    replaceState(
      routeConfiguration: _currentConfiguration,
    );
  }

  /// Handles the initial route.
  void handleInitialRoutePath(RouteConfiguration configuration) {
    _addNewPage(configuration);
  }

  /// Handles the new route.
  void handleNewRoutePath(RouteConfiguration configuration) {
    push(configuration);
  }

  /// Redirects to the redirect route and clears it.
  ///
  /// If the redirect route is [MetricsRoutes.loading] or `null`,
  /// redirects to the [MetricsRoutes.dashboard].
  void _redirect() {
    if (_redirectRoute == null || _redirectRoute == MetricsRoutes.loading) {
      _redirectRoute = MetricsRoutes.dashboard;
    }

    _pages.clear();
    push(_redirectRoute);
    _redirectRoute = null;
  }

  /// Creates a [RouteConfiguration] using the given [page].
  RouteConfiguration _getConfigurationFromPage(MetricsPage page) {
    return page?.arguments as RouteConfiguration;
  }

  /// Adds a new page created from the given [configuration] to the [pages].
  void _addNewPage(RouteConfiguration configuration) {
    final newConfiguration = _processConfiguration(configuration);

    _currentConfiguration = newConfiguration;

    final newPage = _pageFactory.create(_currentConfiguration);

    _pages.add(newPage);

    _updatePageParameters();
  }

  /// Processes the given [configuration] depending on [_isAppInitialized] state,
  /// [configuration]'s authorization requirements and current
  /// [_isUserLoggedIn] state.
  ///
  /// If the application is not initialized, returns [MetricsRoutes.loading]
  /// and saves the [_redirectRoute].
  ///
  /// If the user is not logged in and the given [configuration]
  /// requires authorization, returns [MetricsRoutes.login]
  ///
  /// Otherwise, returns [configuration].
  RouteConfiguration _processConfiguration(
    RouteConfiguration configuration,
  ) {
    if (!_isAppInitialized) {
      _redirectRoute = configuration;

      return MetricsRoutes.loading.copyWith(path: configuration.toLocation());
    }

    final authorizationRequired = configuration.authorizationRequired;

    if (!_isUserLoggedIn && authorizationRequired) return MetricsRoutes.login;

    return configuration;
  }

  ///
  void _updatePageParameters() {
    final queryParameters = _currentConfiguration.queryParameters ?? {};

    if (_currentConfiguration.name == RouteName.dashboard) {
      final pageParameters = DashboardPageParameters.fromMap(queryParameters);

      if (pageParameters != null) _addPageParameters(pageParameters);
    }
  }

  void _addPageParameters(PageParameters pageParameters) {
    _pageParametersStream.add(pageParameters);
  }
}
