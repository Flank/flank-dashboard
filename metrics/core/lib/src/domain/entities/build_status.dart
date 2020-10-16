import 'package:metrics_core/src/domain/entities/build.dart';

/// Represents the status the [Build] was finished with.
enum BuildStatus {
  /// Indicates a successful finishing of the [Build].
  successful,

  /// Indicates a failed finishing of the [Build].
  failed,

  /// Indicates an unknown finishing of the [Build].
  unknown,
}
