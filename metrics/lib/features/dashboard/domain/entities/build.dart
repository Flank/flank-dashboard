import 'package:equatable/equatable.dart';

enum BuildResult { successful, canceled, failed }

/// Represents the build entity.
class Build extends Equatable {
  final DateTime startedAt;
  final BuildResult result;
  final Duration duration;
  final String description;

  const Build({
    this.startedAt,
    this.result,
    this.duration,
    this.description,
  });

  @override
  List<Object> get props => [startedAt, result, duration, description];
}
