// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A class that represents the configuration of the route.
class RouteConfiguration extends Equatable {
  /// A name of this route.
  final RouteName name;

  /// A path of this route that is used to create the application URL.
  final String path;

  /// A flag that indicates whether the authorization is required for this route.
  final bool authorizationRequired;

  /// A flag that indicates whether this route can be accessed
  /// if sign-in anonymously.
  final bool allowsAnonymousAccess;

  /// A [Map] containing parameters of this route.
  final Map<String, dynamic> parameters;

  @override
  List<Object> get props => [
        name,
        path,
        authorizationRequired,
        allowsAnonymousAccess,
        parameters,
      ];

  /// Creates a new instance of the [RouteConfiguration].
  ///
  /// Throws an [AssertionError] if the given [name], [authorizationRequired]
  /// or [allowsAnonymousAccess] is `null`.
  const RouteConfiguration._({
    @required this.name,
    @required this.authorizationRequired,
    @required this.allowsAnonymousAccess,
    this.path,
    this.parameters,
  })  : assert(name != null),
        assert(authorizationRequired != null),
        assert(allowsAnonymousAccess != null);

  /// Creates a new instance of the [RouteConfiguration] for the
  /// [RouteName.loading] route.
  const RouteConfiguration.loading()
      : this._(
          name: RouteName.loading,
          authorizationRequired: false,
          allowsAnonymousAccess: true,
          path: Navigator.defaultRouteName,
          parameters: null,
        );

  /// Creates a new instance of the [RouteConfiguration] for the
  /// [RouteName.login] route with the given [parameters].
  const RouteConfiguration.login({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.login,
          authorizationRequired: false,
          allowsAnonymousAccess: true,
          path: '/${RouteName.login}',
          parameters: parameters,
        );

  /// Creates a new instance of the [RouteConfiguration] for the
  /// [RouteName.dashboard] route with the given [parameters].
  const RouteConfiguration.dashboard({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.dashboard,
          authorizationRequired: true,
          allowsAnonymousAccess: true,
          path: '/${RouteName.dashboard}',
          parameters: parameters,
        );

  /// Creates a new instance of the [RouteConfiguration] for the
  /// [RouteName.projectGroups] route with the given [parameters].
  const RouteConfiguration.projectGroups({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.projectGroups,
          authorizationRequired: true,
          allowsAnonymousAccess: false,
          path: '/${RouteName.projectGroups}',
          parameters: parameters,
        );

  /// Creates a new instance of the [RouteConfiguration] for the
  /// [RouteName.debugMenu] route with the given [parameters].
  const RouteConfiguration.debugMenu({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.debugMenu,
          authorizationRequired: true,
          allowsAnonymousAccess: true,
          path: '/${RouteName.debugMenu}',
          parameters: parameters,
        );

  /// An [UnmodifiableSetView] that contains all available [RouteConfiguration]s.
  static final Set<RouteConfiguration> values = UnmodifiableSetView({
    DefaultRoutes.loading,
    DefaultRoutes.login,
    DefaultRoutes.dashboard,
    DefaultRoutes.projectGroups,
    DefaultRoutes.debugMenu,
  });

  /// Creates the new instance of the [RouteConfiguration]
  /// based on the current instance.
  ///
  /// If any of the passed parameters are `null`, or parameter isn't specified,
  /// the value will be copied from the current instance.
  RouteConfiguration copyWith({
    RouteName name,
    bool authorizationRequired,
    bool allowsAnonymousAccess,
    String path,
    Map<String, dynamic> parameters,
  }) {
    return RouteConfiguration._(
      name: name ?? this.name,
      authorizationRequired:
          authorizationRequired ?? this.authorizationRequired,
      allowsAnonymousAccess:
          allowsAnonymousAccess ?? this.allowsAnonymousAccess,
      path: path ?? this.path,
      parameters: parameters ?? this.parameters,
    );
  }
}
