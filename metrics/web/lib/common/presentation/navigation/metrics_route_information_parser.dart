// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_factory.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_location_converter.dart';

/// A [RouteInformationParser] that parses the [RouteInformation]
/// into the [RouteConfiguration] and vice versa.
class MetricsRouteInformationParser
    extends RouteInformationParser<RouteConfiguration> {
  /// A factory needed to create a [RouteConfiguration] depending on the [Uri].
  final RouteConfigurationFactory _routeConfigurationFactory;

  /// A converter needed to create a location [String] from the
  /// [RouteConfiguration].
  final RouteConfigurationLocationConverter _locationConverter;

  /// Creates a new instance of the [MetricsRouteInformationParser].
  ///
  /// Throws an [AssertionError] if the given [RouteConfigurationFactory] or
  /// [RouteConfigurationLocationConverter] is `null`.
  MetricsRouteInformationParser(
    this._routeConfigurationFactory,
    this._locationConverter,
  )   : assert(_routeConfigurationFactory != null),
        assert(_locationConverter != null);

  @override
  Future<RouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    Uri uri;

    if (routeInformation?.location != null) {
      uri = Uri.tryParse(routeInformation.location);
    }

    return SynchronousFuture(_routeConfigurationFactory.create(uri));
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfiguration configuration) {
    if (configuration == null) return null;

    final location = _locationConverter.convert(configuration);

    return RouteInformation(location: location);
  }
}
