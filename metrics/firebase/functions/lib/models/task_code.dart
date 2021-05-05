// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A [Enum] that holds the task codes.
class TaskCode extends Enum<String> {
  /// A [TaskCode] that represents a build days created code.
  static const TaskCode buildDaysCreated = TaskCode._('build_days_created');

  /// A [TaskCode] that represents a build days updated code.
  static const TaskCode buildDaysUpdated = TaskCode._('build_days_updated');

  /// A [Set] that contains all available [TaskCode]s.
  static const Set<TaskCode> values = {
    buildDaysCreated,
    buildDaysUpdated,
  };

  /// Creates a new instance of the [TaskCode] with the given value.
  const TaskCode._(String value) : super(value);

  @override
  String toString() => value;
}
