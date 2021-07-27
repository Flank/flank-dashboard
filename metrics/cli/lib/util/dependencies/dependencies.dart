// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/dependency.dart';
import 'package:equatable/equatable.dart';

/// A class that holds [Dependency]s for all 3-rd party services.
class Dependencies extends Equatable {
  /// A [Map] containing the [Dependency] for each service.
  final Map<String, Dependency> _dependencies;

  @override
  List<Object> get props => [_dependencies];

  /// Creates a new instance of [Dependencies] using the
  /// given [Map].
  ///
  /// Throws an [ArgumentError] if the given [Map] is `null`.
  Dependencies(this._dependencies) {
    ArgumentError.checkNotNull(_dependencies, 'dependencies');
  }

  /// Creates a new instance of [Dependencies] from the given [map].
  ///
  /// Returns `null` if the given [map] is `null`.
  factory Dependencies.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    final dependencies = <String, Dependency>{};
    map.forEach((key, value) {
      dependencies[key] = Dependency.fromMap(value as Map<String, dynamic>);
    });

    return Dependencies(dependencies);
  }

  /// Returns a corresponding [Dependency] for the given [service].
  Dependency getFor(String service) {
    return _dependencies[service];
  }
}
