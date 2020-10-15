import 'package:equatable/equatable.dart';

/// A class that represents a duration of a single Github Actions workflow run.
class WorkflowRunDuration extends Equatable {
  /// A [Duration] of the workflow run.
  final Duration duration;

  @override
  List<Object> get props => [duration];

  /// Creates a new instance of the [WorkflowRunDuration].
  const WorkflowRunDuration({
    this.duration,
  });

  /// Creates a new instance of the [WorkflowRunDuration] from the decoded
  /// JSON object.
  ///
  /// Returns `null` if the given [json] is `null`.
  factory WorkflowRunDuration.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final duration = json['run_duration_ms'] == null
        ? null
        : Duration(milliseconds: json['run_duration_ms'] as int);

    return WorkflowRunDuration(
      duration: duration,
    );
  }

  /// Converts this run duration instance into the JSON encodable [Map].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'run_duration_ms': duration?.inMilliseconds,
    };
  }

  @override
  String toString() {
    return 'WorkflowRunDuration ${toJson()}';
  }
}
