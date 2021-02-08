// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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

  @override
  List<Object> get props => [name, path, authorizationRequired];

  /// Creates a new instance of the [RouteConfiguration].
  ///
  /// The [name] and [authorizationRequired] must not be null.
  const RouteConfiguration({
    @required this.name,
    @required this.authorizationRequired,
    this.path,
  })  : assert(name != null),
        assert(authorizationRequired != null);

  /// Creates the new instance of the [RouteConfiguration]
  /// based on the current instance.
  ///
  /// If any of the passed parameters are `null`, or parameter isn't specified,
  /// the value will be copied from the current instance.
  RouteConfiguration copyWith({
    RouteName name,
    bool authorizationRequired,
    String path,
  }) {
    return RouteConfiguration(
      name: name ?? this.name,
      authorizationRequired:
          authorizationRequired ?? this.authorizationRequired,
      path: path ?? this.path,
    );
  }
}
