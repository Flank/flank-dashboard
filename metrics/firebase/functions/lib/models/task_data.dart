// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/models/task_code.dart';
import 'package:meta/meta.dart';

/// A class that represents a task to save in the [Firestore].
class TaskData {
  /// A [TaskCode] that identifies the task to perform.
  final TaskCode code;

  /// A [Map] containing the data needed to run this task.
  final Map<String, dynamic> data;

  /// A [String] containing the additional context for this task.
  final String context;

  /// A [DateTime] determines when this task is created.
  final DateTime createdAt;

  /// Creates a new instance of the [TaskData] with the given parameters.
  ///
  /// Throws an [ArgumentError] if either [code] or [createdAt] is `null`.
  TaskData({
    @required this.code,
    @required this.createdAt,
    this.data,
    this.context,
  }) {
    ArgumentError.checkNotNull(code, 'code');
    ArgumentError.checkNotNull(createdAt, 'createdAt');
  }

  /// Converts this [TaskData] into the [Map].
  Map<String, dynamic> toMap() {
    return {
      'code': code?.value,
      'data': data,
      'context': context,
      'createdAt': Timestamp.fromDateTime(createdAt),
    };
  }
}
