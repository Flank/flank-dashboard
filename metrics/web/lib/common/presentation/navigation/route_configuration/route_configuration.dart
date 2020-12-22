import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_name.dart';

/// A class that represents the configuration of the route.
class RouteConfiguration extends Equatable {
  /// A name of this route.
  final RouteName name;

  /// A route path used to create the application URL.
  final String path;

  /// A flag that detects whether the authorization is required for this route.
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
}
