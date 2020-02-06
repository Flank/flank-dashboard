import 'package:equatable/equatable.dart';

enum BuildResult { successful, canceled, failed }

/// Represents the build entity.
///
/// Contains the build's [startedAt] date, [result] state, [duration],
/// build [url] and [description] of this build.
class Build extends Equatable {
  final DateTime startedAt;
  final BuildResult result;
  final Duration duration;
  final String description;
  final String url;

  const Build({
    this.startedAt,
    this.result,
    this.duration,
    this.description,
    this.url,
  });

  @override
  List<Object> get props => [startedAt, result, duration, description];
}
