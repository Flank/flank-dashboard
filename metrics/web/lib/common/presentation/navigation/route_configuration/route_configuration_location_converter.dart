import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration.dart';

/// A class that provides a method for converting the given [RouteConfiguration]
/// to a location [String].
class RouteConfigurationLocationConverter {
  /// Converts the given [routeConfiguration] to a location [String].
  ///
  /// Returns `null` if the given [routeConfiguration] is `null`.
  String convert(RouteConfiguration routeConfiguration) {
    if (routeConfiguration == null) return null;

    final path = routeConfiguration.path;

    final parameters = routeConfiguration.parameters;
    final queryParameters = parameters.isNotEmpty ? parameters : null;

    final uri = Uri(path: path, queryParameters: queryParameters);

    return '$uri';
  }
}
