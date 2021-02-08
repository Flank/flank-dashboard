// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the raw integration configuration.
///
/// Used to define both source and destination configuration maps.
class RawIntegrationConfig extends Equatable {
  /// The configuration of a source the metrics will be loaded from.
  final Map<String, dynamic> sourceConfigMap;

  /// The configuration of a destination storage the loaded metrics
  /// will be saved to.
  final Map<String, dynamic> destinationConfigMap;

  @override
  List<Object> get props => [sourceConfigMap, destinationConfigMap];

  /// Creates a new instance of this config.
  ///
  /// If either [sourceConfigMap] or [destinationConfigMap] is null,
  /// throws an [ArgumentError].
  RawIntegrationConfig({
    @required this.sourceConfigMap,
    @required this.destinationConfigMap,
  }) {
    ArgumentError.checkNotNull(sourceConfigMap, 'sourceConfigMap');
    ArgumentError.checkNotNull(destinationConfigMap, 'destinationConfigMap');
  }
}
