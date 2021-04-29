// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:meta/meta.dart';

/// A class that represents a task to save in the [Firestore].
class TaskData {
  /// A [String] that identifies the task to perform.
  final String code;

  /// A [Map], containing the data needed to run this task.
  final Map<String, dynamic> data;

  /// A [String], containing the additional context for this task.
  final String context;

  /// A [Timestamp], determines when this task is created.
  final Timestamp createdAt;

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
      'code': code,
      'data': data,
      'context': context,
      'createdAt': createdAt,
    };
  }
}
