// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A [Enum] that holds the task data codes.
class TaskDataCode extends Enum<String> {
  /// A [TaskDataCode] that represents a build days created code.
  static const TaskDataCode buildDaysCreated =
      TaskDataCode._('build_days_created');

  /// A [TaskDataCode] that represents a build days updated code.
  static const TaskDataCode buildDaysUpdated =
      TaskDataCode._('build_days_updated');

  /// Creates a new instance of the [TaskDataCode] with the given value.
  const TaskDataCode._(String value) : super(value);

  /// A [Set] that contains all available [TaskDataCode]s.
  static const Set<TaskDataCode> values = {
    buildDaysCreated,
    buildDaysUpdated,
  };

  @override
  String toString() => value;
}
