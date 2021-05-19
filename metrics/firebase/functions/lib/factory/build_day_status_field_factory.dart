// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/mappers/build_day_status_field_name_mapper.dart';
import 'package:functions/models/build_day_status_field.dart';
import 'package:meta/meta.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides method for creating [BuildDayStatusField]s.
class BuildDayStatusFieldFactory {
  /// A [BuildDayStatusFieldNameMapper] that is used to map a [BuildStatus] into
  /// the [BuildDayStatusField.name].
  final BuildDayStatusFieldNameMapper _statusFieldMapper;

  /// Creates a new instance of the [BuildDayStatusFieldFactory]
  /// with the given [BuildDayStatusFieldNameMapper].
  ///
  /// The status field mapper defaults to the [BuildDayStatusFieldNameMapper]
  /// instance.
  ///
  /// Throws an [ArgumentError] if the given status field mapper is `null`.
  BuildDayStatusFieldFactory([
    this._statusFieldMapper = const BuildDayStatusFieldNameMapper(),
  ]) {
    ArgumentError.checkNotNull(_statusFieldMapper, 'statusFieldMapper');
  }

  /// Creates a [BuildDayStatusField] using the given [buildStatus]
  /// and the [incrementCount].
  ///
  /// Throws an [ArgumentError] if the given [buildStatus] or
  /// [incrementCount] is `null`.
  BuildDayStatusField create({
    @required BuildStatus buildStatus,
    @required int incrementCount,
  }) {
    ArgumentError.checkNotNull(buildStatus, 'buildStatus');
    ArgumentError.checkNotNull(incrementCount, 'incrementCount');

    final buildDayStatusFieldName = _statusFieldMapper.map(buildStatus);

    return BuildDayStatusField(
      name: buildDayStatusFieldName,
      value: Firestore.fieldValues.increment(incrementCount),
    );
  }
}
