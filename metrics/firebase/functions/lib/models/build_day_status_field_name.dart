// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A [Enum] that holds status field names of the documents in the build days
/// collection.
class BuildDayStatusFieldName extends Enum<String> {
  /// A [BuildDayStatusFieldName] that represents a successful build day
  /// status field name.
  static const BuildDayStatusFieldName successful =
      BuildDayStatusFieldName._('successful');

  /// A [BuildDayStatusFieldName] that represents a failed build day status
  /// field name.
  static const BuildDayStatusFieldName failed =
      BuildDayStatusFieldName._('failed');

  /// A [BuildDayStatusFieldName] that represents an unknown build day status
  /// field name.
  static const BuildDayStatusFieldName unknown =
      BuildDayStatusFieldName._('unknown');

  /// A [BuildDayStatusFieldName] that represents an inProgress build day
  /// status field name.
  static const BuildDayStatusFieldName inProgress =
      BuildDayStatusFieldName._('inProgress');

  /// A [Set] that contains all available [BuildDayStatusFieldName]s.
  static const Set<BuildDayStatusFieldName> values = {
    successful,
    failed,
    unknown,
    inProgress,
  };

  /// Creates a new instance of the [BuildDayStatusFieldName] with the given
  /// value.
  const BuildDayStatusFieldName._(String value) : super(value);

  @override
  String toString() => value;
}
