import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/constants/metrics_routes.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page.dart';
import 'package:metrics/common/presentation/navigation/metrics_page/metrics_page_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';

/// A signature for the function that tests the given [MetricsPage] for certain
/// conditions.
typedef MetricsPagePredicate = bool Function(MetricsPage);

/// A [ChangeNotifier] that manages navigation.
class NavigationNotifier extends ChangeNotifier {
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
  ) : assert(_pageFactory != null);

  /// Handles the authentication update represented by the given [isLoggedIn].
  ///
  /// Clears the pages stack after the user logs out.
  void handleAuthenticationUpdates({
    bool isLoggedIn,
  }) {
    _isUserLoggedIn = isLoggedIn ?? false;

    if (!isLoggedIn) _pages.clear();
  }

  /// Handles the application's initialization state update represented by the
  /// given [isAppInitialized].
  ///
  /// Redirects to the redirect route if the [isAppInitialized] is `true`.
  void handleAppInitialized({
    @required bool isAppInitialized,
  }) {
    ArgumentError.checkNotNull(isAppInitialized, 'isAppInitialized');

    _isAppInitialized = isAppInitialized;

    if (_isAppInitialized) _redirect();
  }

  /// Redirects to [MetricsRoutes.dashboard] and clears the [_redirectRoute]
  /// if the [_redirectRoute] is [MetricsRoutes.loading].
  ///
  /// Redirects to the [MetricsRoutes.dashboard]
  /// if the [_redirectRoute] is `null`.
  ///
  /// Otherwise, redirects to the [_redirectRoute] and clears it.
  void _redirect() {
    if (_redirectRoute == MetricsRoutes.loading) {
      push(MetricsRoutes.dashboard);
      _redirectRoute = null;
      return;
    }

    if (_redirectRoute == null) {
      push(MetricsRoutes.dashboard);
      return;
    }

    push(_redirectRoute);
    _redirectRoute = null;
  }

  /// Removes the current page and navigates to the previous one.
  void pop() {
    if (_pages.length <= 1) return;

    _pages.removeLast();

    final currentPage = _pages.last;
    final newConfiguration = _getConfigurationFromPage(currentPage);

    _currentConfiguration = newConfiguration;

    notifyListeners();
  }

  /// Pushes the route created from the given [configuration].
  void push(RouteConfiguration configuration) {
    final newConfiguration = _processConfiguration(configuration);

    _currentConfiguration = newConfiguration;

    final newPage = _pageFactory.create(_currentConfiguration);

    _pages.add(newPage);

    notifyListeners();
  }

  /// Replaces the current route with the route created from the given
  /// [configuration].
  void pushReplacement(RouteConfiguration configuration) {
    if (_pages.isNotEmpty) _pages.removeLast();

    push(configuration);
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

  /// Handles the initial route.
  void handleInitialRoutePath(RouteConfiguration configuration) {
    push(configuration);
  }

  /// Handles the new route.
  void handleNewRoutePath(RouteConfiguration configuration) {
    push(configuration);
  }

  /// Creates a [RouteConfiguration] using the given [page].
  RouteConfiguration _getConfigurationFromPage(MetricsPage page) {
    final name = page?.name;

    final configuration = MetricsRoutes.values.firstWhere(
      (route) => route.name.value == name,
      orElse: () => MetricsRoutes.dashboard,
    );

    return configuration;
  }

  /// Processes the given [configuration] depending on [_isAppInitialized] state,
  /// [configuration]'s authorization requirements and current
  /// [_isUserLoggedIn] state.
  ///
  /// Returns [MetricsRoutes.loading] and saves the [_redirectRoute]
  /// if the application is not initialized.
  ///
  /// Returns [configuration] if the user is logged in.
  ///
  /// Returns [configuration] if the user is not logged in and the given
  /// [configuration] does not require authorization.
  ///
  /// Otherwise, returns [MetricsRoutes.login].
  RouteConfiguration _processConfiguration(
    RouteConfiguration configuration,
  ) {
    if (!_isAppInitialized) {
      _redirectRoute = configuration;

      return MetricsRoutes.loading;
    }

    final noAuthorizationRequired = !configuration.authorizationRequired;

    if (_isUserLoggedIn || noAuthorizationRequired) return configuration;

    return MetricsRoutes.login;
  }
}
