// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';

/// A class that represents a task to save in the [Firestore].
class TaskData {
  /// A [String] that identifies the task to perform.
  final String code;

  /// A [Map], containing the data needed to run the task.
  final Map data;

  /// A [String], containing the additional context for this task.
  final String context;

  /// A [Timestamp], determine when this task is created.
  final Timestamp day;

  /// Creates a new instance of the [TaskData] with the given parameters.
  TaskData({
    this.code,
    this.data,
    this.context,
    this.day,
  });

  /// Converts this [TaskData] into the [Map].
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'data': data,
      'context': context,
      'day': day,
    };
  }
}
