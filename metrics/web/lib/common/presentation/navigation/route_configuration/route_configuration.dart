// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A class that represents the configuration of the route.
class RouteConfiguration extends Equatable {
  /// A name of this route.
  final RouteName name;

  /// A path of this route that is used to create the application URL.
  final String path;

  /// A flag that indicates whether the authorization is required for this route.
  final bool authorizationRequired;

  /// A [Map] containing parameters of this route.
  final Map<String, dynamic> parameters;

  @override
  List<Object> get props => [
        name,
        path,
        authorizationRequired,
        parameters,
      ];

  /// Creates a new instance of the [RouteConfiguration].
  ///
  /// Throws an [AssertionError] if the given [name] or [authorizationRequired]
  /// is `null`.
  const RouteConfiguration._({
    @required this.name,
    @required this.authorizationRequired,
    this.path,
    this.parameters,
  })  : assert(name != null),
        assert(authorizationRequired != null);

  /// Creates a new instance of the [RouteConfiguration].
  ///
  /// The [name] equals to the [RouteName.loading].
  /// The [authorizationRequired] equals to `false`.
  /// The [path] equals to the [RouteName.loading].
  const RouteConfiguration.loading()
      : this._(
          name: RouteName.loading,
          authorizationRequired: false,
          path: Navigator.defaultRouteName,
          parameters: null,
        );

  /// Creates a new instance of the [RouteConfiguration] with the
  /// given [parameters].
  ///
  /// The [name] equals to the [RouteName.login].
  /// The [authorizationRequired] equals to `false`.
  /// The [path] equals to the [RouteName.login].
  const RouteConfiguration.login({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.login,
          path: '/${RouteName.login}',
          authorizationRequired: false,
          parameters: parameters,
        );

  /// Creates a new instance of the [RouteConfiguration] with the
  /// given [parameters].
  ///
  /// The [name] equals to the [RouteName.dashboard].
  /// The [authorizationRequired] equals to `true`.
  /// The [path] equals to the [RouteName.dashboard].
  const RouteConfiguration.dashboard({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.dashboard,
          authorizationRequired: true,
          path: '/${RouteName.dashboard}',
          parameters: parameters,
        );

  /// Creates a new instance of the [RouteConfiguration] with the
  /// given [parameters].
  ///
  /// The [name] equals to the [RouteName.projectGroups].
  /// The [authorizationRequired] equals to `true`.
  /// The [path] equals to the [RouteName.projectGroups].
  const RouteConfiguration.projectGroups({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.projectGroups,
          authorizationRequired: true,
          path: '/${RouteName.projectGroups}',
          parameters: parameters,
        );

  /// Creates a new instance of the [RouteConfiguration] with the
  /// given [parameters].
  ///
  /// The [name] equals to the [RouteName.debugMenu].
  /// The [authorizationRequired] equals to `true`.
  /// The [path] equals to the [RouteName.debugMenu].
  const RouteConfiguration.debugMenu({
    Map<String, dynamic> parameters,
  }) : this._(
          name: RouteName.debugMenu,
          authorizationRequired: true,
          path: '/${RouteName.debugMenu}',
          parameters: parameters,
        );

  /// Creates the new instance of the [RouteConfiguration]
  /// based on the current instance.
  ///
  /// If any of the passed parameters are `null`, or parameter isn't specified,
  /// the value will be copied from the current instance.
  RouteConfiguration copyWith({
    RouteName name,
    bool authorizationRequired,
    String path,
    Map<String, dynamic> parameters,
  }) {
    return RouteConfiguration._(
      name: name ?? this.name,
      authorizationRequired:
          authorizationRequired ?? this.authorizationRequired,
      path: path ?? this.path,
      parameters: parameters ?? this.parameters,
    );
  }
}
