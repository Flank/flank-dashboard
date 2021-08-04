// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';

/// A class that provides a method for converting the [RouteConfiguration]
/// to a location [String].
class RouteConfigurationLocationConverter {
  /// Creates a new instance of the [RouteConfigurationLocationConverter].
  const RouteConfigurationLocationConverter();

  /// Converts the given [routeConfiguration] to a location [String].
  ///
  /// Returns `null` if the given [routeConfiguration] is `null`.
  String convert(RouteConfiguration routeConfiguration) {
    if (routeConfiguration == null) return null;

    final path = routeConfiguration.path;
    final parameters = routeConfiguration.parameters;

    final filteredParameters = _filterQueryParameters(parameters);
    final hasParameters =
        filteredParameters != null && filteredParameters.isNotEmpty;
    final queryParameters = hasParameters ? filteredParameters : null;

    final uri = Uri(path: path, queryParameters: queryParameters);

    return '$uri';
  }

  /// Removes empty and `null` values from the given [queryParameters].
  ///
  /// Returns `null` if the given [queryParameters] is `null` or an empty.
  Map<String, String> _filterQueryParameters(
    Map<String, dynamic> queryParameters,
  ) {
    if (queryParameters == null || queryParameters.isEmpty) return null;

    final filteredParameters = Map<String, String>.from(queryParameters);

    filteredParameters.removeWhere((_, value) => value == null || value.isEmpty);

    return filteredParameters;
  }
}
