// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/build_day_status_field_name.dart';
import 'package:meta/meta.dart';

/// A class that represents a single status field of the build day.
class BuildDayStatusField {
  /// A name of this field.
  final BuildDayStatusFieldName name;

  /// A value of this field.
  final FieldValue value;

  /// Creates a new instance of the [BuildDayStatusField].
  ///
  /// Throws an [ArgumentError] if either [name] or [value] is `null`.
  BuildDayStatusField({
    @required this.name,
    @required this.value,
  }) {
    ArgumentError.checkNotNull(name, 'name');
    ArgumentError.checkNotNull(value, 'value');
  }

  /// Converts this [BuildDayStatusField] into the [Map].
  Map<String, FieldValue> toMap() {
    return {
      name.value: value,
    };
  }
}
